#!/usr/bin/env bash

podman pull cp.stg.icr.io/cp/ibm-streamsets-operator@sha256:4dad92e2d4612ce010388d9ce41556818aba225d8a03b443e3c5217344bcb15d
podman tag cp.stg.icr.io/cp/ibm-streamsets-operator@sha256:4dad92e2d4612ce010388d9ce41556818aba225d8a03b443e3c5217344bcb15d  cp.stg.icr.io/cp/ibm-streamsets-operator:v5.1.0-amd64
podman push cp.stg.icr.io/cp/ibm-streamsets-operator:v5.1.0-amd64 --format v2s2
#podman pull cp.stg.icr.io/cp/ibm-streamsets-operator@sha256:dc4d779436e8dfbd661a4face0369a3108b6332477e6aa499fbfcdc72904ddbd
#podman tag cp.stg.icr.io/cp/ibm-streamsets-operator@sha256:dc4d779436e8dfbd661a4face0369a3108b6332477e6aa499fbfcdc72904ddbd cp.stg.icr.io/cp/ibm-streamsets-operator:v5.1.0-s390x
#podman push cp.stg.icr.io/cp/ibm-streamsets-operator:v5.1.0-s390x --format v2s2
#podman pull cp.stg.icr.io/cp/ibm-streamsets-operator@sha256:b298acd4bbbc495fac1859de41453605eaba3b361b44a60819e0cf7116fdd08a
#podman tag cp.stg.icr.io/cp/ibm-streamsets-operator@sha256:b298acd4bbbc495fac1859de41453605eaba3b361b44a60819e0cf7116fdd08a cp.stg.icr.io/cp/ibm-streamsets-operator:v5.1.0-ppc64le
#podman push cp.stg.icr.io/cp/ibm-streamsets-operator:v5.1.0-ppc64le --format v2s2
podman pull cp.stg.icr.io/cp/ibm-streamsets-operator-bundle@sha256:sha256:6de2fb0f9249670121a075e4b66ecb52a0226ef3ba64e31bd0fa2606d9cc8e47
podman tag cp.stg.icr.io/cp/ibm-streamsets-operator-bundle@sha256:sha256:6de2fb0f9249670121a075e4b66ecb52a0226ef3ba64e31bd0fa2606d9cc8e47 cp.stg.icr.io/cp/ibm-streamsets-operator-bundle:v5.1.0-amd64
podman push cp.stg.icr.io/cp/ibm-streamsets-operator-bundle:v5.1.0-amd64 --format v2s2
#podman pull cp.stg.icr.io/cp/ibm-streamsets-operator-bundle@sha256:f892f1c703f7dabcbb7a1e365ee262c345824f867a9f6cf112f04a5c8edfae1f
#podman tag cp.stg.icr.io/cp/ibm-streamsets-operator-bundle@sha256:f892f1c703f7dabcbb7a1e365ee262c345824f867a9f6cf112f04a5c8edfae1f  cp.stg.icr.io/cp/ibm-streamsets-operator-bundle:v5.1.0-s390x
#podman push cp.stg.icr.io/cp/ibm-streamsets-operator-bundle:v5.1.0-s390x --format v2s2
#podman pull cp.stg.icr.io/cp/ibm-streamsets-operator-bundle@sha256:3224f83821e0ca1c6e043b7eb1d7ccb8737e1117ca4c963d5acb416bdd71d878
#podman tag cp.stg.icr.io/cp/ibm-streamsets-operator-bundle@sha256:3224f83821e0ca1c6e043b7eb1d7ccb8737e1117ca4c963d5acb416bdd71d878 cp.stg.icr.io/cp/ibm-streamsets-operator-bundle:v5.1.0-ppc64le
#podman push cp.stg.icr.io/cp/ibm-streamsets-operator-bundle:v5.1.0-ppc64le --format v2s2
podman pull cp.stg.icr.io/cp/ibm-streamsets-operator-catalog@sha256:564848135315667e7d356d15e4ac01f16c52f09d8ccf8c0f365c46a5a3f4f486
podman tag cp.stg.icr.io/cp/ibm-streamsets-operator-catalog@sha256:564848135315667e7d356d15e4ac01f16c52f09d8ccf8c0f365c46a5a3f4f486 cp.stg.icr.io/cp/ibm-streamsets-operator-catalog:v5.1.0-amd64
podman push cp.stg.icr.io/cp/ibm-streamsets-operator-catalog:v5.1.0-amd64 --format v2s2
#podman pull cp.stg.icr.io/cp/ibm-streamsets-operator-catalog@sha256:6d74b1308d6516dd5e5e3516b0ddb9d7fb95e156a8cc58be1f937b2beafa2c16
#podman tag cp.stg.icr.io/cp/ibm-streamsets-operator-catalog@sha256:6d74b1308d6516dd5e5e3516b0ddb9d7fb95e156a8cc58be1f937b2beafa2c16 cp.stg.icr.io/cp/ibm-streamsets-operator-catalog:v5.1.0-s390x
#podman push cp.stg.icr.io/cp/ibm-streamsets-operator-catalog:v5.1.0-s390x --format v2s2
#podman pull cp.stg.icr.io/cp/ibm-streamsets-operator-catalog@sha256:612a3a6fee37a1759f590774a1ea69bd7a155b2473c49ab276a45b84cf1aa1fc
#podman tag cp.stg.icr.io/cp/ibm-streamsets-operator-catalog@sha256:612a3a6fee37a1759f590774a1ea69bd7a155b2473c49ab276a45b84cf1aa1fc cp.stg.icr.io/cp/ibm-streamsets-operator-catalog:v5.1.0-ppc64le
#podman push cp.stg.icr.io/cp/ibm-streamsets-operator-catalog:v5.1.0-ppc64le --format v2s2