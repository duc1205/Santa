#!/usr/bin/env bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# includes
source ${ROOT_DIR}/config.sh
source ${ROOT_DIR}/helper.sh

# env
env=$1
source ${ROOT_DIR}/envs/${env}/config.sh

# args
git_branch=$(get_arg $2 ${GIT_BRANCH})
remove_build_dir=$(get_arg $3 1)

# download source
build_dir=$(mktemp -d)
download_source ${GIT_URL} ${git_branch} ${build_dir}
cp -rf ${ROOT_DIR}/envs/${env}/assets/ ${build_dir}/

# read version
cd ${build_dir}
version=`grep 'version: ' pubspec.yaml | sed 's/version: //'`
version_name="$(cut -d'+' -f1 <<< ${version})"
version_code="$(cut -d'+' -f2 <<< ${version})"

# badge app icons
cd ${build_dir}/android
if [[ ${BADGE_APP_ICON} != "0" ]]; then
    badge --shield "${env}-${version_name}-blue" --shield_scale 0.75 --no_badge --glob "/**/ic_launcher*.{png,PNG}"
fi

# prepare build
cd ${build_dir}
python fvm.py
fvm flutter clean
fvm flutter pub get
fvm flutter pub run build_runner build --delete-conflicting-outputs
fvm flutter pub run easy_localization:generate -f keys -O lib -o locale_keys.g.dart --source-dir ./assets/langs

# build
output_dir=$(mktemp -d)
cd ${build_dir}
if [[ ${ANDROID_EXPORT_TYPE} == "aab" ]]; then
    fvm flutter build appbundle --release
    cp ${build_dir}/build/app/outputs/bundle/release/app-release.aab ${output_dir}/app.aab
else
    fvm flutter build apk --release
    cp ${build_dir}/build/app/outputs/apk/release/app-release.apk ${output_dir}/app.apk
    cp ${build_dir}/build/app/outputs/mapping/release/mapping.txt ${output_dir}/mapping.txt
fi
echo "Output dir: ${output_dir}"

# upload to firebase
commit_id=$(get_commit_id ${GIT_URL} ${git_branch})
if [[ ${FIREBASE_APP_DISTRIBUTION_UPLOAD} != "0" ]]; then
  cd ${output_dir}
  release_note="Built At: $(date) | Commit ID: ${commit_id}"
  firebase appdistribution:distribute "app.${ANDROID_EXPORT_TYPE}" --app "${FIREBASE_ANDROID_APP_ID}" --groups "${FIREBASE_APP_DISTRIBUTION_GROUP}" --release-notes "${release_note}"
fi

# upload to transfer.sh
if [[ ${TRANSFER_SH_UPLOAD} != "0" ]]; then
  cd ${output_dir}
  app_url="$(curl -u ${TRANSFER_SH_USERNAME}:${TRANSFER_SH_PASSWORD} --upload-file app.${ANDROID_EXPORT_TYPE} https://transfer.sugamobile.com/app.${ANDROID_EXPORT_TYPE})"
fi

# notify
notifyToSlack ${SLACK_WEBHOOK_URL} \
    "$(printf 'Project: %s (%s)\nPlatform: Android\nVersion: %s %s\nPipeline: %s\nApp URL: %s' \
        "$(echo ${GIT_URL} | sed "s/^git@gitlab.com:\(.*\).git$/\1/")" \
        "${env}" \
        "${git_branch}" \
        "${commit_id}" \
        "${CI_PIPELINE_URL}" \
        "${app_url}" \
    )"

# remove build dir
if [[ ${remove_build_dir} != "0" ]]; then
    rm -rf ${build_dir}
else
    echo "Build dir: ${build_dir}"
fi
