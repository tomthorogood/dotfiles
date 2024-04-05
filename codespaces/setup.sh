#!/usr/bin/env bash

HERE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )

${HERE}/../git/configure.sh
${HERE}/../starship/install.sh
${HERE}/../vim/configure.sh
