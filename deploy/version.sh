#!/usr/bin/env bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# includes
source ${ROOT_DIR}/config.sh
source ${ROOT_DIR}/helper.sh

# args
version_name=$1

# version code
version_code=${VERSION_PREFIX}
for version_segment in $(echo ${version_name} | tr "." "\n")
do
  version_code=${version_code}$(printf "%02d" "${version_segment}")
done
version_code=$(echo ${version_code} | sed 's/^0*//')

# write version
pubspec_file=./pubspec.yaml
write_version ${pubspec_file} ${version_name} ${version_code}

# push to server
git add ${pubspec_file}
git commit -m "Version ${version_name}"
git push origin

# tag version
git tag "v${version_name}"
git push origin "v${version_name}"
