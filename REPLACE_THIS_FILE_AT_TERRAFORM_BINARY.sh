#!/bin/bash

# Path of original application
ORIGINAL_TERRAFORM_PATH="/bin/terraform"
# Two paths of infrastructure to make script working in two clouds
GENERAL_INFRASTRUCTURE_PATH="/terraform/infrastructure"
GCP_INFRASTRUCTURE_PATH="/terraform-gcp/infrastructure"
LOG_DIR=""
LOG_FILE=""

# Default exit code (should not be used)
TerraformExitCode=2

if [[ "$(pwd)" =~ $GENERAL_INFRASTRUCTURE_PATH/.+ ]]; then
    # Create logs folder in the SubFolder
    CurrentPath=$(pwd)
    SubFolder="${CurrentPath/"$GENERAL_INFRASTRUCTURE_PATH/"/}"
    SubFolder="${SubFolder//\/*/}"

    cd "$GENERAL_INFRASTRUCTURE_PATH/$SubFolder"
    mkdir -p "logs"
    cd "$CurrentPath"
    # Set logging directory
    LOG_DIR="$GENERAL_INFRASTRUCTURE_PATH/$SubFolder/logs"
elif [[ "$(pwd)" =~ $GCP_INFRASTRUCTURE_PATH/.+ ]]; then
    CurrentPath=$(pwd)
    SubFolder="${CurrentPath/"$GCP_INFRASTRUCTURE_PATH/"/}"
    SubFolder="${SubFolder//\/*/}"

    cd "$GCP_INFRASTRUCTURE_PATH/$SubFolder"
    mkdir -p "logs"
    cd "$CurrentPath"

    LOG_DIR="$GCP_INFRASTRUCTURE_PATH/$SubFolder/logs"
else
    # we assume that this directory already exists
    LOG_DIR="/var/scripts/OAU_Bash_Terraform_Logging_Users_Actions/logs"
fi

# Different output files in case of action ($1)
if [[ "$1" == "plan" ]]; then
    # set log file path
    LOG_FILE="$LOG_DIR/logs-plan-$(date +%Y-%m)"
    # start-line of log
    echo "$(date "+%Y-%m-%d %H:%M:%S") - USER $(logname) EXECUTED COMMAND: \"$0 $@\" at path \"$(pwd)\". Output is:" >> "$LOG_FILE"
    # perform command, redirect stdout and stderr to terminal and file at once
    "$ORIGINAL_TERRAFORM_PATH" $@ 2>&1 | tee -a >(sed $'s/\033[[][^A-Za-z]*m//g' >> "$LOG_FILE");
    # save terraform exit code
    TerraformExitCode=${PIPESTATUS[0]}
    # end-line log
    echo "$(date "+%Y-%m-%d %H:%M:%S") - COMMAND HAS BEEN ENDED WITH THE EXIT CODE: $TerraformExitCode" >> "$LOG_FILE"
    echo "-----------------------------------------------------------------------------------------------------------" >> "$LOG_FILE"
    # exit script with original exit code
    exit $TerraformExitCode
    
elif [[ "$1" == "apply" ]]; then
    LOG_FILE="$LOG_DIR/logs-apply-$(date +%Y-%m)"
    
    echo "$(date "+%Y-%m-%d %H:%M:%S") - USER $(logname) EXECUTED COMMAND: \"$0 $@\" at path \"$(pwd)\". Output is:" >> "$LOG_FILE"
    
    "$ORIGINAL_TERRAFORM_PATH" $@ 2>&1 | tee -a >(sed $'s/\033[[][^A-Za-z]*m//g' >> "$LOG_FILE"); 
    TerraformExitCode=${PIPESTATUS[0]}

    echo "$(date "+%Y-%m-%d %H:%M:%S") - COMMAND HAS BEEN ENDED WITH THE EXIT CODE: $TerraformExitCode" >> "$LOG_FILE"
    echo "-----------------------------------------------------------------------------------------------------------" >> "$LOG_FILE"
    exit $TerraformExitCode
else
    # if not ("plan" or "apply")
    LOG_FILE="$LOG_DIR/logs-others-$(date +%Y-%m)"
    
    echo "$(date "+%Y-%m-%d %H:%M:%S") - USER $(logname) EXECUTED COMMAND: \"$0 $@\" at path \"$(pwd)\". Output is:" >> "$LOG_FILE"
    
    "$ORIGINAL_TERRAFORM_PATH" $@ 2>&1 | tee -a >(sed $'s/\033[[][^A-Za-z]*m//g' >> "$LOG_FILE"); 
    TerraformExitCode=${PIPESTATUS[0]}

    echo "$(date "+%Y-%m-%d %H:%M:%S") - COMMAND HAS BEEN ENDED WITH THE EXIT CODE: $TerraformExitCode" >> "$LOG_FILE"
    echo "-----------------------------------------------------------------------------------------------------------" >> "$LOG_FILE"
    exit $TerraformExitCode
fi

exit $TerraformExitCode