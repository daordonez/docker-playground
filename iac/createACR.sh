resourceGroupName="LAB-204-ACR"
location="westus"
acrName="az204drdoacr"

echo "Creating ACR - ${acrName}"
az acr create -n $acrName -g $resourceGroupName --sku basic