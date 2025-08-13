## **1️⃣ Policy Simulator Workflow Diagram**

**Title:** *IAM Policy Simulator – How it Works*

**Flow:**

```
[User/Developer]
      |
      v
[Select IAM Entity (User/Group/Role)]
      |
      v
[Choose AWS Service + Action]
      |
      v
[Policy Simulator Engine]
      |
      +--> Reads IAM Policies (inline + managed)
      +--> Reads Resource Policies
      +--> Reads SCPs (if in Org)
      |
      v
[Evaluation Result: ALLOW / DENY + Reason]
```

**Visual Icons:**

* AWS IAM icon for entity
* AWS Policy icon for policies
* AWS Services icons (e.g., S3, EC2)
* Green “ALLOW” check and Red “DENY” cross

---

## **2️⃣ STS Cross-Account Role Assumption Diagram**

**Title:** *Cross-Account Access with AWS STS*

**Flow:**

```
[Account B: User/Developer] 
      |
      | 1. aws sts assume-role
      v
[STS Service]
      |
      | 2. Validates Trust Policy
      v
[Account A: IAM Role (with Permission Policy)]
      |
      | 3. Issues Temporary Credentials
      v
[Account B: User uses Temp Credentials]
      |
      v
[Access Account A's Resource (e.g., S3 Bucket)]
```

**Visual Icons:**

* AWS IAM Role icon in Account A
* AWS User icon in Account B
* AWS STS icon between them
* AWS S3 icon for target resource
* Arrow labels: “Assume Role”, “Temporary Credentials”, “Access Resource”

