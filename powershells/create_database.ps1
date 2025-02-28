. ".\config\setting.ps1"
$CREATE_DB_NAME = "kisotetsu_02282025"
$MYSQL_CMD = "mysql -h $RDS_HOST -u $USER -p$PASSWORD -e `"CREATE DATABASE $CREATE_DB_NAME;`""
Invoke-Expression $MYSQL_CMD