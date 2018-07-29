#!/bin/bash
#
#  Usage: deployVC.sh vc_build_number vcname
#



VC_BUILD_NUMBER=$1
VCNAME=$2

REPORT="${VCNAME}.txt"

NIMBUS_CONFIG_FILE=/mts/home1/akothari/bin/config.json NIMBUS=vsan-cert-02 /mts/git/bin/nimbus-vcvadeploy --nimbus=vsan-cert-02 --vcvaBuild=ob-${VC_BUILD_NUMBER} ${VCNAME} | tee ${REPORT}
