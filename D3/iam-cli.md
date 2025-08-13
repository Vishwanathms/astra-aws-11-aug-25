## IAM CLI commands 

* print vpcid, cidr and name on cli 
```
aws ec2 describe-vpcs --query "Vpcs[*].{ID:VpcId, Name:Tags[?Key=='Name']|[0].Value, CIDR:CidrBlock}" --output table
```

* pring subnet ID for a specific vpc-id
```
aws ec2 describe-subnets --filters "Name=vpc-id,Values=<vpc-id>" --query "Subnets[*].{Name:Tags[?Key=='Name']|[0].Value, ID:SubnetId, CIDR:CidrBlock, AZ:AvailabilityZone}"   --output table
```