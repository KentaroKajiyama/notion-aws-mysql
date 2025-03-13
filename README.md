![ERD](images/02252025.png)
https://lucid.app/lucidchart/9033b384-63b9-4e6b-b79b-66ec940cb5a3/edit?viewport_loc=-2984%2C-1367%2C3591%2C1923%2C0_0&invitationId=inv_8517a8bb-dd20-4854-b506-2044cce7dc88

## Migration Type	Naming Convention Example
Up Migration	V<version>__<description>.sql	V1__create_users.sql
Down Migration	U<version>__<description>.sql	U1__drop_users.sql

## Run the rollback script
powershell -ExecutionPolicy Bypass -File C:\Projects\MyDatabaseProject\rollback.ps1