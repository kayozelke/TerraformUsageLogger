# Terraform Usage Logger Script

This Bash script tracks which Linux system users have executed the Terraform application, logging their activity and exit codes for auditing purposes. The script supports logging for multiple infrastructure paths and distinguishes between different Terraform commands (`plan`, `apply`, and others). 

## Features

- **User Activity Logging**: Records the execution of Terraform commands, including the user who ran them, the command used, the working directory, and the exit code.
- **Multi-Root-Directory Support**: Works with both general and GCP-specific infrastructure paths, creating log directories as needed.
- **Log Organization**: Maintains separate log files for `plan`, `apply`, and other Terraform commands, organized by month. Log files are put at the directory where command was executed (if not possible, general one is used)
- **Universal logger**: You can eaisly customize this script to make it work with another UNIX shell application

## Setup

1. **Set the Original Terraform Path**: Ensure that `ORIGINAL_TERRAFORM_PATH` in the script points to the correct location of your Terraform binary (e.g., `/bin/terraform`).
2. **Infrastructure Paths**: Update `GENERAL_INFRASTRUCTURE_PATH` and `GCP_INFRASTRUCTURE_PATH` with your specific infrastructure directories.
3. **Log Directory**: The script automatically creates log directories if they do not exist.

## Usage

Run the script as you would normally use Terraform.

```bash
./your_script_name.sh plan
./your_script_name.sh apply
./your_script_name.sh <other_command>
```

You can also move original Terraform binary to another file and put this shell script instead. Works without troubles at medium size company (20-30 people at department).

```bash
terraform plan
terraform apply
terraform <other_command>
```
