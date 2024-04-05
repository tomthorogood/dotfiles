#!/usr/bin/env bash

email=

function parse_args {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -e|--email)
                email=$2
                shift
                ;;
            *)
                echo "Unknown argument: $1"
                exit 1
                ;;
        esac
        shift
    done
}


git config --global user.name "Tom Thorogood"
git config --global user.email "${email}"

git config --global alias.ninja 'commit --amend --no-edit'
