To create an **EC2 instance** using the **AWS CLI**, in a specific **subnet** (`sub1`), with:

* A **key pair** (for SSH access)
* A specific **security group** (by name)
* And using a named **subnet**

You need to follow these steps:

---

## ✅ Required Inputs

| Parameter      | Description                  | Example                 |
| -------------- | ---------------------------- | ----------------------- |
| Subnet name    | Name tag of the subnet       | `sub1`                  |
| Key name       | Existing EC2 key pair        | `my-keypair`            |
| Security group | Existing security group name | `my-sg`                 |
| AMI ID         | Amazon Machine Image ID      | `ami-0abcdef1234567890` |
| Instance type  | EC2 instance type            | `t3.micro`              |

---

## 🧭 Step-by-Step AWS CLI Script

### 🔍 Step 1: Get Subnet ID from Subnet Name

```bash
SUBNET_ID=$(aws ec2 describe-subnets \
  --filters "Name=tag:Name,Values=sub1" \
  --query "Subnets[0].SubnetId" \
  --output text)
```

### 🔍 Step 2: Get Security Group ID from SG Name

```bash
SG_ID=$(aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=my-sg" \
  --query "SecurityGroups[0].GroupId" \
  --output text)
```

### 🚀 Step 3: Launch EC2 Instance

```bash
aws ec2 run-instances \
  --image-id ami-0abcdef1234567890 \
  --count 1 \
  --instance-type t3.micro \
  --key-name my-keypair \
  --subnet-id $SUBNET_ID \
  --security-group-ids $SG_ID \
  --associate-public-ip-address \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=my-ec2-instance}]'
```

---

## 📌 Notes

* **AMI ID** (`ami-0abcdef...`) must be valid in your region. Use this to find one:

  ```bash
  aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" --query "Images[0].ImageId" --output text
  ```
* Ensure your **key pair** exists:

  ```bash
  aws ec2 describe-key-pairs --query "KeyPairs[*].KeyName"
  ```
