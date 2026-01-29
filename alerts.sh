#!/bin/bash

#org_ids=("1Np3zXRXH2QrF3jaIJ7dIzc8khP", "2dtyXmZ7BrVjHDGCyR8jE0ku3Hk", "2IyZCIDJ9LgworSG8OCwTIedqrW", "1LyLWsNBkmAvU2uQ6QM0zxi4UE9")
#seven_days_ago=$(date -u -d '7 days ago' +%Y-%m-%dT%H:%M:%SZ)

#for i in $org_ids; do
#cluster_ids=$(ocm get subscriptions --parameter "search=organization_id='$i'" | jq -r '.items[].cluster_id')

#cluster_id=$(ocm get subscriptions --parameter "search=organization_id='2dtyXmZ7BrVjHDGCyR8jE0ku3Hk'" | jq -r '.items[].cluster_id')


i=0
for cluster in $cluster_id; do
   echo "=========="
   echo "Cluster ID: $cluster"
   echo "----------"
   test=$(ocm describe cluster $cluster | grep -w "Display Name" | awk -F: '{ print $2 }')
   echo "Cluster NAME: $test"
   echo "=========="
   echo "          "
   echo "          "
   echo "          "
   echo "          "
i=$((i+1))
done
echo $i 

ocm backplane login 2c88au30mo251lu8nevohplhglb38s7v
ocm backplane elevate alert -- rsh -n openshift-monitoring alertmanager-main-0 amtool alert query --alertmanager.url http://localhost:9093   
#ocm backplane elevate alert -- -n openshift-monitoring exec -c prometheus prometheus-k8s-0 -- curl -s   'http://localhost:9090/api/v1/alerts' 



#for cluster_id in $cluster_id; do
#    ocm get clusters --parameter "search=product.id='rosa' AND \
#        state='ready' AND \
#        hypershift.enabled='true' AND \
#        id='$cluster_id' AND \
#       | jq -r '.items[].id'
#done 
#done
