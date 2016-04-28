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

version=$(git log --oneline --first-parent master | wc -l | xargs)

if [[ ! $branch =~ master$ ]]
then
  branch_count=$[$(git log --oneline --first-parent | wc -l | xargs) - $version]
  version="$version.dev$branch_count"
fi

version=$(eval "echo $template")

output=${1-/dev/stdout}

mkdir -p $(dirname $output)

exec > $output

"format_$format"

