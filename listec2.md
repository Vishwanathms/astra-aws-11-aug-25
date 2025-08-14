```
#!/bin/bash

# List of AWS regions to query
regions=("us-east-2" "us-west-1" "eu-central-1" "us-west-2" "ca-central-1" "ap-southeast-1")

# Loop through each region
for region in "${regions[@]}"; do
    echo "===== $region ====="
    
    aws ec2 describe-instances \
        --region "$region" \
        --query "Reservations[].Instances[].{
            Name: Tags[?Key=='Name']|[0].Value,
            ID: InstanceId,
            PublicIP: PublicIpAddress,
            PrivateIP: PrivateIpAddress,
            Region: '$region'
        }" \
        --output table
done
```

```
#!/bin/bash

regions=("us-east-2" "us-west-1" "eu-central-1" "us-west-2" "ca-central-1" "ap-southeast-1")

for region in "${regions[@]}"; do
    echo "===== Region: $region ====="
    
    # Fetch all RDS instances with their status
    aws rds describe-db-instances \
        --region "$region" \
        --query "DBInstances[*].[DBInstanceIdentifier,DBInstanceStatus]" \
        --output table
done
```

```

aws rds delete-db-instance \
    --db-instance-identifier <db-name> \
    --region us-west-1 \
    --skip-final-snapshot
```


