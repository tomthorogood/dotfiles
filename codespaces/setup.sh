#!/usr/bin/env bash

HERE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )

git config --global user.name "Tom Thorogood"
git config --global user.email "tomthorogood@github.com"

${HERE}/../git/configure.sh
${HERE}/../starship/install.sh
${HERE}/../vim/configure.sh
