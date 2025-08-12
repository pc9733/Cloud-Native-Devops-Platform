#!/bin/bash
# Fetch password from LastPass and output as JSON
password=$(lpass show --password "rds_password")
echo "{\"password\":\"$password\"}"

