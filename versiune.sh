#!/usr/bin/env bash

set -e

format=txt
template=\$version

while getopts "f:t:" opt
do
  case $opt in
    f)
      format=$OPTARG
      ;;
    t)
      template=$OPTARG
      ;;
  esac
done

shift $((OPTIND-1))

function format_txt {
  echo $version
}

function format_python {
  echo "__version__ = '$version'"
}

version=$(git log --oneline --first-parent origin/master | wc -l | xargs)

branch=$(git branch | grep '*')

if [[ ! $branch =~ master$ ]]
then
  branch_count=$[$(git log --oneline --first-parent | wc -l | xargs) - $version]
  version="$version.dev$branch_count"
fi

version=$(eval "echo $template")

output=${1-/dev/stdout}

exec > $output

"format_$format"

