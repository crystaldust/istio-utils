#!/bin/bash
target=$1
if [ $target = "" ] ; then
	echo "missing target(discovery or agent)"
	exit 1
fi

buildtarget=""
imagename=""

case $target in
	"discovery")
		buildtarget="pilot"
		imagename="pilot"
		;;
	"agent")
		buildtarget="pilot-agent"
		imagename="proxy_debug"
		;;
esac

cd $ISTIO/istio/

echo "build binary"
http_proxy='http://127.0.0.1:8123' https_proxy='http://127.0.0.1:8123' make $buildtarget DEBUG=1 &&

echo "build docker image"
http_proxy='http://127.0.0.1:8123' https_proxy='http://127.0.0.1:8123' make docker.$imagename DEBUG=1 &&

echo "delete image"
delete-image.sh "43.7" lance/${imagename}:lance

echo "distribute image"
distribute-image.sh "43.7" lance/${imagename}:lance

if [ $target = "discovery" ] ; then
	kubectl delete -f /home/lance/Downloads/istio-0.7.1/install/kubernetes/pilot-deployment.yaml
	kubectl apply -f /home/lance/Downloads/istio-0.7.1/install/kubernetes/pilot-deployment.yaml
fi
