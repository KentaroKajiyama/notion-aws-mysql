. ".\config\setting.ps1"
$MYSQL_CMD = "mysql -h $RDS_HOST -u $USER -p$PASSWORD"
Invoke-Expression $MYSQL_CMD
