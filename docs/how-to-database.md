### How to export the database

* Open DataGrip
* Right-click database
* Dump with `pg_dump`
* Path to pg_dump: `C:/Program Files/PostgreSQL/pg10/bin/pg_dump.exe`
* Statements: Copy (*This is super mega importante.*)
* Database: burntoast
* Schemas: <empty>
* Tables: <empty>
* Format: File
* Uncheck Clean Database, Add "IF EXISTS", Create database, and Data only
* Out path: `C:/Desktop/export.sql`
* Run
* Replace `src/data/migrations/export.sql`
* Commit changes
