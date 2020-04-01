#!/bin/bash

export AWS_ROLE_ARN="arn:aws:iam::214219211678:role/TerraformAWSEKSTests"
export SKIP_cleanup_terraform=true

.github/actions/terratest/entrypoint.sh -run "${@:-TestTerraformAwsEksCluster}"
