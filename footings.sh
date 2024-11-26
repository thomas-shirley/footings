#/usr/bin/env bash

# general
sitename="sitename"
baseurl="https://sitename.net"
lang="en"
datedfolders=true

# color theme
background_color="#f6f7fc"
text_color="#343636"
link_color="#006edc"
quote_color="#f6d6d9"

render_template(){
local title=$1
local content=$2

local html="<!DOCTYPE html>
<html lang=\"${lang:=en}\">
<head>
<meta charset=\"utf-8\">
<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
<title>$title</title>
</head>
<body>
<main>
$content
</main>
<footer>
</footer>
</html>
"

printf "%s\n" "$html"
}

wrap_index_content(){
local content=$1

local index_content="

<h1>$sitename</h1>
<ul>
$content
</ul>
"
printf "%s\n" "$index_content"
}

usage() {
  printf "usage: $0 SRC_DIR DST_DIR\n"
  exit 1
}

[[ -d $1 ]] && source_dir=$1 || usage
[[ ! -z $2 ]] && dest_dir=$2 || usage

# remove trailing slash from baseurl
baseurl=${baseurl%/}

posts_dir="$dest_dir/posts"
posts_url="$baseurl/posts"
post_list=()
date_list=()
mkdir -p $posts_dir


mdfiles=($source_dir/*.md)
for ((i=${#mdfiles[@]}-1;i>=0;i--)); do
  filename="${mdfiles[$i]##*/}"
  read -r pubdate name ext <<< ${filename//./ }
  post=$(markdown $source_dir/$filename)
  [[ $post =~ \<h1\>(.*)\</h1\> ]] && post_title=${BASH_REMATCH[1]}

  #Check to see whether we should create dated folders and nest the posts
  if [[ "$datedfolders" == "true" ]]; then
  mkdir $posts_dir/${filename:0:10}
  strippedfilename=${filename#*.}
  cleanfilename=${strippedfilename%.*}
  datefolder=${filename:0:10}
  render_template "$post_title" "$post" > $posts_dir/${datefolder}/${cleanfilename}.html
  else
  render_template "$post_title" "$post" > $posts_dir/${filename%%.md}.html
  fi

  # Add to the array of dates and then sort it.
  post_list+=${datefolder}
  # Convert date to YYYY-MM-DD
  # Create epoch date
  y_date=${datefolder:6:10}

  m_date=${datefolder:3:2}

  d_date=${datefolder:0:2}

  ymd_date="$y_date-$m_date-$d_date 00:00:00"
  epochdate=$(date -j -f "%Y-%m-%d %H:%M:%S" "$ymd_date" "+%s")

  # Add the values to an array, with dates as keys and comma separate the filename, original date and post title.
  date_list["${epochdate}"]="$posts_url/$datefolder/${cleanfilename}.html",${datefolder},${post_title}
done

#Sort the keys of the array into date order. Then process them into posts.
IFS=$'\n' sorted_keys=($(printf '%s\n' "${!date_list[@]}" | sort -nr))

# Loop through the sorted keys and generate the post date, post title and post url. Finally, generate the post list.
for value in "${sorted_keys[@]}"; do
no_filename=${date_list["${value}"]#*,}
url=${date_list["${value}"]%%,*}
post_date=${no_filename:0:10}
post_title=${no_filename:11}
posts_list2+="
<li class=\"pl0\">
<a href=\""$url"\">$post_title</a> - $post_date
</li>
"
done

index_content=$(wrap_index_content "$posts_list2")
render_template "$sitename" "$index_content" > $dest_dir/all.html
