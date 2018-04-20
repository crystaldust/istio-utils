#!/bin/bash
cd $ISTIO/istio

#mixer
make mixs GCFLAGS='all=-l -N' DEBUG=1
make docker.mixer_debug DEBUG=1

distribute-image.sh "43.7" lance/mixer_debug:git

#pilot-agent(the data plane sidecar)
make pilot-agent GCFLAGS='all=-l -N' DEBUG=1
make docker.proxy_debug DEBUG=1
distribute-image.sh "43.7" lance/proxy_debug:git

#pilot-discovery(the control plane pilot)
make pilot GCFLAGS='all=-l -N' DEBUG=1
make docker.pilot DEBUG=1
distribute-image.sh "43.7" lance/pilot:git

#istio-ca
## version from 0.8
#make citadel GCFLAGS='all=-l -N' DEBUG=1
#make docker.citadel DEBUG=1

make istio-ca GCFLAGS='all=-l -N' DEBUG=1
make docker.istio-ca DEBUG=1
distribute-image.sh "43.7" lance/istio-ca:git

cd -
