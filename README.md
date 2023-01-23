# Kong Helm Examples

Sample Helm, other installations, and misc tools, for Kong setup.

## Index

Currently, the catalogue has the following examples:

### Kong Enterprise with CRD-Managed [KIC](https://docs.konghq.com/kubernetes-ingress-controller/latest) Configuration

**In directory:** `/kong-enterprise-with-crds`

This example uses the [Kong Ingress Controller](https://docs.konghq.com/kubernetes-ingress-controller/latest) with it's provided [Custom Resource Definitions](https://docs.konghq.com/kubernetes-ingress-controller/latest/references/custom-resources) in order to provide a Kubernetes-native experience when configuring Kong.

This does not require any backing store, as the Kube etcd is used to persist the configuration. This mean however, that you cannot use features such as the Kong Developer Portal, which requires a postgres database for markup and file storage.

#### Configuring for your Environment

In the [values.yaml](https://github.com/KongHQ-CX/kong-helm-examples/blob/main/kong-enterprise-with-crds/values.yaml) file, complete the following placeholder options:

```yaml
...
...
  ingress:
    ...
    hostname: $INGRESS_HOSTNAME
    ...
    annotations:
      ...
      alb.ingress.kubernetes.io/certificate-arn: $CERT_ARN
      alb.ingress.kubernetes.io/subnets: $SUBNETS
      ...
```

Make sure your enterprise license is stored as a single-line JSON file at this location: `~/.license/kong.json` then run the install.sh script.

#### Adding New Configuration

At the end of the [values.yaml](https://github.com/KongHQ-CX/kong-helm-examples/blob/main/kong-enterprise-with-crds/values.yaml) file, add more CRDs for your Kong APIs, consumers, and plugins, based on the CRD documentation above.

### Kong Enterprise with ConfigMap-Managed [Deck](https://github.com/Kong/deck/releases) Configuration

**In directory:** `/kong-enterprise-with-declarative`

This example uses the [Kong Declarative Format](https://docs.konghq.com/gateway/latest/production/deployment-topologies/db-less-and-declarative-config), which gets uploaded and mounted as a ConfigMap automatically by the Kong Helm chart.

This also does not require any backing store, as the Kube etcd is used to persist the configuration. This mean however, that you cannot use features such as the Kong Developer Portal, which requires a postgres database for markup and file storage.

Finally, with this method there is a standard Kubernetes limit of 3mb for the ConfigMap, which you **will exhaust incredibly quickly**. This is just a proof-of-concept deployment: usually you would store this on a persistent volume, or have an initContainer load it from S3, or etcetera.

#### Configuring for your Environment

In the [values.yaml](https://github.com/KongHQ-CX/kong-helm-examples/blob/main/kong-enterprise-with-declarative/values.yaml) file, complete the following placeholder options:

```yaml
...
...
  ingress:
    ...
    hostname: $INGRESS_HOSTNAME
    ...
    annotations:
      ...
      alb.ingress.kubernetes.io/certificate-arn: $CERT_ARN
      alb.ingress.kubernetes.io/subnets: $SUBNETS
      ...
```

Make sure your enterprise license is stored as a single-line JSON file at this location: `~/.license/kong.json` then run the install.sh script.

#### Adding New Configuration

At the end of the [values.yaml](https://github.com/KongHQ-CX/kong-helm-examples/blob/main/kong-enterprise-with-declarative/values.yaml) file, add more entries into the `dblessConfig.config` YAML key for your Kong APIs, consumers, and plugins, based on the Kong "Deck" format documentation above.
