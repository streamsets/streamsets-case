#!/usr/bin/env bash

podman tag cp.stg.icr.io/cp/ibm-streamsets-operator@sha256:663e0d296d7a916533181121b0bfcc69fb478cbc14bff063b2bfbb3674837667  cp.stg.icr.io/cp/ibm-streamsets-operator:v5.1.0-amd64
podman pull cp.stg.icr.io/cp/ibm-streamsets-operator@sha256:663e0d296d7a916533181121b0bfcc69fb478cbc14bff063b2bfbb3674837667
podman push cp.stg.icr.io/cp/ibm-streamsets-operator:v5.1.0-amd64 --format v2s2
#podman pull cp.stg.icr.io/cp/ibm-streamsets-operator@sha256:dc4d779436e8dfbd661a4face0369a3108b6332477e6aa499fbfcdc72904ddbd
#podman tag cp.stg.icr.io/cp/ibm-streamsets-operator@sha256:dc4d779436e8dfbd661a4face0369a3108b6332477e6aa499fbfcdc72904ddbd cp.stg.icr.io/cp/ibm-streamsets-operator:v5.1.0-s390x
#podman push cp.stg.icr.io/cp/ibm-streamsets-operator:v5.1.0-s390x --format v2s2
#podman pull cp.stg.icr.io/cp/ibm-streamsets-operator@sha256:b298acd4bbbc495fac1859de41453605eaba3b361b44a60819e0cf7116fdd08a
#podman tag cp.stg.icr.io/cp/ibm-streamsets-operator@sha256:b298acd4bbbc495fac1859de41453605eaba3b361b44a60819e0cf7116fdd08a cp.stg.icr.io/cp/ibm-streamsets-operator:v5.1.0-ppc64le
#podman push cp.stg.icr.io/cp/ibm-streamsets-operator:v5.1.0-ppc64le --format v2s2
podman pull cp.stg.icr.io/cp/ibm-streamsets-operator-bundle@sha256:1179dcd4d964ce7ced8bc982c53d36e98ea19f2cae6b02ff2634bb5b4d4b468c
podman tag cp.stg.icr.io/cp/ibm-streamsets-operator-bundle@sha256:1179dcd4d964ce7ced8bc982c53d36e98ea19f2cae6b02ff2634bb5b4d4b468c cp.stg.icr.io/cp/ibm-streamsets-operator-bundle:v5.1.0-amd64
podman push cp.stg.icr.io/cp/ibm-streamsets-operator-bundle:v5.1.0-amd64 --format v2s2
#podman pull cp.stg.icr.io/cp/ibm-streamsets-operator-bundle@sha256:f892f1c703f7dabcbb7a1e365ee262c345824f867a9f6cf112f04a5c8edfae1f
#podman tag cp.stg.icr.io/cp/ibm-streamsets-operator-bundle@sha256:f892f1c703f7dabcbb7a1e365ee262c345824f867a9f6cf112f04a5c8edfae1f  cp.stg.icr.io/cp/ibm-streamsets-operator-bundle:v5.1.0-s390x
#podman push cp.stg.icr.io/cp/ibm-streamsets-operator-bundle:v5.1.0-s390x --format v2s2
#podman pull cp.stg.icr.io/cp/ibm-streamsets-operator-bundle@sha256:3224f83821e0ca1c6e043b7eb1d7ccb8737e1117ca4c963d5acb416bdd71d878
#podman tag cp.stg.icr.io/cp/ibm-streamsets-operator-bundle@sha256:3224f83821e0ca1c6e043b7eb1d7ccb8737e1117ca4c963d5acb416bdd71d878 cp.stg.icr.io/cp/ibm-streamsets-operator-bundle:v5.1.0-ppc64le
#podman push cp.stg.icr.io/cp/ibm-streamsets-operator-bundle:v5.1.0-ppc64le --format v2s2
podman pull cp.stg.icr.io/cp/ibm-streamsets-operator-catalog@sha256:5ed6d60682803af7ee73e58d255bddff6fe403773a069588a4ee6607d23d5b2e
podman tag cp.stg.icr.io/cp/ibm-streamsets-operator-catalog@sha256:5ed6d60682803af7ee73e58d255bddff6fe403773a069588a4ee6607d23d5b2e cp.stg.icr.io/cp/ibm-streamsets-operator-catalog:v5.1.0-amd64
podman push cp.stg.icr.io/cp/ibm-streamsets-operator-catalog:v5.1.0-amd64 --format v2s2
#podman pull cp.stg.icr.io/cp/ibm-streamsets-operator-catalog@sha256:6d74b1308d6516dd5e5e3516b0ddb9d7fb95e156a8cc58be1f937b2beafa2c16
#podman tag cp.stg.icr.io/cp/ibm-streamsets-operator-catalog@sha256:6d74b1308d6516dd5e5e3516b0ddb9d7fb95e156a8cc58be1f937b2beafa2c16 cp.stg.icr.io/cp/ibm-streamsets-operator-catalog:v5.1.0-s390x
#podman push cp.stg.icr.io/cp/ibm-streamsets-operator-catalog:v5.1.0-s390x --format v2s2
#podman pull cp.stg.icr.io/cp/ibm-streamsets-operator-catalog@sha256:612a3a6fee37a1759f590774a1ea69bd7a155b2473c49ab276a45b84cf1aa1fc
#podman tag cp.stg.icr.io/cp/ibm-streamsets-operator-catalog@sha256:612a3a6fee37a1759f590774a1ea69bd7a155b2473c49ab276a45b84cf1aa1fc cp.stg.icr.io/cp/ibm-streamsets-operator-catalog:v5.1.0-ppc64le
#podman push cp.stg.icr.io/cp/ibm-streamsets-operator-catalog:v5.1.0-ppc64le --format v2s2