ACI_PERS_RESOURCE_GROUP=MOONLAY-DEVOPS
ACI_PERS_STORAGE_ACCOUNT_NAME=moonlaydevtoolstrg
ACI_PERS_LOCATION=southeastasia
ACI_PERS_SHARE_NAME=sonarshare

az storage account create \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --location $ACI_PERS_LOCATION \
    --sku Standard_LRS
	
export AZURE_STORAGE_CONNECTION_STRING=`az storage account show-connection-string --resource-group $ACI_PERS_RESOURCE_GROUP --name $ACI_PERS_STORAGE_ACCOUNT_NAME --output tsv`
	
az storage share create -n $ACI_PERS_SHARE_NAME

STORAGE_ACCOUNT=$(az storage account list --resource-group $ACI_PERS_RESOURCE_GROUP --query "[?contains(name,'$ACI_PERS_STORAGE_ACCOUNT_NAME')].[name]" --output tsv)
echo $STORAGE_ACCOUNT



STORAGE_KEY=$(az storage account keys list --resource-group $ACI_PERS_RESOURCE_GROUP --account-name $STORAGE_ACCOUNT --query "[0].value" --output tsv)
echo $STORAGE_KEY




SONARQUBE_JDBC_URL=jdbc:sqlserver://moonlay.database.windows.net:1433;database=sonar-db;user=moonlay-admin@moonlay;password={your_password_here};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;
SONARQUBE_JDBC_USERNAME=moonlay-admin@moonlay
SONARQUBE_JDBC_PASSWORD=Standar123

az container create \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name sonarqube-moonlay \
    --image sonarqube:7.1 \
    --dns-name-label moonlay-devops \
	--environment-variables SONARQUBE_JDBC_URL=$SONARQUBE_JDBC_URL \
    SONARQUBE_JDBC_USERNAME=$SONARQUBE_JDBC_USERNAME \
	SONARQUBE_JDBC_PASSWORD=$SONARQUBE_JDBC_PASSWORD