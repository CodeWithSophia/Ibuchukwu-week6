#!/bin/bash

# Load version and size from params.yml
version=$(yq '.version' params.yml | sed 's/"//g')
size=$(yq ".size.\"$version\"" params.yml)

# Define the API endpoint 
url="https://jsonplaceholder.typicode.com/photos"

# Fetch data from the API using curl and format it with jq
new_data=$(curl -s "$url" | jq --argjson size "$size" '.[:$size]')

# Check if the datahub/data.json file exists, and compare data if it does
if cmp -s <(echo "$new_data") "datahub/data.json"; then
        echo "No changes; data has not changed"
        exit 0
else

	echo "$new_data" > "datahub/data.json"
	echo "Data has been updated in datahub/data.json"
fi
