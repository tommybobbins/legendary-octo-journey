import logging
import boto3
import json
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def create_presigned_url(event, context):

    logger.info("Inside create_presigned_url")

    print('event', json.dumps(event))
    #print('queryStringParameters:', json.dumps(event['queryStringParameters']))

    bucket_name =  event['queryStringParameters']['bucket_name']
    object_name =  event['queryStringParameters']['object_name']
    expiration  =  int(event['queryStringParameters']['expiration'])

    print(f"Bucket name = {bucket_name} ")
    print(f"Object name = {object_name} ")
    print(f"Expiration = {expiration} ")

    # Generate a presigned URL for the S3 object
    s3_client = boto3.client('s3')
    try:
        response = s3_client.generate_presigned_post(Bucket=bucket_name,
                                                     Key=object_name,
                                                     ExpiresIn=expiration)

        # for curl, use this
        print(" ".join(f"-F {k}='{v}'" for (k, v) in response["fields"].items()))
        logline = 'curl -X POST '
        logline += (" ".join(f"-F {k}='{v}'" for (k, v) in response["fields"].items()))
        logline += (' -F file=@README.md \'' + str(response["url"]) + '\'')
        print (logline)
        logger.info(logline)

        # confirm the URL
        print(response["url"])                                                 


    except ClientError as e:
        logging.error(e)
        return None

    # The response contains the presigned URL
    return logline

