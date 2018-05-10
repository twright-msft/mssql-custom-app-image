FROM microsoft/mssql-server-linux

COPY ./entrypoint.sh .
COPY ./hydrate_db.sh .
COPY ./sqlscripts_hydration ./sqlscripts_hydration
COPY ./sqlscripts_testdata ./sqlscripts_testdata

RUN chmod a+x ./entrypoint.sh
RUN chmod a+x ./hydrate_db.sh

CMD ["/bin/bash", "./entrypoint.sh"]