. ".\config\setting.ps1"
$MYSQL_CMD = "mysql --default-character-set=utf8mb4 -h $RDS_HOST -u $USER -p$PASSWORD -D$DB_NAME -e `"SOURCE $SQL_FILE;`""
Invoke-Expression $MYSQL_CMD
