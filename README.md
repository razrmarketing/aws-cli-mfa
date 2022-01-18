# aws-cli-mfa
This package provides a utility to make using multi-factor authentication
easier with the [aws-cli](https://github.com/aws/aws-cli).

## Prerequisites
This package depends on [aws-cli](https://github.com/aws/aws-cli) and 
[jq](https://github.com/stedolan/jq).

## Compatibility
This should be compatible with phone authenticator apps as well as physical
security keys. It has been tested with Google Authenticator and
a Yubikey 5C.

## Installation
MacOS: Install using [homebrew](https://brew.sh/)
```shell
$ brew tap razrmarketing/aws-cli-mfa git@github.com:razrmarketing/aws-cli-mfa.git
$ brew install aws-cli-mfa
```

Manual installation: Install the prerequisites, place the `aws-mfa.sh` 
script somewhere in your `PATH` and mark it as executable.

## Before Use
Before you can use this tool you must configure your aws-cli with a default
profile. You can simply follow the [AWS Quick configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
guide.

## Usage
Simply run the `aws-mfa` command. It will pull the first MFA device on your
user profile and ask for an MFA code. Provide the code from your authenticator
app, or touch/press the button on your security key.
```shell
$ aws-mfa
Using MFA device: arn:aws:iam::111111111111:mfa/username
Enter MFA code: ******
Getting session token
Configuring credentials for profile mfa

Done.
```

Ths first time, this will create a new AWS profile in your `~/.aws/credentials`
file named `mfa`. When your session expires (12 hours by default) you can
run the command again and the profile will be updated.

## Options
```shell
aws-mfa
[--duration-seconds <value>]
[--serial-number <value>]
[--profile <value>]
```

`--duration-seconds` (integer)
> The duration, in seconds, your session lasts. See [AWS Documentation](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sts/get-session-token.html#options).

`--serial-number` (string)
> The MFA device serial number or ARN. See [AWS Documentation](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sts/get-session-token.html#options).

`--profile` (string)
> The name of the AWS profile you want to use. Defaults to `mfa`.

## Usage with multiple profiles
If you have multiple profiles set up in order to use different roles, etc,
you should update your `~/.aws/config` to specify `mfa` as the `source_profile`
for any profile the requires MFA.
