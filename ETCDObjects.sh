ETCD_POD_NAME=$(oc get pods -n openshift-etcd -l app=etcd --field-selector="status.phase==Running" -o jsonpath="{.items[0].metadata.name}")
echo "===================="
echo " Number|Object type"
echo "===================="
oc exec -n openshift-etcd ${ETCD_POD_NAME} -- bash -c "etcdctl get / --prefix --keys-only | sed '/^$/d' | cut -d/ -f3 | sort | uniq -c | sort -rn"


echo "=============================================================="
echo "Number|Object type                                       |Size"
echo "=============================================================="
oc exec -n openshift-etcd -c etcdctl ${ETCD_POD_NAME} -- sh -c "etcdctl get / --prefix --keys-only  | grep -oE '^/[a-z|.]+/[a-z|.|8]*' | sort | uniq -c | sort -rn" | while read KEY; do printf "$KEY\t" && oc exec -n openshift-etcd ${ETCD_POD_NAME} -c etcdctl -- etcdctl get ${KEY##* } --prefix --write-out=json | jq '[.kvs[].value | length] | add ' | numfmt --to=iec ; done | sort -k3 -hr | column -t

echo "Introduce the object to analyze, if not, select enter"
read OBJECT

if [ "$OBJECT" ]
then
   echo "=====Researching when specific $OBJECT is created====="
   echo "==By month=="
   oc get ${OBJECT} -A -o jsonpath='{range .items[*]}{.metadata.creationTimestamp}{"\n"}{end}' | grep -oE "[0-9]{4}-[0-9]{2}" | sort | uniq -c
   echo "==By day=="
   oc get ${OBJECT} -A -o jsonpath='{range .items[*]}{.metadata.creationTimestamp}{"\n"}{end}' | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}" | sort | uniq -c
   echo "==By hour=="
   oc get ${OBJECT} -A -o jsonpath='{range .items[*]}{.metadata.creationTimestamp}{"\n"}{end}' | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}" | sort | uniq -c
   echo "=====Researching responsible namespace for the object $OBJECT====="  
for NS in $(oc get ns --no-headers -o custom-columns=NAME:metadata.name); do echo -e "$(oc get ${OBJECT} -n ${NS} --no-headers | wc -l)\t${OBJECT} in ${NS}" ; done | sort -nr
else
    echo "EXIT"
    exit
fi

#pending tasks
# Script in functions
