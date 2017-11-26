#!/bin/bash

LINE_TO_ADD='PATH="$HOME/.kube/bin:$PATH"'
ZSHRC_LOCATION=~/.zshrc
BASH_PROFILE_LOCATION=~/.bash_profile

check_if_line_exists_zshrc()
{
    # grep wont care if one or both files dont exist.
    grep -qsFx "$LINE_TO_ADD" $ZSHRC_LOCATION
}

add_line_to_zshrc()
{
  TARGET_FILE=$ZSHRC_LOCATION
    [ -w "$TARGET_FILE" ] || TARGET_FILE=$ZSHRC_LOCATION
    printf "%s\n" "$LINE_TO_ADD" >> "$TARGET_FILE"
}

check_if_line_exists_bash_profile()
{
    # grep wont care if one or both files dont exist.
    grep -qsFx "$LINE_TO_ADD" $BASH_PROFILE_LOCATION
}

add_line_to_bash_profile()
{
  TARGET_FILE=$BASH_PROFILE_LOCATION
    [ -w "$TARGET_FILE" ] || TARGET_FILE=$BASH_PROFILE_LOCATION
    printf "%s\n" "$LINE_TO_ADD" >> "$TARGET_FILE"
}

check_if_line_exists_zshrc || add_line_to_zshrc
check_if_line_exists_bash_profile || add_line_to_bash_profile
