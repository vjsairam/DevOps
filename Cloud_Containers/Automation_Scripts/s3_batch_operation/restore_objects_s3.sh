
ACCOUNT_ID=
REGION=us-east-1
ROLE_ARN=
INVENTORY_BUCKET=
REPORT_BUCKET=
bucket_names=($(cat restore_bucket_list.txt | sed 's/ //g'))

### Push the Output files to INVENTORY_BUCKET
s3_upload_manifest() {
    for bucket_name in ${bucket_names[*]}; do
        echo $bucket_name
        aws s3api list-objects-v2 --bucket $bucket_name --query "Contents[?StorageClass=='DEEP_ARCHIVE']" --output text | awk '{print "'"$bucket_name,"'",$2}' > $bucket_name.csv
        sed -i 's/, /,/' $bucket_name.csv
        aws s3 cp $bucket_name.csv s3://$INVENTORY_BUCKET/cloudfront_s3_object_restore/$bucket_name.csv
    done
}

s3_batch_operations_wo_inventory() {
    for bucket_name in ${bucket_names[*]}; do
        echo $bucket_name
        ETag=($(aws s3api head-object --bucket $INVENTORY_BUCKET --key cloudfront_s3_object_restore/$bucket_name.csv --query ETag --output text))
        echo $ETag
        aws s3control create-job \
        --account-id $ACCOUNT_ID \
        --region $REGION \
        --no-confirmation-required \
        --operation '{"S3InitiateRestoreObject":{"ExpirationInDays":365,"GlacierJobTier":"BULK"}}' \
        --manifest '{"Spec":{"Format":"S3BatchOperations_CSV_20180820","Fields":["Bucket","Key"]},"Location":{"ObjectArn":"arn:aws:s3:::'$INVENTORY_BUCKET'/cloudfront_s3_object_restore/'$bucket_name'.csv","ETag":'$ETag'}}' \
        --report '{"Bucket":"arn:aws:s3:::'$REPORT_BUCKET'","Prefix":"cloudfront_s3_object_restore/final-reports", "Format":"Report_CSV_20180820","Enabled": true,"ReportScope":"AllTasks"}' \
        --description "$bucket_name Restore Job" \
        --priority 70 \
        --role-arn $ROLE_ARN 
    done 
}

s3_batch_operations_with_inventory() {
    for bucket_name in ${bucket_names[*]}; do
        echo $bucket_name
        ETag=($(aws s3api head-object --bucket $INVENTORY_BUCKET --key $bucket_name/s3-incident-recover/2022-08-21T00-00Z/manifest.json --query ETag --output text))
        echo $ETag
        aws s3control create-job \
        --account-id $ACCOUNT_ID \
        --region $REGION \
        --no-confirmation-required \
        --operation '{"S3InitiateRestoreObject":{"ExpirationInDays":365,"GlacierJobTier":"BULK"}}' \
        --manifest '{"Spec":{"Format":"S3BatchOperations_CSV_20180820","Fields":["Bucket","Key"]},"Location":{"ObjectArn":"arn:aws:s3:::'$INVENTORY_BUCKET'/'$bucket_name'/s3-incident-recover/2022-08-21T00-00Z/manifest.json","ETag":'$ETag'}}' \
        --report '{"Bucket":"arn:aws:s3:::'$REPORT_BUCKET'","Prefix":"cloudfront_s3_object_restore/final-reports", "Format":"Report_CSV_20180820","Enabled": true,"ReportScope":"AllTasks"}' \
        --description "$bucket_name Restore Job" \
        --priority 70 \
        --role-arn $ROLE_ARN 
    done 
}

#s3_upload_manifest
s3_batch_operations_wo_inventory
#s3_batch_operations_with_inventory
