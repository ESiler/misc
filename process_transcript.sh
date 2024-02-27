#!/bin/bash

##############################################
# README
#
# This script takes a Zoom transcript file and consolidates the
# content to make it easier to read and find quotes. It gets rid
# of timestamps, blank lines, and line numbers. It takes multiple sequential
# soundbites from the same person and puts them together. 
#
# By Eleanor Siler, 27 Feb 2024
#
# Usage (more experienced people version):
# ./process_transcript.sh -input_file -output_file
# 
# Usage (step by step version):
# 1. Download this .sh file into to the file as your Zoom transcript
# 2. Open your bash terminal, 
# 3. Navigate to the file with your transcript and this shell script, and 
# 4. type the following line:
#
# > chmod +x process_transcript.sh
# 
# 5. Now run the following line, replacing the sample_Recording... with your recording name, 
#    and sample_output.txt with the name you want for your output file:

# >./process_transcript.txt sample_Recording.transcript.vtt sample_output.txt
#
# 6. Open your new outputed file and enjoy.
#
# My boss gave me a hard time about this readme being too long/being in a weird place
# but I wrote it for my social sciences friend so cut me some slack, geeze. 
#
###############################################

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
