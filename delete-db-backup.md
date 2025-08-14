```
#!/bin/bash
regions=("us-east-2" "us-west-1" "eu-central-1" "us-west-2" "ca-central-1" "ap-southeast-1")

for region in "${regions[@]}"; do
    echo "=== Cleaning RDS Snapshots & Backups in $region ==="

    snapshots=$(aws rds describe-db-snapshots \
        --region "$region" \
        --query "DBSnapshots[*].DBSnapshotIdentifier" \
        --output text)
    for snap in $snapshots; do
        echo "Deleting snapshot: $snap"
        aws rds delete-db-snapshot \
            --db-snapshot-identifier "$snap" \
            --region "$region"
    done

    backups=$(aws rds describe-db-instance-automated-backups \
        --region "$region" \
        --query "DBInstanceAutomatedBackups[*].DBInstanceAutomatedBackupsArn" \
        --output text)
    for backup in $backups; do
        echo "Deleting automated backup: $backup"
        aws rds delete-db-instance-automated-backup \
            --db-instance-automated-backup-arn "$backup" \
            --region "$region"
    done
done
```
