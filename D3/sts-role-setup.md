
## **Updated: Full Step-by-Step AWS STS Role Creation & Testing**

### **1. Prerequisites**

* AWS CLI installed and configured with a user that has:

  * `iam:CreateRole`, `iam:AttachRolePolicy`, `iam:DeleteRole`, `iam:DetachRolePolicy`
  * The permissions you want to grant via the role
* Account ID of the trusted AWS account (for cross-account)
* An existing AWS resource to test with (e.g., S3 bucket)

---

### **2. Create Trust Policy**

**trust-policy.json**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
```

> Replace `123456789012` with the account that will assume the role.

---

### **3. Create the Role**

```bash
aws iam create-role \
  --role-name MySTSRole \
  --assume-role-policy-document file://trust-policy.json \
  --max-session-duration 3600 \
  --description "Cross-account S3 read role"
```

* `--max-session-duration 3600` means max 1-hour sessions (can be up to 12 hours if needed).

---

### **4. Attach a Policy**

Example: Give read-only access to S3.

```bash
aws iam attach-role-policy \
  --role-name MySTSRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
```

---

### **5. Testing the Role**

#### **5.1. From the Trusted Account (Same or Cross-Account)**

Run:

```bash
aws sts assume-role \
  --role-arn arn:aws:iam::YOUR_ACCOUNT_ID:role/MySTSRole \
  --role-session-name TestSession
```

You’ll get JSON with `AccessKeyId`, `SecretAccessKey`, and `SessionToken`.

---

#### **5.2. Export Temporary Credentials**

```bash
export AWS_ACCESS_KEY_ID="ASIAxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxx"
export AWS_SESSION_TOKEN="xxxxxxxx"
```

---

#### **5.3. Verify Identity**

```bash
aws sts get-caller-identity
```

You should see an ARN starting with:

```
arn:aws:sts::YOUR_ACCOUNT_ID:assumed-role/MySTSRole/TestSession
```

---

#### **5.4. Test Permissions**

For example, list all S3 buckets:

```bash
aws s3 ls
```

* If the role only has `AmazonS3ReadOnlyAccess`, you should be able to **list** but **not modify** S3 objects.

---

### **6. Testing Cross-Account**

1. Log in to the **trusted account** (the one in trust policy).
2. Use its IAM user/role credentials to run the `sts assume-role` command.
3. Export credentials (as above) and run AWS CLI commands.
4. Confirm access matches only what was allowed in the **role policy**.

---

### **7. Cleanup**

```bash
aws iam detach-role-policy \
  --role-name MySTSRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

aws iam delete-role --role-name MySTSRole
```

---

### **8. Best Practices**

* Use **MFA requirement** in trust policy:

```json
"Condition": {
  "Bool": { "aws:MultiFactorAuthPresent": "true" }
}
```

* Limit principals in trust policy (avoid `root` unless needed).
* Set short session durations for sensitive roles.
* Monitor usage via **CloudTrail**.

