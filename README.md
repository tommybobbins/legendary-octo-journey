# legendary-octo-journey
Playground for Lambda function generated signed URLs

````
tofu init
tofu plan
tofu apply
````

# Output

````
curl -I 'https://boo1234567889abcdefgh.lambda-url.eu-west-2.on.aws?bucket_name=legendary-octo-journey-dev20240921123456789abcv&object_name=foo&expiration=3600'
HTTP/1.1 200 OK
Date: Sat, 21 Sep 2024 12:46:18 GMT
Content-Type: application/json
Content-Length: 0
Connection: keep-alive
x-amzn-RequestId: c89504b6-27ce-4499-93d3-b6d4ebc2e5ec
X-Amzn-Trace-Id: root=1-66eec018-49c19563385db0d3746e5bc5;parent=71e388447f2f8743;sampled=0;lineage=1:7274b283:0



$ curl 'https://boo7123456789.lambda-url.eu-west-2.on.aws?bucket_name=legendary-octo-journey-dev20240921123456789&object_name=bobbins_was_here.txt&expiration=3600'
curl -X POST -F key='bobbins_was_here.txt' -F x-amz-algorithm='AWS4-HMAC-SHA256' -F x-amz-credential='ASIAdeleted' -F x-amz-date='20240921T142611Z' -F x-amz-security-token='
````

Run the curl above and the file is uploaded

https://stackoverflow.com/questions/36344194/pre-signed-url-for-multiple-files

````
    response = s3.generate_presigned_post(
        "BUCKET_NAME",
        "uploads/${filename}",
        Fields=None,
        Conditions=[["starts-with", "$key", "uploads/"]],
        ExpiresIn=(10 * 60),
    )
````

## Option 2 - trusted bucket referencing other accounts 

See bucket trusty in s3.tf

````
$ aws s3 ls s3://legendary-octo-journey-dev-trusty20240922123456789  

An error occurred (AccessDenied) when calling the ListObjectsV2 operation: Access Denied
$ aws s3 cp README.md s3://legendary-octo-journey-dev-trusty20240922123456789/README.md
upload: ./README.md to s3://legendary-octo-journey-dev-trusty20240922123456789/README.md
````
