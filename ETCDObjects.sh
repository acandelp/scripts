#!/bin/bash

export ETCD_POD_NAME=$(oc get pods -n openshift-etcd -l app=etcd --field-selector="status.phase==Running" -o jsonpath="{.items[0].metadata.name}")
echo " Number Object type"
oc exec -n openshift-etcd ${ETCD_POD_NAME} -- bash -c "etcdctl get / --prefix --keys-only | sed '/^$/d' | cut -d/ -f3 | sort | uniq -c | sort -rn"


echo "Number Object type                                        Size"
oc exec -n openshift-etcd -c etcdctl ${ETCD_POD_NAME} -- sh -c "etcdctl get / --prefix --keys-only  | grep -oE '^/[a-z|.]+/[a-z|.|8]*' | sort | uniq -c | sort -rn" | while read KEY; do printf "$KEY\t" && oc exec -n openshift-etcd ${ETCD_POD_NAME} -c etcdctl -- etcdctl get ${KEY##* } --prefix --write-out=json | jq '[.kvs[].value | length] | add ' | numfmt --to=iec ; done | sort -k3 -hr | column -t
