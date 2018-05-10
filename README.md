# Overview
An example of creating a container image from mssql-server-linux that will configure some server settings like a user role, login, create a database, and populate some schema, and test data into it.

# How it works
In this example, the Dockerfile adds the .sql scripts into the image along with some scripts that are executed by the ENTRYPOINT.

At docker run time the entrypoint.sh script is executed which does three things:
* Start the sqlservr process which is the SQL Server engine
* Kicks off a hydrate_db.sh script
* Runs sleep infinity to keep the container alive since we are doing '&' parallel background tasks.  Each task to the left of an & in a shell script is run as a background task so it won't keep the container alive by itself.

Within hydrate_db.sh the script simply takes all the .sql files in the ./sqlscripts_hydration directory, sorts them alphabetically, and executes sqlcmd against each of them.  You can have whatever files you want to in this directory to do whatever you want - create server level objects like logins, configure SQL Server server settings, create databases, create users, create schema, modify schema, etc.

After all the script files in ./sqlscripts_hydration are executed the hydrate_db.sh script will optionally execute all the scripts in ./sqlscripts_testdata if the CREATE_TEST_DATA environment variable is set to "Y".  You can use this to give the user that is executing the docker run command the option to create test data or not.

# A few things to keep in mind
* The files in the directory are alphabetically sorted by the script so if you have more than 10 files it will start sorting them as 1, 11, 111, 2, 22, etc. so you may want to name the files as 0001, 0002, ... 0011, etc. so that they are executed in the expected sequence.
* Each of your script files should be designed to be executed in a way that wont fail if it is run against an existing SQL Server instance with data in it.  For example, if you run this container and do a -v mount to a directory that already contains a master DB, and the database files for the user database 'ColorsDB' then it should still work.  For example, in your scripts write conditional checks for existence before trying to create an object - i.e. if DB does not exist, create DB.  Also, use new scripting features like 'CREATE or ALTER'.
* Your scripts should be designed such that if run in sequence it create a new DB from nothing or it can take a DB that is at any version and upgrade it to the latest.

# CI/CD usage
If you use an approach like this all a developer has to do to add some schema migrations is to create a new .sql file, build an image, run a container based on the new image, test, check in the .sql file.  Then anybody else that git pulls from the repo and builds a local docker image will have the same schema.  You could also push the image to a central registry that everyone can pull from.  You can now use a container image like this for automated testing in the test environment.  You can also run this over a copy/snapshot of production database files in a pre-production environment so you can test the deployment before you deploy th enew image into production.