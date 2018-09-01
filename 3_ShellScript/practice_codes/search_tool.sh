#!/bin/bash
loggedUser=4
client=5
recruiter=6
job=7
candidate=8
resume=9
process=10
sales=11
activity=12

echo -e "Insert Specific Date(ex. 2018/08/08) If nothing inserted, yesterday will be assigned: \c"
read date
[ -n date ] && date=`date --date="1 day ago" +%Y/%m/%d`
echo "$date is set as target date"

echo -e "What resource do you want to refer to?"
echo -e " logged user: $loggedUser \n client: $client \n recruiter: $recruiter \n job: $job \n candidate: $candidate \n resume: $resume \n process: $process \n sales: $sales \n activity: $activity"
echo -e "Select its number that you would like(Delimeter for multiple choices is space): \c"
read -a resource_choices

if [ -z "$resource_choices" ]; then
    echo "No resource choices. Process is closed."
    exit
fi

for i in ${resource_choices[@]}; do
    isOk=false
    for j in "loggedUser" "client" "recruiter" "job" "candidate" "resume" "activity" "sales" "activity"; do
        if [ $i == ${!j} ]; then
            isOk=true
            selectedResourceNameList=("${selectedResourceNameList[@]}" $j)
        fi
    done
    if [ "$isOk" == "false" ] ; then
        echo "$i is an wrong input. Process is closed."
        exit;
    fi
done

index=0
while [ $index -lt ${#selectedResourceNameList[@]} ]; do
    echo -e "Minimum ${selectedResourceNameList[($index)]} number: \c"
    read min_${resource_choices[($index)]}
    echo -e "Maximum ${selectedResourceNameList[($index)]} number: \c"
    read max_${resource_choices[($index)]}
    index+=1;
done

# $1 field_column_number
function getMin() {
    local tmp="";
    tmp="min_$1";
    echo ${!tmp};
}
# $1 field_column_number
function getMax() {
    local tmp="";
    tmp="max_$1";
    echo ${!tmp};
}

isMatched="false"
# $1 array - search target list
function doSearch() {
    for resource_field in ${resource_choices[@]}; do
        resource_count=$(echo $1 | cut -d ',' -f$resource_field)
        if [ $resource_count -ge `getMin $resource_field` -a $resource_count -le `getMax $resource_field` ]; then
            isMatched="true"
            continue;
        else
            isMatched="false"
            break;
        fi
    done
}

echo -e "Searching matched data starts............"

for i in $(ls ../../999_samples_for_testing/resource-count_P*.csv); do
    line=$(grep --regexp "$date" $i)
    doSearch $line
    if [ "$isMatched" == "true" ]; then
        echo -e "$i"
    fi
    isMatched="false"
done

echo -e "Done"