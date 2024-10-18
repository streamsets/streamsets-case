# (C) Copyright IBM Corp. 2020  All Rights Reserved.
#
# This script implements/overrides the abstract functions defined in launch.sh interface

# operator specific variables
caseName=ibm-streamsets
inventory=streamsetsOperator
caseCatalogName=ibm-cpd-streamsets-operator-catalog
channelName=operator-sdk-run-bundle
subscriptionName=ibm-cpd-streamsets-operator-subscription

# variables specific to catalog installation
# catalogNamespace="openshift-marketplace"

# implement functions to install or uninstall products
# example

# parse additional dynamic args
parse_custom_dynamic_args() {
    echo "Action not supported"
}

install_operator_group() {

    echo "------------- Installing operator group for $namespace -------------"

    setup_defintion_files="${casePath}/inventory/streamsetsOperator/files"
    local opgrp_file="${setup_defintion_files}/op-olm/operator-group.yaml"
    validate_file_exists "${opgrp_file}"

    operatorgourpexist=$($kubernetesCLI get operatorgroup -n ${namespace} --no-headers 2>/dev/null|wc -l)
    if [[ ${operatorgourpexist} -ne 0 ]]; then
        echo "Operator group already exist in namespace ${namespace}, skip creation"
    else
        sed <"${opgrp_file}"  "s#NAMESPACE#${namespace}#g" | $kubernetesCLI -n ${namespace} apply ${dryRun} -f -
    fi
    echo "done"
}

# Installs the catalog source and operator group
install_catalog() {

    validate_install_catalog

    # install all catalogs of subcases first
    if [[ ${recursive_action} -eq 1 ]]; then
        install_dependent_catalogs
    fi

    echo "-------------Installing catalog source-------------"

    local catsrc_file="${casePath}/inventory/${inventory}/files/op-olm/catalog-source.yaml"
    CATALOG_IMAGE_FULL_PATH=${OPERATOR_REGISTRY}/${CATALOG_IMAGE}@${CATALOG_DIGEST}

    # Verfy expected yaml files for install exit
    validate_file_exists "${catsrc_file}"

    # Apply yaml files manipulate variable input as required
    if [[ -z $registry ]]; then
        # If an additional arg named registry is NOT passed in, then just apply
        $kubernetesCLI apply ${dryRun} -f ${catsrc_file} -n ${namespace}
    else
        # If an additional arg named registry is passed in, then adjust the name of the image and apply
        local catsrc_image_orig=$(grep "image:" "${catsrc_file}" | awk '{print$2}')

        # replace original registry with local registry
        local catsrc_image_mod="${registry}/$(echo "${CATALOG_IMAGE_FULL_PATH}" | sed -e "s/[^/]*\///")"

        # specical handle of staging registry for testing.
        # replace cp.stg.icr.io/cp/<image name>:<tag>
        if [[ ${registry} == "cp.stg.icr.io" ]]; then
            local catsrc_image_mod="${registry}/cp/$(echo "${CATALOG_IMAGE_FULL_PATH}" | sed -e "s/.*\///")"
        fi

        # apply catalog source
        sed -e "s|${catsrc_image_orig}|${catsrc_image_mod}|g" "${catsrc_file}" | tee >($kubernetesCLI apply ${dryRun} -f -) | cat
    fi

    echo "done"
}

# Install utilizing default OLM method
install_operator() {
    echo "Installing Operator, Please Wait..."
    # create catalog source
    install_catalog
    count=`$kubernetesCLI get pods -n ${namespace} | grep "1/1" | grep -c ${caseCatalogName}` || true
    iter=1
    while [ $count -ne 1 ]; do
      echo "Pod is starting..."
      count=`$kubernetesCLI get pods -n ${namespace} | grep "1/1" | grep -c ${caseCatalogName}` || true
      sleep 30
      iter=$((iter + 1))
      if [[ $iter -gt 5 ]]; then
        echo "Catalog Pod failed to start, please check status below"
        $kubernetesCLI get pods -n ${catalogNamespace} | grep "1/1" | grep -c ${caseCatalogName}
        break
        exit 1
      fi
    done

    # create operator group
    install_operator_group

    # create subscription
    local subscr_file="${casePath}/inventory/${inventory}/files/op-olm/subscription.yaml"
    validate_file_exists "${subscr_file}"
    sed <"${subscr_file}" "s#NAMESPACE#${namespace}#g" | $kubernetesCLI apply ${dryRun} -f -
    while [[ `$kubernetesCLI get subscription ${subscriptionName} -o jsonpath='{.status.conditions[].reason}'` != *"AllCatalogSourcesHealthy"* ]]; do
      echo "Wait for subscription to complete"
      sleep 60
      if [[ `$kubernetesCLI get subscription ${subscriptionName} -o jsonpath='{.status.conditions[].reason}'` == *"ConstraintsNotSatisfiable"* ]]; then
        echo "Error in Subscription, please check status below"
        break
        exit 1
      fi
    done
    echo "done"
    
    # Verify expected yaml files for install exist
    local op_cli_files="${casePath}/inventory/${inventory}/files/op-cli"
    local roles_manifest_file="${op_cli_files}/config/rbac"
    local crds_manifest_file="${op_cli_files}/config/crd/bases"
    local istio_manifest_file="${op_cli_files}/config/istio/istio.yaml"

    # create crds and serviceaccount
    ls -1d "${roles_manifest_file}"/* | xargs -I {} sh -c 'sed "s#NAMESPACE#${2}#g" < "$1" | ${3} apply -f -' _ {} "$namespace" "$kubernetesCLI"
    $kubernetesCLI apply -n "${namespace}" -f "${crds_manifest_file}"

   # install istio
    if [[ `istioctl verify-install` != *"Istio is installed"* ]]; then
    echo "-------------Installing Istio-------------"
      istioctl upgrade -f "${istio_manifest_file}" -y
    fi 
}

# Install utilizing default CLI method
install_operator_native() {
    # Proceed with install
    echo "-------------Installing native sdk1-------------"

    # Verify expected yaml files for install exist
    local op_cli_files="${casePath}/inventory/${inventory}/files/op-cli"
    local roles_manifest_file="${op_cli_files}/config/rbac"
    local crds_manifest_file="${op_cli_files}/config/crd/bases"
    local istio_manifest_file="${op_cli_files}/config/istio/istio.yaml"

    # create crds and serviceaccount
    ls -1d "${roles_manifest_file}"/* | xargs -I {} sh -c 'sed "s#NAMESPACE#${2}#g" < "$1" | ${3} apply -f -' _ {} "$namespace" "$kubernetesCLI"
    $kubernetesCLI apply -n "${namespace}" -f "${crds_manifest_file}"

    # install istio
    if [[ `istioctl verify-install` != *"Istio is installed"* ]]; then
    echo "-------------Installing Istio-------------"
      istioctl upgrade -f "${istio_manifest_file}" -y
    fi 
}

# ----- UNINSTALL ACTIONS -----
uninstall_dependent_catalogs() {
    echo "no dependent catalogs"
}

uninstall_dependent_operators() {
    echo "no dependent operators"
}

# deletes the catalog source and operator group
uninstall_catalog() {

    validate_install_catalog "uninstall"

    # uninstall all catalogs of subcases first
    if [[ ${recursive_action} -eq 1 ]]; then
        uninstall_dependent_catalogs
    fi

    local catsrc_file="${casePath}"/inventory/"${inventory}"/files/op-olm/catalog-source.yaml

    echo "-------------Uninstalling catalog source-------------"
    $kubernetesCLI delete -f "${catsrc_file}" --ignore-not-found=true ${dryRun}
}

# Uninstall operator installed via OLM
uninstall_operator() {
    echo "start uninstall_operator()"
    echo "Find installed CSV ..."
    csvName=$($kubernetesCLI get subscription ${subscriptionName} -o go-template --template '{{.status.installedCSV}}' -n "${namespace}" --ignore-not-found=true)
    echo "csvName=${csvName}"
    echo "Remove the subscription ..."
    $kubernetesCLI delete subscription ${subscriptionName} -n "${namespace}" --ignore-not-found=true 
    echo "Remove the CSV which was generated by the subscription but does not get garbage collected ..."
    [[ -n "${csvName}" ]] && { $kubernetesCLI delete clusterserviceversion "${csvName}" -n "${namespace}" --ignore-not-found=true; }

    setup_defintion_files="${casePath}/inventory/streamsetsOperator/files"
    echo "Delete catalog source ..."
    local catsrc_file="${setup_defintion_files}/op-olm/catalog-source.yaml"
    $kubernetesCLI delete -f "${catsrc_file}" -n "${namespace}" --ignore-not-found=true 

    echo "Delete operator Group..."
    local opgrp_file="${setup_defintion_files}/op-olm/operator-group.yaml"
    $kubernetesCLI delete -f "${opgrp_file}" -n "${namespace}" --ignore-not-found=true 

    # delete installplan
    installplanName=$($kubernetesCLI get installplan -n ${namespace} --no-headers|grep "$csvName"|cut -d' ' -f1|head -1)
    [[ -n "${installplanName}" ]] && { $kubernetesCLI delete installplan "${installplanName}" -n "${namespace}" --ignore-not-found=true; }

    # uninstall crds and serviceaccount

    echo "complete uninstall_operator()"

    # Proceed with uninstall
    echo "-------------Uninstalling native sdk1-------------"

    # Verify expected yaml files for install exist
    local op_cli_files="${casePath}/inventory/${inventory}/files/op-cli"
    local roles_manifest_file="${op_cli_files}/config/rbac"
    local crds_manifest_file="${op_cli_files}/config/crd/bases"
    local istio_manifest_file="${op_cli_files}/config/istio/istio.yaml"

    # create crds and serviceaccount
    ls -1d "${roles_manifest_file}"/* | xargs -I {} sh -c 'sed "s#NAMESPACE#${2}#g" < "$1" | ${3} delete -f -' _ {} "$namespace" "$kubernetesCLI"
    $kubernetesCLI delete -n "${namespace}" -f "${crds_manifest_file}"

    echo "complete uninstall_operator_native()"

}

# Uninstall operator installed via CLI
uninstall_operator_native() {
    # Proceed with uninstall
    echo "-------------Uninstalling native sdk1-------------"

    # Verify expected yaml files for install exist
    local op_cli_files="${casePath}/inventory/${inventory}/files/op-cli"
    local roles_manifest_file="${op_cli_files}/config/rbac"
    local crds_manifest_file="${op_cli_files}/config/crd/bases"
    local istio_manifest_file="${op_cli_files}/config/istio/istio.yaml"

    # create crds and serviceaccount
    ls -1d "${roles_manifest_file}"/* | xargs -I {} sh -c 'sed "s#NAMESPACE#${2}#g" < "$1" | ${3} delete -f -' _ {} "$namespace" "$kubernetesCLI"
    $kubernetesCLI delete -n "${namespace}" -f "${crds_manifest_file}"

    echo "complete uninstall_operator_native()"
}

install() {
    install_operator
}

uninstall() {
    uninstall_operator
}
