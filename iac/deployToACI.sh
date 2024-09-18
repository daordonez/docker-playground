resourceGroupName="LAB-204-ACR"
location="westus"
acrServer="az204drdoacr.azurecr.io"
appImage="dordolab/myfastapi:cc2"
fqdnImage="${acrServer}/$appImage"
aciDeploymentName="myacifastapi"
kvName="az204-kv-21831"
KV_spnusr="spn-acr-pull-usr"
KV_spnpwd="spn-acr-pull-pwd"

az container create -n $aciDeploymentName -g $resourceGroupName --image $fqdnImage --registry-login-server $acrServer --registry-username $(az keyvault secret show --vault-name $kvName -n $KV_spnusr --query value -o tsv) --registry-password $(az keyvault secret show --vault-name $kvName -n $KV_spnpwd --query value -o tsv) --dns-name-label "aci-fastapi-${RANDOM}" --ip-address public --ports 80 --query ipAddress.fqdn