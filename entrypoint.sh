#start up sqlservr in the background, start the hydrate_db.sh script, do something that will not stop to keep the container alive
exec /opt/mssql/bin/sqlservr & ./hydrate_db.sh & sleep infinity