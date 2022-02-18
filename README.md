# Network DevOps Team

$sub = "<subscriptionId>"
$loc = "<location>"

az deployment sub create --name "main-$loc" --location $loc --subscription $sub --template-file .\src\main.bicep