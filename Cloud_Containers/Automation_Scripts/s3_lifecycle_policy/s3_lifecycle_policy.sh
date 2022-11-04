#!/usr/bin/env bash
set -e

buckets=()

get_bucket_life_cycke_configuration() {
    : '
        Get Bucket Life Cycle Configuration
        param $1: * BucketName
    '

    [ -z "$1" ] && echo "BucketName - Missing argument." && exit
    aws s3api get-bucket-lifecycle-configuration --bucket $1
}

list_buckets() {
    # Getting all the bucket names
    buckets+=($(aws s3api list-buckets --query "Buckets[].Name" | jq --raw-output '.[]' | sed "s/'//g;s/\r//g"))
    # echo "${buckets[@]}"
}

put_bucket_lifecycle_configuration() {
    : '
        Put Bucket Life Cycle Configuration
        param $1: * BucketName
    '
    [ -z "$1" ] && echo "BucketName - Missing argument" && exit
    [ ! -f "lifecycle.json" ] && echo "Missing file - lifecycle.json"
    aws s3api put-bucket-lifecycle-configuration --bucket "$1" --lifecycle-configuration file://lifecycle.json
}

delete_bucket_lifecycle_configuration() {
    : '
        Delete Bucket Life Cycle Configuration
    '
    [ -z "$1" ] && echo "BucketName - Missing argument" && exit
    aws s3api delete-bucket-lifecycle --bucket "$1"
}

put_lifecycle_configuration_to_all_buckets() {
    list_buckets
    if [[ ${#buckets[@]} -gt 0 ]]; then
        for bucket in ${buckets[*]}; do
            put_bucket_lifecycle_configuration "$bucket"
        done
    else 
        echo "No buckets to put_lifecycle_configuration."
        exit
    fi
}

delete_lifecycle_configuration_in_all_buckets() {
    list_buckets
    if [[ ${#buckets[@]} -gt 0 ]]; then
        for bucket in ${buckets[*]}; do
            delete_bucket_lifecycle_configuration "$bucket"
        done
    else 
        echo "No buckets to delete_bucket_lifecycle_configuration."
        exit
    fi
}

#put_lifecycle_configuration_to_all_buckets
delete_lifecycle_configuration_in_all_buckets

