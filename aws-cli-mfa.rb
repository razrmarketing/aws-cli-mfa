class AwsCliMfa < Formula
  desc "Utility to use multi-factor authentication with the aws-cli"
  homepage "https://github.com/razrmarketing/aws-cli-mfa"

  url "git@github.com:razrmarketing/aws-cli-mfa.git", :using => :git
  version "0.1"

  depends_on "awscli"
  depends_on "jq"

  def install
    bin.install "aws-cli-mfa.sh" => "aws-mfa"
  end
end
