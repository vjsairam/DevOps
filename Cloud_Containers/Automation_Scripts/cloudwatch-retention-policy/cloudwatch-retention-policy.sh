
ACCOUNT_ID=
REGION=us-east-1
log_group_names=($(cat cloudwatch-log-group-name.txt | sed 's/\"//g'))
log_group_names_without_expiry=($(cat cloudwatch-log-group-name-without-expiry.txt | sed 's/\"//g'))


get_cloudwatch_log_group_names() {
    aws logs describe-log-groups | jq ".logGroups[].logGroupName" > cloudwatch-log-group-name.txt
}

get_cloudwatch_log_retention() {
    for log_group_name in ${log_group_names[*]}; do
        echo $log_group_name
            if [[ $(MSYS_NO_PATHCONV=1 aws logs describe-log-groups --log-group-name-prefix $log_group_name | jq ".logGroups[].retentionInDays") == null ]]
            then
                echo ${log_group_name} >> cloudwatch-log-group-name-without-expiry.txt
            else
                echo "" 
            fi
    done 
}

put_cloudwatch_log_retention() {
    for log_group_name_without_expiry in ${log_group_names_without_expiry[*]}; do
        echo $log_group_name_without_expiry
        aws logs put-retention-policy --log-group-name $log_group_name_without_expiry --retention-in-days 7
    done     
}

#get_cloudwatch_log_group_names
get_cloudwatch_log_retention
#put_cloudwatch_log_retention
