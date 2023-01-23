#!/bin/bash

###
## IMPORTANT: Put your Kong Enterprise License at path `~/.license/kong.json` before executing this.
##            It will get created as a Kube secret resource in the given namespace. If you don't want to do this,
##            add it to your secrets manager of choice and reference it via CSI annotations somehow.
###

# Tools test
if [[ ! -f ~/.license/kong.json ]] ;
then
  echo "!! License not found at ~/.license/kong.json !!"
  echo "Quitting whilst doing nothing."
  exit 1
fi

if ! helm version > /dev/null 2>&1 ;
then
  echo "!! Install Helm from https://github.com/helm/helm/releases !!"
  echo "Quitting whilst doing nothing."
  exit 1
fi

if ! kubectl version > /dev/null 2>&1 ;
then
  echo "!! Install Kubectl from https://kubernetes.io/docs/tasks/tools/ !!"
  echo "Quitting whilst doing nothing."
  exit 1
fi

if cat values.yaml | grep \$INGRESS_HOSTNAME > /dev/null 2>&1 ;
then
  echo '!! $INGRESS_HOSTNAME is not set in values file - please set proxy.ingress.hostname to your desired ALB hostname !!'
  echo "Quitting whilst doing nothing."
  exit 1
fi

if cat values.yaml | grep \$CERT_ARN > /dev/null 2>&1 ;
then
  echo '!! $CERT_ARN is not set in values file - please set "alb.ingress.kubernetes.io/certificate-arn" to the correct certificate for the ALB !!'
  echo "Quitting whilst doing nothing."
  exit 1
fi

if cat values.yaml | grep \$SUBNETS > /dev/null 2>&1 ;
then
  echo '!! $SUBNETS is not set in values file - please set "alb.ingress.kubernetes.io/subnets" to a comma-separated list of the desired ALB subnets (minimum 2 zones) !!'
  echo "Quitting whilst doing nothing."
  exit 1
fi

# Args test
if [ -z "$1" ]
then
  echo "USAGE: ./install.sh namespace"
else
  # Let's go
  echo "> Installing to namesapce ${1}"

  # setup
  kubectl create namespace ${1}
  kubectl config set-context --current --namespace ${1}

  # install license
  kubectl create secret generic kong-enterprise-license --from-file=license=$HOME/.license/kong.json --dry-run=client -o yaml -n ${1} | kubectl apply -n ${1} -f -

  helm repo add kong https://charts.konghq.com
  helm repo update kong

  helm upgrade -i kong-declarative kong/kong -f values.yaml -n ${1}
fi
