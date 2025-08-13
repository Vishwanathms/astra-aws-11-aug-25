## IAM CLI commands 

* print vpcid, cidr and name on cli 
```
aws ec2 describe-vpcs --query "Vpcs[*].{ID:VpcId, Name:Tags[?Key=='Name']|[0].Value, CIDR:CidrBlock}" --output table
```

* pring subnet ID for a specific vpc-id
```
aws ec2 describe-subnets --filters "Name=vpc-id,Values=<vpc-id>" --query "Subnets[*].{Name:Tags[?Key=='Name']|[0].Value, ID:SubnetId, CIDR:CidrBlock, AZ:AvailabilityZone}"   --output table
```

* Create subnet for a vpc 
Note: -- Replace <VPC-ID> to your vpc id, and also change the CIDR block accordingly 
```
aws ec2 create-subnet --vpc-id <VPC-ID> --cidr-block 192.168.2.0/24 --availability-zone us-east-1c --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=32-sub03},{Key=Owner,Value=vishwa},{Key=Env,Value=Dev}]'
```