#!/bin/bash
# 这里用的是腾讯云的 secretid和 secretkey. 而不是 dnspod的appid和token
# 通过 https://console.cloud.tencent.com/cam/capi 这里获取
helm repo add roc https://charts.imroc.cc
helm upgrade --install cert-manager-webhook-dnspod roc/cert-manager-webhook-dnspod \
    --namespace cert-manager \
    --set clusterIssuer.secretId="你的腾讯云secretid" \
    --set clusterIssuer.secretKey="你的腾讯云secretKey" \
    --set clusterIssuer.email="你的邮箱" \
    --set image.repository=scjtqs/cert-manager-webhook-dnspod \
    --set groupName="例如 acme.scjtqs.com，填你域名" \
    --set clusterIssuer.name="dnspod"
