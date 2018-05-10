#!/bin/bash
#wait for sqlservr to start up
sleep 10s
for i in `ls ./sqlscripts_hydration/* | sort -V`; do echo $i && /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -i $i ; done;

if [ "$CREATE_TEST_DATA" == "Y" ]
then
    for i in `ls ./sqlscripts_testdata/* | sort -V`; do echo $i && /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -i $i ; done;
fi