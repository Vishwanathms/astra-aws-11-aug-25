## Step 1 — Create the S3 Bucket
```
aws s3 mb s3://32vishwa140825

```

## step 2- Create the role:
```
aws iam create-role \
  --role-name LambdaS3ExecutionRole \
  --assume-role-policy-document file://trust-policy.json
```

## Step 3 - Attach permissions:
```
aws iam attach-role-policy \
  --role-name LambdaS3ExecutionRole \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

aws iam attach-role-policy \
  --role-name LambdaS3ExecutionRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
```

## Step 4: Package and deploy:
```
zip function.zip lambda_function.py
aws lambda create-function \
  --function-name S3UploadTrigger \
  --runtime python3.9 \
  --role arn:aws:iam::<ACCOUNT_ID>:role/LambdaS3ExecutionRole \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://function.zip
```

## Step 5: — Give S3 Permission to Invoke Lambda
```
aws lambda add-permission \
  --function-name S3UploadTrigger \
  --principal s3.amazonaws.com \
  --statement-id s3invoke \
  --action "lambda:InvokeFunction" \
  --source-arn arn:aws:s3:::my-upload-trigger-bucket-2025
```

## Step 6 — Add the Event Notification to S3
```
aws s3api put-bucket-notification-configuration \
  --bucket my-upload-trigger-bucket-2025 \
  --notification-configuration '{
    "LambdaFunctionConfigurations": [
      {
        "LambdaFunctionArn": "arn:aws:lambda:<REGION>:<ACCOUNT_ID>:function:S3UploadTrigger",
        "Events": ["s3:ObjectCreated:*"]
      }
    ]
  }'
```
