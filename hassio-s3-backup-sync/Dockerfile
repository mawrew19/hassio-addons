ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add --no-cache jq curl findutils unzip
    # && \
    # curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
    # unzip awscli-bundle.zip && \
    #./awscli-bundle/install -b ~/bin/aws
# Copy data for add-on
RUN apk -Uuv add groff less python py-pip
RUN pip install awscli
RUN apk --purge -v del py-pip
RUN rm /var/cache/apk/*

COPY run.sh /
RUN ["chmod", "a+x", "/run.sh"]

CMD [ "/run.sh" ]
