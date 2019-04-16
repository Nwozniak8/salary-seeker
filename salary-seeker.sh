read -p "Enter job ID:" job_id

counter='1'
response='1'
lower_limit='30000'
upper_limit='200000'
salary_var=$((lower_limit + (upper_limit - lower_limit) / 2))

job_title=$(curl --silent https://chalice-search-api.cloud.seek.com.au/search?jobid=$job_id | tr ',' '\n' | sed 's/{"title":"//g' | grep '"title":"' | cut -d '"' -f 4)
echo "    | job title: "$job_title
keywords=$(curl --silent https://chalice-search-api.cloud.seek.com.au/search?jobid=$job_id | sed "s/.*$job_id\(.*\)teaser.*/\1/" | cut -d '"' -f 8 | tr -c '[:alnum:]\n\r' '+')
advertiser_id=$(curl --silent https://chalice-search-api.cloud.seek.com.au/search?jobid=$job_id | sed "s/.*advertiser\(.*\)description.*/\1/" | cut -d '"' -f 5)

while [[ $counter -lt '19' ]]
do
  response=$(curl --silent "https://chalice-search-api.cloud.seek.com.au/search?keywords=$keywords&advertiserid=$advertiser_id&sourcesystem=houston&salaryrange=$salary_var-$upper_limit" | grep "$job_id" | wc -l)
  if [[ $response -eq '1' ]]
  then
    lower_limit=$salary_var
    printf "    | finding maximum > ""$""%d\r" "$salary_var"
    salary_var=$(((salary_var + (upper_limit - salary_var) / 2)))
  elif [[ $response -eq '0' ]]
  then
    upper_limit=$salary_var
    printf "    | finding maximum > ""$""%d\r" "$salary_var"
    salary_var=$(((salary_var - (salary_var - lower_limit) / 2)))
  fi
  ((counter++))
done

salary_max=$salary_var

counter='1'
lower_limit='30000'
upper_limit=$salary_max
salary_var=$((lower_limit + (upper_limit - lower_limit) / 2))

while [[ $counter -lt '16' ]]
do
  response=$(curl --silent "https://chalice-search-api.cloud.seek.com.au/search?keywords=$keywords&advertiserid=$advertiser_id&sourcesystem=houston&salaryrange=$lower_limit-$salary_var" | grep "$job_id" | wc -l)
  if [[ $response -eq '1' ]]
  then
    upper_limit=$salary_var
    printf "    | finding minimum > ""$""%d\r" "$salary_var"
    salary_var=$(((salary_var - (salary_var - lower_limit) / 2)))
  elif [[ $response -eq '0' ]]
  then
    lower_limit=$salary_var
    printf "    | finding minimum > ""$""%d\r" "$salary_var"
    salary_var=$(((salary_var + (upper_limit - salary_var) / 2)))
  fi
  ((counter++))
done

salary_min=$salary_var

if [[ $salary_max -gt '199998' ]]
then
  plus='+'
fi

echo -e "    | salary range: ""\033[1m""$"$salary_min" - ""$"$salary_max$plus"\033[0m"
echo -e $job_title"  " $job_id"\n Salary range: ""$"$salary_min" - ""$"$salary_max$plus"\n https://www.seek.com.au/job/"$job_id "\n" >> Jobs.csv

