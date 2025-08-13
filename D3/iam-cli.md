## IAM CLI commands 

* print vpcid, cidr and name on cli 
```
aws ec2 describe-vpcs --query "Vpcs[*].{ID:VpcId, Name:Tags[?Key=='Name']|[0].Value, CIDR:CidrBlock}" --output table
```