#!/bin/bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm upgrade --install   cert-manager jetstack/cert-manager   --namespace cert-manager   --create-namespace   --version v1.9.1   --set installCRDs=true --set prometheus.enabled=false \
--set 'extraArgs={--acme-http01-solver-nameservers=119.29.29.29:53\,223.5.5.5:53,--dns01-recursive-nameservers-only,--dns01-recursive-nameservers=119.29.29.29:53\,223.5.5.5:53,--enable-certificate-owner-ref=true}'
