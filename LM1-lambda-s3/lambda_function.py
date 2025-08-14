import json

def lambda_handler(event, context):
    print("Event:", json.dumps(event))
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    print(f"New file uploaded: s3://{bucket}/{key}")
    return {
        'statusCode': 200,
        'body': f"Processed file {key} from bucket {bucket}"
    }
