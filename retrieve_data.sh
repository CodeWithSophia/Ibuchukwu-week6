#!/bin/bash

# Load version and size from params.yml
version=$(grep '^version:' params.yml | awk '{print $2}' | tr -d '"')
size=$(grep "  \"$version\":" params.yml | awk '{print $2}' | tr -d '"')

# Define the API endpoint 
url="https://jsonplaceholder.typicode.com/photos/data?version=$version&size=$size"

# Fetch data from the API using curl and format it with jq
new_data=$(curl -s "$url" | jq ".[:$size]")

# Check if the datahub/data.json file exists, and compare data if it does
if [ -f "datahub/data.json" ]; then
    # Compare the current and newly fetched data
    current_data=$(jq . datahub/data.json)
    if [ "$new_data" == "$current_data" ]; then
        echo "No changes; data has not changed"
        exit 0
    fi
fi

# If data is different or datahub/data.json does not exist, save the new data
echo "$new_data" > datahub/data.json
echo "Data has been updated in datahub/data.json"

