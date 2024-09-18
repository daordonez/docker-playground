resourceGroupName="LAB-204-ACR"
location="westus"
acrName="az204drdoacr"
dockerFilePath="/Users/dordonez/OneDrive/dev/sre/docker/docker-playground"

az acr build -t dordolab/myfastapi:{{.Run.ID}} -r $acrName $dockerFilePath
