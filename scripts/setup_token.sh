#!/usr/bin/env bash
set -euo pipefail

export AWS_WEB_IDENTITY_TOKEN_FILE=${AWS_WEB_IDENTITY_TOKEN_FILE:-"/tmp/awscreds"}
export AWS_ROLE_ARN=${AWS_ROLE_ARN:-"not-specified"}
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-"eu-central-1"}
export GITHUB_ENV=${GITHUB_ENV:-.github_env}
export ACTIONS_ID_TOKEN_REQUEST_TOKEN=${ACTIONS_ID_TOKEN_REQUEST_TOKEN:-"not-specified"}
export ACTIONS_ID_TOKEN_REQUEST_URL=${ACTIONS_ID_TOKEN_REQUEST_URL:-"not-specified"}

function set_github_env_value {
  local ENV="${1}"
  local VALUE="${2}"
  [ -e "${GITHUB_ENV}" ] || touch "${GITHUB_ENV}"
  sed -i "/^${ENV}=/d" "${GITHUB_ENV}"
  echo "${ENV}=${VALUE}" >> "${GITHUB_ENV}"
}

echo "Creating token for role ${AWS_ROLE_ARN}"
set_github_env_value AWS_WEB_IDENTITY_TOKEN_FILE "${AWS_WEB_IDENTITY_TOKEN_FILE}"
set_github_env_value AWS_ROLE_ARN "${AWS_ROLE_ARN}"
set_github_env_value AWS_DEFAULT_REGION "${AWS_DEFAULT_REGION}"
curl -H "Authorization: bearer ${ACTIONS_ID_TOKEN_REQUEST_TOKEN}" "${ACTIONS_ID_TOKEN_REQUEST_URL}" \
  | jq -r '.value' > "${AWS_WEB_IDENTITY_TOKEN_FILE}"
