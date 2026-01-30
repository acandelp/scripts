#!/bin/bash
#export PATH=${HOME}/.local/bin/backplane/latest:${PATH}
#ocm login --use-auth-code --url production

echo Please introduce the Cluster ID:
read CLUSTERID
echo The Cluster ID is $CLUSTERID
echo "Describe the cluster"
ocm describe cluster $CLUSTERID

ClusterType=$(ocm describe cluster $CLUSTERID | grep "Product" | awk '{ print $2 }')
echo $ClusterType
echo The Product is: $ClusterType
HCP=$(ocm describe cluster $CLUSTERID | grep "HCP" | awk '{ print $2 }')
echo HCP? $HCP
 #MC_ID=$(ocm describe cluster $CLUSTERID | grep Management | awk '{ print $3 }')
#echo The ManagementCluster ID is: $MC_ID
#INT_ID=$(ocm describe cluster $CLUSTERID | grep "ID" -m1 | awk '{ print $2}')
#echo The Internal ID is: $INT_ID
#echo Backplane to the MC
#cm backplane login $MC_ID
#echo "List the namespaces from the customer cluster inside the MC"
#oc get project | grep $INT_ID

#NEXT STEPS:
#check the cluster information, clusters, hcp, version, customer, organization
#cuando entremnos en el , vemos si podemos acceder a toda la info despues del backplane


