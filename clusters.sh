#!/bin/bash
export PATH=${HOME}/.local/bin/backplane/latest:${PATH}  

deprovisioned=0
provisioned=0
clusters_id=$(ocm get subscriptions --parameter "search=organization_id='2dtyXmZ7BrVjHDGCyR8jE0ku3Hk'" | jq -r '.items[].cluster_id')
version416="4.16"
version417="4.17"
sixteen=0
seventeen=0
for cluster in $clusters_id; do
   clusterName=$(ocm describe cluster $cluster | grep -w "Display Name" | awk -F: '{ print $2 }' | sed 's/[[:space:]]//g') 
   organization=$(ocm describe cluster $cluster | grep -w "Organization" | awk -F: '{ print $2 }' | sed 's/[[:space:]]//g')
   provider=$(ocm describe cluster $cluster | grep -w "Provider" | awk -F: '{ print $2 }' | sed 's/[[:space:]]//g')
   hcp=$(ocm describe cluster $cluster | grep -w "HCP" | awk -F: '{ print $2 }' | sed 's/[[:space:]]//g')
   version=$(ocm describe cluster $cluster | grep -w "Version" | awk -F: '{ print $2 }' | sed 's/[[:space:]]//g')
   if [[ "$version" == *"$version416"* ]]; then
      sixteen=$((sixteen+1))
   fi
      if [[ "$version" == *"$version417"* ]]; then
      seventeen=$((seventeen+1))
   fi
  channel=$(ocm describe cluster $cluster | grep -w "Channel" | awk -F: '{ print $2 }' | sed 's/[[:space:]]//g')
if [ -z "$clusterName" ]; then
     echo "The Cluster with the following ID $cluster is Deprovisioned."
     deprovisioned=$((deprovisioned+1))
   else
     echo "===================="
     echo "Cluster Name: $clusterName"
     echo "Cluster ID: $cluster"
     echo "Organization: $organization"
     echo "Provider: $provider"
     echo "HCP: $hcp"
     echo "Version: $version"
     echo "Channel: $channel"
     echo "===================="
     provisioned=$((provisioned+1))
  fi
done 
totalCluster=$((deprovisioned+provisioned))
echo "================================================"
echo "Total Number of Clusters: $totalCluster"
echo "Number of deprovisioned Clusters: $deprovisioned"
echo "Number of provisioned Clusters: $provisioned"
echo "Number of clusters in 4.16: $sixteen"
echo "Number of clusters in 4.17: $seventeen"
echo "================================================"


# $ ocm get subscriptions --parameter "search=organization_id='24CIKtG2SLh1sgfpJojTApiPPjK'"| grep cluster_id
# $ ocm get subscriptions --parameter "search=organization_id='24CIKtG2SLh1sgfpJojTApiPPjK'" | jq -cr '.items[] | [{display_name, external_cluster_id, status}]'
