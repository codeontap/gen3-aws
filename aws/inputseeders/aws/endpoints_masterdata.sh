#!/usr/bin/env bash

profile="$1"; shift
process="${1-true}"

if [[ "${process}" == "true" ]]; then

  [[ -z "${profile}" ]] && echo -e "\nScript requires a profile as the first parameter to use when querying AWS" && exit 1

  # Ignore the directory used to collect the data
  [[ ! -f .gitignore ]] && echo "endpoints/" > .gitignore

  if [[ ! -d endpoints ]]; then
    mkdir -p endpoints/gateway
  fi

  # List of regions
  aws --profile "${profile}" --region ap-southeast-2 ec2 describe-regions | jq -r '.Regions | .[].RegionName' | dos2unix | sort > amis/regions.txt
  readarray -t regions < endpoints/regions.txt

  # Find network gateway endpoints for each region
  declare -A gateway_endpoints

  for region in "${regions[@]}"; do
    aws --profile "${profile}" --region "${region}" ec2 describe-vpc-endpoints --filters 'Name=vpc-endpoint-type,Values=Gateway' 'Name=vpc-endpoint-state,Values=available' > "endpoints/gateway/${region}.json"
    gateway_endpoints["${region}"]="$(jq -r ".VpcEndpoints" < "endpoints/gateway/${region}.json")"
  done
else
  readarray -t regions < endpoints/regions.txt
fi

# Merge with current master file
echo "Generating master gateway endpoints ftl file ..."

index=0
filter=".[${index}]"
files=("")
for region in "${regions[@]}"; do
  index=$(( $index + 1 ))
  filter="${filter} * .[$index]"
  files+=("endpoints/gateway/${region}.json")
done

jq --indent 4 -s "${filter}" "${files[@]}" > endpoints/gateway.json
