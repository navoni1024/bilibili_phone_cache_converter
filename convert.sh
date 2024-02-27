#!/bin/bash

mkdir output
output=$(pwd)'/output/'
org_path=$(pwd)

for json_path in $(find $org_path -iname 'entry.json'); do
	
	cd $(echo $json_path|sed 's/entry.json//1')

	name=$(jq '.title' entry.json)'-av'$(jq '.avid' entry.json)
	if [ $(jq '.page_data.part' entry.json) != "\"P1\"" ]; then
		name=$(jq '.page_data.part' entry.json)'-'$name
	fi
	name=$(echo $name|sed 's/ /_/g'|sed 's/"//g')

	echo $(jq '.media_type' entry.json)
	
	if [ $(jq '.media_type' entry.json) -eq 1 ]; then
		for blv_name in $(find . -iname '*.blv')
		do
			ff_i=$ff_i'-i '$blv_name' '
		done
	elif [ $(jq '.media_type' entry.json) -eq 2 ]; then
		ff_i='-i '$(find . -iname 'video.m4s')' -i '$(find . -iname 'audio.m4s')' -c:v copy -c:a aac '
 	fi

	ffmpeg $ff_i $output$name.mp4
	
	echo $name
	ff_i=
	cd $org_path

done



