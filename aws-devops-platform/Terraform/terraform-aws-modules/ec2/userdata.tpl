#!/bin/bash
set -euo pipefail

# Install CloudWatch agent if not present
if ! command -v /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl >/dev/null 2>&1; then
  yum install -y amazon-cloudwatch-agent || dnf install -y amazon-cloudwatch-agent || true
fi

# Write CloudWatch agent config
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<CFG
{
  "agent": {
    "region": "${REGION}",
    "metrics_collection_interval": 60,
    "logfile": "/var/log/amazon-cloudwatch-agent.log"
  },
  "metrics": {
    "append_dimensions": { "InstanceId": "$${aws:InstanceId}" },
    "metrics_collected": {
      "mem": { "measurement": ["mem_used_percent"], "metrics_collection_interval": 60 },
      "cpu": { "measurement": ["cpu_usage_idle","cpu_usage_iowait"], "metrics_collection_interval": 60 }
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "${LOG_GROUP_SYSTEM}",
            "log_stream_name": "$${instance_id}/messages",
            "timestamp_format": "%b %d %H:%M:%S"
          },
          {
            "file_path": "/var/log/cloud-init.log",
            "log_group_name": "${LOG_GROUP_SYSTEM}",
            "log_stream_name": "$${instance_id}/cloud-init",
            "timestamp_format": "%Y-%m-%dT%H:%M:%S"
          }
        ]
      }
    }
  }
}
CFG

# Start CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
