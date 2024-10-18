# (C) Copyright IBM Corp. 2020  All Rights Reserved.
#
# This script implements/overrides the base functions defined in launch.sh
# This implementation is specific to this dp operator

# dp operator specific variables
caseName="ibm-streamsets"
inventory="streamsets"
caseCatalogName="ibm-cpd-streamsets-operator-catalog"
channelName="alpha"
# - variables specific to catalog/operator installation
case_depedencies=""
pvcName="data-ibm-streamsets-self-managed-mysql-mysql-deploy-0"


parse_custom_dynamic_args() {
    key=$1
    val=$2
    case $key in
    --systemStatus)
        cr_system_status=$val
        ;;
    --storageclass)
        storageclass=$val
        ;;
    --service)
        service=$val
        ;;
    --license-accept)
        license_accept=1
        ;;
    --license-type)
        license_type=$val
        ;;
    esac
}

# ----- INSTALL ACTIONS -----
# install operand custom resources
apply_custom_resources() {
    echo "start apply_custom_resources()"
    local cr="${casePath}"/inventory/"${inventory}"/files/op-cli/config/samples
    
    #apply misc-resources & istio
    find $cr -name "*.yaml" \( -name "*_sch-istio.yaml" -o -name "*misc-resources.yaml" \) | xargs -I {} $kubernetesCLI apply -f {}

    # apply msql 
    $kubernetesCLI apply -f $cr/*_mysql.yaml -n ${namespace}
    sleep 10
    $kubernetesCLI rollout status --selector=icpdsupport/addOnId=streamsets --timeout=300s statefulset

    $kubernetesCLI apply -f $cr/*_security.yaml -n ${namespace}
    sleep 10
    # wait for jobs to complete 
    $kubernetesCLI wait --for=condition=complete --selector=icpdsupport/addOnId=streamsets --timeout=300s job
    $kubernetesCLI wait --for=condition=complete --selector=icpdsupport/addOnId=streamsets --timeout=300s job
    $kubernetesCLI rollout status --selector=icpdsupport/addOnId=streamsets --timeout=300s deployment

    # apply everything but aster-security-ui
    find $cr -name "*.yaml" ! \( -name "*_security.yaml" -o -name "*_mysql.yaml" -o -name "*misc-resources.yaml" \) | xargs -I {} $kubernetesCLI apply -f {}
    sleep 10
    $kubernetesCLI wait --for=condition=complete --selector=icpdsupport/addOnId=streamsets --timeout=300s job
    $kubernetesCLI rollout status --selector=icpdsupport/addOnId=streamsets --timeout=300s deployment

    # Delete aster-security-ui and security vs
    $kubernetesCLI delete virtualservice -l app.kubernetes.io/component=aster-security-ui-v1
    $kubernetesCLI delete virtualservice -l app.kubernetes.io/component=security

    echo "complete apply_custom_resources()"
}

delete_custom_resources() {
    echo "start delete_custom_resources()"
    local cr="${casePath}"/inventory/"${inventory}"/files/op-cli/config/samples
    $kubernetesCLI delete -n "${namespace}" -f "${cr}"

    # delete pvc
    $kubernetesCLI delete pvc ${pvcName}
    echo "complete delete_custom_resources()"
}
