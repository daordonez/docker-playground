resourceGroupName="LAB-204-ACR"
location="westus"
kvName="az204-kv-${RANDOM}"
kvName="az204-kv-21831"
servicePrincipalName="spn-acr-pull"
outPutFile="$(pwd)/iac/config.txt"

echo "1. Creating ServiPrincipal"
SPN_INFO=$(az ad sp create-for-rbac --name $servicePrincipalName --scopes $(az acr show --name $acrName --query id -o tsv) --role acrpull)

echo "2. Getting SPN ID"
SP_ID=$(echo $SPN_INFO | jq -r '.appId')
SP_PWD=$(echo $SPN_INFO | jq -r '.password')

echo "3. Creating Az KeyVault -  ${kvName}"
#az keyvault create -g $resourceGroupName -n $kvName

echo "4. Elevating privileges into KeyVault"
azAccountInfo=$(az account show)
selfUPN=$(echo $azAccountInfo | jq -r '.user.name')
kvScope=$(az keyvault show --name $kvName --query "id" -o tsv)

az role assignment create --role "key Vault Secrets office" --assignee $selfUPN --scope $kvScope

echo "4. Saving SPN credentials"
#Storing service principal client-secret
az keyvault secret set --vault-name $kvName --name "${servicePrincipalName}-pwd" --value $SP_PWD
#storing service principal ID
az keyvault secret set --vault-name $kvName --name "${servicePrincipalName}-usr" --value $SP_ID

echo "5. Saving config information"
echo "kv-name=$kvName" > "$outPutFile"
echo "SPN-name=${servicePrincipalName}-usr" >> "$outPutFile"
echo "SPN-pwd=${servicePrincipalName}-pwd" >> "$outPutFile"
