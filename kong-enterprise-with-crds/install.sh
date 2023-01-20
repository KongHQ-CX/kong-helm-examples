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

if ! yq version > /dev/null 2>&1 ;
then
  echo "!! Install Golang-style yq tool from https://github.com/mikefarah/yq/releases !!"
  echo "Quitting whilst doing nothing."
  exit 1
fi

# Args test
if [ -z "$1" ]
then
  echo "USAGE: ./install.sh .ingressdomain.tld"
else
  # Less gooooo
  echo "> Installing with ingress/cookie domain $1"
fi
