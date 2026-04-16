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



# Install Podman
sudo yum install podman
# Creation of the script and the Dockerfile

#test.sh
# cat test.sh
-----
#!/bin/bash

echo "HELLO"
-----

#dockerfile
cat containerfile.yaml
-----
FROM registry.fedoraproject.org/fedora
#RUN sudo dnf install fio util-linux python-pip wget -y && dnf clean all -y
# RUN /usr/bin/python3 -m pip install --upgrade pip
# RUN pip install numpy
# RUN pip install matplotlib

WORKDIR /
COPY test.sh /usr/local/bin/
RUN chmod +x /usr/local/bin//test.sh
CMD ["./usr/local/bin/test.sh"]

chmod +x test.sh
podman build -f /home/quickcluster/test/containerfile.yaml
-----

#Check if the image is created

podman images
REPOSITORY                                 TAG      IMAGE ID       CREATED              SIZE
<none>                                     <none>   e2a07cb3a896   About a minute ago   163 MB

#push the image in the quay repository

[root@node-0 test]# podman login quay.io
Username: acandelp
Password:
Login Succeeded!


podman push e2a07cb3a896 quay.io/acandelp/do180-custom-httpd
Getting image source signatures
Copying blob 23281f8ab120 done
Copying blob 5c11fc07f1cc done
Copying blob 407c0fd4d81c done
Copying config e2a07cb3a8 done
Writing manifest to image destination
Storing signatures

#Pull the image from Quay
---
[root@node-0 test]# podman pull quay.io/acandelp/do180-custom-httpd
Trying to pull quay.io/acandelp/do180-custom-httpd...
Getting image source signatures
Copying blob 943af2929b74 skipped: already exists
Copying blob 73ac9f03480e [--------------------------------------] 0.0b / 0.0b
Copying config e2a07cb3a8 done
Writing manifest to image destination
Storing signatures
e2a07cb3a89633553766b53b173a313eaf8785c3dc4b459f691e8f0725956239
[root@node-0 test]# ls
containerfile.yaml  test.py  test.sh
[root@node-0 test]# podman images
REPOSITORY                                 TAG      IMAGE ID       CREATED          SIZE
quay.io/acandelp/do180-custom-httpd        latest   e2a07cb3a896   31 minutes ago   163 MB
---

#Run the container
---
[root@node-0 test]# podman images
REPOSITORY                                 TAG      IMAGE ID       CREATED          SIZE
quay.io/acandelp/do180-custom-httpd        latest   e2a07cb3a896   36 minutes ago   163 MB
<none>                                     <none>   076e119d66d7   38 minutes ago   163 MB
registry.fedoraproject.org/fedora          latest   99519fcf3c1b   5 hours ago      163 MB
registry.access.redhat.com/rhel7-minimal   latest   aea9b5a5fa6e   5 months ago     84.8 MB
[root@node-0 test]# podman run e2a07cb3a896
HELLO
---


Run from the repository

[root@node-0 test]# podman run --privileged quay.io/acandelp/do180-custom-httpd:latest
HELLO
