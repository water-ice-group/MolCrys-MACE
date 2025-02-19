#!/bin/bash

# Define the target file and the DISP file
TARGET_FILE="runphon.sh"
DISP_FILE="DISP"

# Read DISP content and handle the last line's backslash
DISP_CONTENT=$(cat $DISP_FILE | sed '$s/\\$//')

# Use awk to replace the lines between "for i in \\" and "do" in the target file
awk -v disp_content="$DISP_CONTENT" '
BEGIN {
    for_i_block = 0;
}
/^for i in \\$/ {
    for_i_block = 1;
    print $0;
    print disp_content;
    next;
}
for_i_block && /^do$/ {
    for_i_block = 0;
    print;
    next;
}
!for_i_block {
    print;
}
' $TARGET_FILE > temp_file && mv temp_file $TARGET_FILE
