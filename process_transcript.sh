#!/bin/bash

#####################################
# README
#
# This script takes a Zoom transcript file and consolidates the
# content to make it easier to read and find quotes. It gets rid
# of timestamps, blank lines, and line numbers. It takes multiple sequential
# soundbites from the same person and puts them together. 
#
# By Eleanor Siler, 27 Feb 2024

# How to Use:
#
# Open your bash terminal, navigate to the file with your transcript, and type the following line,
# replacing the sample_Recording... with your recording name, and sample_output.txt with what you
# want your consolidated output file to be called. 
#
# ./process_transcript.txt sample_Recording.transcript.vtt sample_output.txt
#
# This will work if your filenames are correct and your transcript, and you are all in the same file/directory.
# If this isn't true, either change the filenames appropriately or move stuff 
# So everything is in the same file.
#
# Usage for more experienced ppl:
# ./process_transcript.sh -input_file -output_file
#
#####################################
input_file="$1"
output_file="$2"

# Filter lines and process them
awk '!/^[[:digit:]]|^[[:space:]]*$/ && !/[[:digit:]]$/' "$input_file" | awk -F ':' -v output="$output_file" '
{
    # If this is the first line, set previous text to the text before the colon
    if (NR == 1) {
        prev_text = $1
        print $0 > output
    } else {
        # If the text before the colon is different from the previous line
        if ($1 != prev_text) {
            prev_text = $1
            print $0 > output
        } else {
            # Append the text after the colon to the previous line
            printf " %s", $2 >> output
        }
    }
}

END {
    # Close the output file at the end
    close(output)
}
'

