#!/bin/bash
ipsubnet=$1
imagename=$2

echo deleting $imagename

ssh root@192.168.${ipsubnet}0 "/usr/local/bin/docker rmi -f $imagename"
ssh root@192.168.${ipsubnet}1 "/usr/local/bin/docker rmi -f $imagename"
ssh root@192.168.${ipsubnet}2 "/usr/local/bin/docker rmi -f $imagename"
