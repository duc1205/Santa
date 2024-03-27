function get_arg {
    local value=${1}
    local default=${2}

    if [ ${value} ]; then
        echo ${value}
    else
        echo ${default}
    fi
}

function command_exists {
    type "$1" &> /dev/null ;
}

function download_source {
    local url=${1}
    local branch=${2}
    local dir=${3}
    local path=${4}

    if [ -d ${dir} ]; then
        rm -Rf ${dir};
    fi
    git clone --quiet -b ${branch} --depth=1 ${url} ${dir}${path}
}

function get_commit_id {
    local url=${1}
    local branch=${2}

    git ls-remote ${url}  | grep refs/heads/${branch} | awk '{ print $1}'
}

function write_version {
    local pubspec_file=${1}
    local version_name=${2}
    local version_code=${3}

    sedi 's/^version: [0-9a-zA-Z -_]*/version: '"${version_name}+${version_code}"'/' ${pubspec_file}
}

function sedi {
  if [ "$(uname)" == "Linux" ]; then
    sed -i "$@"
  else
    sed -i "" "$@"
  fi
}

function notifyToSlack() {
  local webhookUrl=${1}
  local message=${2}

  curl --silent --output /dev/null --data-urlencode \
    "$(printf 'payload={"text": "%s"}' \
        "${message}" \
    )" \
    ${webhookUrl}
}
