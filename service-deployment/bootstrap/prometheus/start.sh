#!/bin/bash

#!/bin/bash

# Copyright (c) Microsoft Corporation
# All rights reserved.
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
# to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

pushd $(dirname "$0") > /dev/null

chmod u+x node-label.sh

./node-label.sh

NAMESPACE=${NAMESPACE:-monitortest}
KUBECTL="kubectl  --namespace=\"${NAMESPACE}\""
eval "kubectl create namespace \"${NAMESPACE}\""

# (1) create configmap
eval "${KUBECTL} create -f prometheus-configmap.yaml"
eval "${KUBECTL} create configmap grafana-import-dashboards --from-file=dashboards -o json --dry-run" | eval "${KUBECTL} apply -f -"

# (2) create the pods
eval "${KUBECTL} create -f gpu-exporter-ds.yaml"
eval "${KUBECTL} create -f node-exporter-ds.yaml"
eval "${KUBECTL} create -f prometheus-deployment.yaml"
eval "${KUBECTL} create -f grafana.yaml"
eval "${KUBECTL} create -f grafana-cmd.yaml"
eval "${KUBECTL} get pods"

popd > /dev/null