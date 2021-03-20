#!/usr/bin/env bash

# Based on okular/hooks/pre-commit, credits go to Albert Astals Cid

readonly output=$(git clang-format --diff)

if [[ "$output" == *"no modified files to format"* ]]; then exit 0; fi
if [[ "$output" == *"clang-format did not modify any files"* ]]; then exit 0; fi

display_usage_help () {
    echo "ERROR: You have unformatted changes, please format your files. You can do this using the following commands:"
    echo "       git clang-format --force # format the changed parts"
    echo "       git clang-format --diff # preview the changes done by the formatter"
}

# Output the diff if we are already in a shell
if [ -t 1 ]
then
    echo ""
    echo "The \"git clang-format --diff\" output is:"
    git clang-format --diff
    echo ""
    echo "Do you want to a) apply the formatting and add all tracked files, y) format the files and exit and n) to abort a/y/n"
    read -p "" response < /dev/tty
    while true; do
        case $response in
            [Aa]* ) git clang-format -f; git add -u; exit 0; break;;
            [Yy]* ) git clang-format -f; exit 1; break;;
            [Nn]* ) display_usage_help; exit 1;;
            * ) echo "Please answer a or y or n";;
        esac
    done
else
    echo "$output"
    display_usage_help
fi
exit 1
