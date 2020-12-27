ARG BUILD_FROM
#=amazon/aws-cli
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add --no-cache jq curl findutils unzip aws-cli
    # && \
    # curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
    # unzip awscli-bundle.zip && \
    #./awscli-bundle/install -b ~/bin/aws
# Copy data for add-on


COPY run.sh /
RUN ["chmod", "a+x", "/run.sh"]

CMD [ "/run.sh" ]
