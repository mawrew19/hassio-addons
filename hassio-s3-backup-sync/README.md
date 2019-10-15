# hassio-s3-backup-sync
This is inspired by DropBox Sync addon: https://github.com/danielwelch/hassio-addons
It uses the same trigger mechansim as the DropBox Sync addon, by sending the "upload" command to STDIN.

This is still a work-in-progress, so please treat it as such.

The use of AWS and S3 is NOT a free service, please be aware of that fact prior to moving forward.

To get this to work you will need an AWS account (free) and you will need to setup your own S3 bucket (charges will be incurred when storing data).
Additionally, you will need to setup a user in AWS IAM which has access to your new S3 bucket. This bucket should NOT be made public.

  "AWSAccessKey": - The access key for the AWS IAM user
  
  "AWSSecret":  - The "secret" key for the AWS IAM user
  
  "BucketName": - The name of the S3 bucket
  
  "RetainFiles": - How many files to retain

  This addon will remove all but the latest number of files as defined by the RetainFiles value on both the local container as well as in the S3 bucket.

  If this is set to 3, then only the latest 3 files will be kept in both locations.

