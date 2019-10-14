ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8
#RUN apk add --no-cache jq curl findutils python3 python3-dev && \
#    pip3 install requests python-dateutil==2.6.1 pytz==2018.3 && \
#	pip3 install awscli --upgrade --user
RUN apk add --no-cache jq curl findutils python3 python3-dev && \
    pip3 install requests python-dateutil==2.6.1 pytz==2018.3 && \
	pip3 install awscli --upgrade --user 

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]