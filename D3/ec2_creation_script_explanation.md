
# EC2 Instance Creation Script - Explanation

This script automates the process of launching an EC2 instance using AWS CLI.
It dynamically fetches the required **Subnet ID** and **Security Group ID** based on their names.

## **Script**

```bash
#!/bin/bash

# Change the below 
# 1. Subnet value 
# 2. Sg value 
# 3. ec2 image id
# 4. ec2 key_name
# 5. ec2 name value

SUBNET_ID=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=32-sub1" --query "Subnets[0].SubnetId"   --output text)

SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=32-SSH-ICMP" --query "SecurityGroups[0].GroupId"   --output text)

aws ec2 run-instances --image-id ami-0169aa51f6faf20d5 --count 1 --instance-type t3.micro --key-name skv_key1   --subnet-id $SUBNET_ID --security-group-ids $SG_ID --associate-public-ip-address --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=32-vm02}]'
```

---

## **Step-by-Step Explanation**

### **1. Script Shebang**
```bash
#!/bin/bash
```
This indicates that the script should be run using the **Bash shell**.

---

### **2. Script Customization Variables**
```bash
# Change the below 
# 1. Subnet value 
# 2. Sg value 
# 3. ec2 image id
# 4. ec2 key_name
# 5. ec2 name value
```
These comments remind the user about the parts of the script they may need to update before running it.

---

### **3. Fetch Subnet ID**
```bash
SUBNET_ID=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=32-sub1" --query "Subnets[0].SubnetId" --output text)
```
- Uses AWS CLI to retrieve the **Subnet ID** where the instance will be launched.
- The subnet is identified by its **Name tag** (`32-sub1`).
- `--query` extracts only the `SubnetId`.
- `--output text` ensures the result is in plain text (no JSON formatting).

---

### **4. Fetch Security Group ID**
```bash
SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=32-SSH-ICMP" --query "SecurityGroups[0].GroupId" --output text)
```
- Retrieves the **Security Group ID**.
- Security group is identified by its **group-name** (`32-SSH-ICMP`).
- Only the first matching result is used.

---

### **5. Launch EC2 Instance**
```bash
aws ec2 run-instances   --image-id ami-0169aa51f6faf20d5   --count 1   --instance-type t3.micro   --key-name skv_key1   --subnet-id $SUBNET_ID   --security-group-ids $SG_ID   --associate-public-ip-address   --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=32-vm02}]'
```
- **`--image-id`**: Specifies the Amazon Machine Image (AMI) to use.
- **`--count`**: Number of instances to launch (1 in this case).
- **`--instance-type`**: EC2 instance type (`t3.micro`).
- **`--key-name`**: SSH key pair name for secure login.
- **`--subnet-id`**: Uses the `SUBNET_ID` retrieved earlier.
- **`--security-group-ids`**: Uses the `SG_ID` retrieved earlier.
- **`--associate-public-ip-address`**: Ensures the instance gets a public IP.
- **`--tag-specifications`**: Tags the instance with `Name=32-vm02`.

---

## **How to Run**
1. Save the script to a file (e.g., `ec2-create.sh`).
2. Convert it to Unix format if on Windows:
```bash
dos2unix ec2-create.sh
```
3. Make it executable:
```bash
chmod +x ec2-create.sh
```
4. Run it:
```bash
./ec2-create.sh
```

---

## **Notes**
- Ensure AWS CLI is installed and configured with proper IAM permissions (`AmazonEC2FullAccess`).
- Change subnet name, security group name, AMI ID, key pair, and instance name as needed.
- This script is region-specific; ensure the resources exist in the configured AWS CLI region.

