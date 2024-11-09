#!/bin/bash

yml_file="params.yml"
#reading the version and size from the params.yml file
version=$(yq e ".version" "$yml_file")
size=$(yq e ".size.\"$version\"" "$yml_file")

echo "The size for the version $version is $size"

data_file="datahub/data.json"
new_data="datahub/temp_data.json"

#check if the version exists
if [[ -n "$size" ]]; then
	echo "The size for the version $version is $size"

	curl -s "https://jsonplaceholder.typicode.com/photos" | jq ".[:$size}" > "$new_data"
	if [[ -f "$data_file" ]]; then
		if cmp -s "$new_data" "$data_file"; then
			echo "No changes; data has not changed"
			rm "$new_data"
			exit 0
		else
			echo "data is different"
			mv "$new_data" "$data_file"
			echo "updated the data.json"
		fi
	else
		echo "No existing data file found"
		mv "$new_data" "$data_file"
		echo "Created new data.json file"
	fi
else
	echo "No size for the version $version"
	rm "$new_data"
	exit 1
fi
echo "The current data version is $version"
echo "The data size for the version is $size"

