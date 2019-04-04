#!/bin/bash
set -e


info() {
    printf "\e[1;33m"
    echo "=> ${1}"
    printf "\e[0m"
}

error() {
    printf "\033[0;31m"
    echo "=> ${1}"
    printf "\e[0m"
}

ok() {
    printf "\e[0;32m"
    echo "=> ${1}"
    printf "\e[0m"
}


# Exit if not a git project
IS_GIT_PROJECT=$(git rev-parse --is-inside-work-tree)

if [[ "$IS_GIT_PROJECT" != "true" ]]; then
    error "The directory must be a valid git project!"
    exit 1
fi


# Project name
PROJECT_NAME=${PROJECT_NAME}

if [[ -z "${PROJECT_NAME}" ]]; then
	error "PROJECT_NAME variable is empty."
	exit 1
fi


# Artifact root
ARTIFACT_DESTINATION_ROOT=${ARTIFACT_DESTINATION_ROOT}

if [[ -z "${ARTIFACT_DESTINATION_ROOT}" ]]; then
	error "ARTIFACT_DESTINATION_ROOT variable is empty."
	exit 1
fi


# Working directory
WORKING_DIRECTORY=$(pwd)

# Timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H%M%S")

# Project name
DIRECTORY_TO_ARCHIVE=${DIRECTORY_TO_ARCHIVE-${WORKING_DIRECTORY}}

# Git
BRANCH_NAME=${BRANCH_NAME:-$(git rev-parse --abbrev-ref HEAD)}
COMMIT_HASH=$(git rev-parse --short HEAD)

# Paths
ARTIFACT_FILE=/tmp/${TIMESTAMP}_${PROJECT_NAME}_${COMMIT_HASH}_artifact.tar.gz
ARTIFACT_DESTINATION=${ARTIFACT_DESTINATION_ROOT}/${PROJECT_NAME}/${BRANCH_NAME}/${TIMESTAMP}_${COMMIT_HASH}.tar.gz

info "Compressing ${DIRECTORY_TO_ARCHIVE} -> ${ARTIFACT_FILE}..."
tar -czf ${ARTIFACT_FILE} -C ${DIRECTORY_TO_ARCHIVE} .

info "Publishing artifact..."
mc cp ${ARTIFACT_FILE} ${ARTIFACT_DESTINATION} --quiet

info "Cleaning..."
rm -rf ${ARTIFACT_FILE}

ok "Artifact published!"

