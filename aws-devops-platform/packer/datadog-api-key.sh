#!/bin/bash
# Fetch password from LastPass and output as JSON
password=$(lpass show --password "Datadog-api")
echo "$password"