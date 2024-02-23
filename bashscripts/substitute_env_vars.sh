#!/bin/sh
# substitute_env_vars.sh

# Loop over each CI variable
for var in $(printenv)
do
    # Split the string into the variable name and its value
    varname=$(echo "$var" | cut -d '=' -f 1)
    varvalue=$(echo "$var" | cut -d '=' -f 2-)

    # Loop over each file that starts with .env
    for file in .env*
    do
        # Replace placeholders in the current file with actual values
        sed -i "s|\${$varname}|$varvalue|g" $file
    done
done
