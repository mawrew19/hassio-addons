#!/bin/bash

CONFIG_PATH=/data/options.json

AWSACCESSKEY=$(jq --raw-output ".AWSAccessKey" $CONFIG_PATH)
AWSSECRET=$(jq --raw-output ".AWSSecret" $CONFIG_PATH)
BUCKETNAME=$(jq --raw-output ".BucketName" $CONFIG_PATH)
RETAIN=$(jq --raw-output ".RetainFiles" $CONFIG_PATH)

mkdir ~/.aws
cat << EOF > ~/.aws/credentials
 [default]
aws_access_key_id = $AWSACCESSKEY
aws_secret_access_key = $AWSSECRET
EOF


echo `date "+%Y-%m-%d %H:%M:%S"` "[Info] Listening for messages via stdin service call..."

# listen for input
while true; do
while read -r msg; do
    # parse JSON
    cmd="$(echo "$msg" | jq --raw-output '.command')"
	echo `date "+%Y-%m-%d %H:%M:%S"` "------------------------------------------------------------"
    echo `date "+%Y-%m-%d %H:%M:%S"` "[Info] Received message with command: ${cmd}"
    if [[ $cmd = "upload" ]]; then
	    echo `date "+%Y-%m-%d %H:%M:%S"` "[Info] Only keeping ${RETAIN} recent backups."
		DELETEFILES=`ls -t /backup | awk "NR>${RETAIN}"`
		if [ -z "$DELETEFILES" ]
          then
             echo `date "+%Y-%m-%d %H:%M:%S"` "[Info] No files to remove, locally."
          else
             echo `date "+%Y-%m-%d %H:%M:%S"` "[Info] Deleting the following local files:"
             echo "      ${DELETEFILES}"
             cd /backup			 
             rm ${DELETEFILES}			 
         fi
		
        echo `date "+%Y-%m-%d %H:%M:%S"` "[Info] Copying files in /backup to S3 bucket: ${BUCKETNAME}"
        ~/.local/bin/aws s3 sync /backup s3://${BUCKETNAME} --quiet
		echo `date "+%Y-%m-%d %H:%M:%S"` "[Info] Copy complete"
		echo `date "+%Y-%m-%d %H:%M:%S"` "--------"
		echo `date "+%Y-%m-%d %H:%M:%S"` "[Info] Cleaning up older files in S3 bucket: ${BUCKETNAME}"
		~/.local/bin/aws s3 ls s3://${BUCKETNAME} | sort -r | awk "NR>${RETAIN}" | while read -r line;
   		do 
		  fileName=`echo $line|awk {'print $4'}`;
		  if [[ $fileName != "" ]]
          then
            echo "  Removing $fileName"
		    ~/.local/bin/aws s3 rm s3://$BUCKETNAME/$fileName --quiet
          fi
		done
		echo `date "+%Y-%m-%d %H:%M:%S"` "[Info] Cleanup processing of S3 complete"
    else
        # received undefined command
        echo `date "+%Y-%m-%d %H:%M:%S"` "[Error] Command not found: ${cmd}"
    fi
done
sleep 10
done