. ".\config\setting.ps1"
$DELETE_DB_NAME = "kisotestu_02282025"
$MYSQL_CMD = "mysql -h $RDS_HOST -u $USER -p$PASSWORD -e `"DROP DATABASE $DELETE_DB_NAME;`""
Invoke-Expression $MYSQL_CMD