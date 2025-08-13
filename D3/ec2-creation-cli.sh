#!/bin/bash

SUBNET_ID=$(aws ec2 describe-subnets \
  --filters "Name=tag:Name,Values=32-sub1" \
  --query "Subnets[0].SubnetId" \
  --output text)

SG_ID=$(aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=32-SSH-ICMP" \
  --query "SecurityGroups[0].GroupId" \
  --output text)

aws ec2 run-instances \
  --image-id ami-0169aa51f6faf20d5 \
  --count 1 \
  --instance-type t3.micro \
  --key-name skv_key1 \
  --subnet-id $SUBNET_ID \
  --security-group-ids $SG_ID \
  --associate-public-ip-address \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=32-vm02}]'