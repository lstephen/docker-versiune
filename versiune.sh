#!/usr/bin/env bash

set -e

function txt {
  echo $version > $output
}

function python {
  echo "__version__ = '$version'" > $output
}

version=$(git log --oneline --first-parent master | wc -l | xargs)

branch=$(git branch | grep '*')

if [[ ! $branch =~ master$ ]]
then
  branch_count=$[$(git log --oneline --first-parent | wc -l | xargs) - $version]
  version="$version.dev$branch_count"
fi

format=txt

while getopts "f:" opt
do
  case $opt in
    f)
      format=$OPTARG
      ;;
  esac
done

shift $((OPTIND-1))

output=${1-/dev/stdout}

$format

