#!/usr/bin/env bash

set -e

format=txt
module=UNKNOWN
template=\$version

while getopts "f:m:t:" opt
do
  case $opt in
    f)
      format=$OPTARG
      ;;
    m)
      module=$OPTARG
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

function format_ruby {
  cat << EOF
module $module
  VERSION = "$version"
end
EOF
}

#sha_is_on_master=$(git branch -r --contains $sha | grep origin/master)


current_sha=$(git rev-parse HEAD)
master_sha=$(git merge-base origin/master $current_sha)

master_version=$(git log --format=%H --first-parent origin/master | sed -n "/$master_sha/,\$p" | wc -l | xargs)
timestamp=$(date +%Y%m%d.%H%M)

if [[ $current_sha == $master_sha ]]
then
  version=$master_version
else
  version="${master_version}.${timestamp}"
fi

version=$(eval "echo $template")

output=${1-/dev/stdout}

mkdir -p $(dirname $output)

exec > $output

"format_$format"

