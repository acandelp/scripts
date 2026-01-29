export PATH=${HOME}/.local/bin/backplane/latest:${PATH} 

#!/bin/bash
updated=0
updating=0
provisioned=0
totalCluster=0
noProvisioned=0
clusters_id=$(ocm get subscriptions --parameter "search=organization_id='2dtyXmZ7BrVjHDGCyR8jE0ku3Hk'" | jq -r '.items[].cluster_id')
#echo $clusters_id
for cluster in $clusters_id; do
    totalCluster=$((totalCluster+1))
    output=$(ocm backplane login $cluster 2>&1)
    if [[ "$output" == *"there is no cluster"* ]]; then
      noProvisioned=$((noProvisioned+1))
#      echo "no provisioned"
      continue
    else
      provisioned=$((provisioned+1))
#      echo "provisioned"
      checkUpdate=$(oc get clusterversion | AWK 'NR==2 {print $4}')
      if [[ "$checkUpdate" == "False" ]]; then
#      echo "updated"
      updated=$((updated+1))
      else
#      echo "updating"
      updating=$((updating+1))
      fi
   fi
organization=$(ocm describe cluster $cluster | grep -w "Organization" | awk -F: '{ print $2 }' | sed 's/[[:space:]]//g')
 #   echo $filterOutput 
 #    clusterName=$(`ocm describe cluster $cluster | grep -w "Display Name" | awk -F: '{ print $2 }' | sed 's/[[:space:]]//g'` 2> /dev/null)
 #   oc get clusterversion
 #   checkUpdate=$(oc get clusterversion | AWK 'NR==2 {print $4}')
 #   if [[ "$checkUpdate" == "False" ]]; then
 #   updated=$((updated+1))
 #   echo "No se está actualizando"
 #   else
 #   echo "se está actualizando"
 #   updating=$((updating+1))
 #   fi
done 
echo "================================================"
echo "Account : $organization"
echo "Total Number of Clusters: $totalCluster"
echo "Number of Provisioned Clusters: $provisioned"
echo "Number of No Provisioned Clusters: $noProvisioned"
echo "Number of updated Clusters: $updated"
echo "Number of updating Clusters: $updating"
echo "================================================"
