#!/usr/bin/env bash

list_unused_roles=()
max_idle_days=90
max_items=50

declare -A job_list

get_report() {
    : '
        param $1: job_list # should be an array
    '

    for role_name in ${!job_list[@]}; do
        # echo "RoleName - $role_name"
        response=$(aws iam get-service-last-accessed-details --job-id ${job_list["$role_name"]})
        all_more_then_max="true"
        recent_date=$(date -d "0001-01-01T00:00:00" +"%s") # Equalent to python datatime.min
        recent_date_p="0001-01-01T00:00:00"
        last_auth_dates=($(echo $response | jq -rc '.ServicesLastAccessed[].LastAuthenticated' | sed 's/+00:00//g' | sed "s/'//g;s/\r//g"))
        for lad in ${last_auth_dates[*]}; do
            if [[ ! "null" == "$lad" ]]; then
                date_now=$(date +"%s")
                date_lad=$(date -d $lad +"%s")
                diff_days=$((($date_now-$date_lad)/60/60/24))
                if [[ $diff_days -lt $max_idle_days ]]; then
                    all_more_then_max="false"
                    if [[ $date_lad -gt $recent_date ]]; then
                        recent_date=$date_lad
                        recent_date_p=$lad
                    fi
                fi
            fi
        done  
        if [[ $all_more_then_max == "true" ]]; then
            list_unused_roles+=("$role_name")
            echo "RoleName $role_name and JobID ${job_list["$role_name"]} added to list with recent date $recent_date_p"
        fi  
    done
}

generate_report() {
    : '
        param $1: arns
    '

    arns=$1
    for arn in ${arns[*]}; do
        role_name=$(echo $arn | awk 'gsub("/"," ") {print $NF}')
        job_id="$(aws iam generate-service-last-accessed-details --arn "$arn" | jq '.JobId' | sed 's/"//g' | sed "s/'//g;s/\r//g")"
        job_list["$role_name"]="$job_id"
        #get_report ${job_list[@]}
    done
    echo "Job Created"
    #echo ${job_list[@]}

    get_report ${job_list[@]}
}

get_roles() {
    arns=($(aws iam list-roles --max-items $max_items | jq -rc '.Roles[].Arn' | sed "s/'//g;s/\r//g"))
    generate_report ${arns[@]}
}

# delete_unused_roles() {
#     get_roles
#     for role_name in ${list_unused_roles[*]}; do
#         aws iam delete-role --role-name $role_name
#         echo "Deleted role $role_name"
#     done
# }

# delete_unused_roles
get_roles
echo "Unused Roles - ${list_unused_roles[@]}"
