#!/bin/bash
serial_number=${AWS_MFA_DEVICE}
session_duration=43200
profile=mfa

function show_help {
  echo "Usage: ${0}\n\t[--duration-seconds <value>]\n\t[--device <value>]\n\t[--profile <value>]"
}

# Parse arguments
ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    --serial-number)
      serial_number="$2"
      shift
      shift
      ;;
    --duration-seconds)
      session_duration="$2"
      shift
      shift
      ;;
    --profile)
      profile="$2"
      shift
      shift
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    -*|--*)
      echo "Unknown option $1"
      show_help
      exit 1
      ;;
    *)
      ARGS+=("$1")
      shift
      ;;
  esac
done
set -- "${ARGS[@]}"

if [[ -z ${serial_number} ]]
then
    serial_number=$(aws iam list-mfa-devices --max-items 1 --output json --profile default | jq -r ".MFADevices | .[0] | .SerialNumber")
fi

echo "Using MFA device: ${serial_number}"

read -s -p "Enter MFA code: " code
echo ""
if [[ -z ${code} ]]
then
  echo "No MFA code provided. Exiting." >&2
  exit 1
fi

echo "Getting session token"
JSON=$(aws sts get-session-token --serial-number ${serial_number} --token-code ${code} --output json --profile default --duration-seconds ${session_duration})

if [[ ${?} != 0 ]]
then
  echo "Exiting." >&2
  exit 2
fi

access_key_id=$(echo $JSON | jq -r .Credentials.AccessKeyId)
secret_access_key=$(echo $JSON | jq -r .Credentials.SecretAccessKey)
session_token=$(echo $JSON | jq -r .Credentials.SessionToken)

echo "Configuring credentials for profile ${profile}"
aws configure set aws_access_key_id ${access_key_id} --profile ${profile}
aws configure set aws_secret_access_key ${secret_access_key} --profile ${profile}
aws configure set aws_session_token ${session_token} --profile ${profile}

echo ""
echo "Done."
