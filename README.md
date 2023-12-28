# tf-lambda-firehose-to-s3

Demo app showing config to push Lambda logs to S3

1. Lambda
2. CloudWatch Logs
3. CloudWatch Logs - Subscription Filter
4. Kinesis Firehose Delivery Stream
5. S3 bucket


## TODO

- fix perm issue with transform lambda
```
"errorCode":"Lambda.InvokeAccessDenied","errorMessage":"Access was denied. Ensure that the access policy allows access to the Lambda function."
```

## Notes

### Raw logs without Transformation

```
$ zless 2023/12/28/17/tf-lambda-firehose-to-s3-1-2023-12-28-17-28-04-fa9ee534-7fa0-4ac9-a4c3-44da5692e8f6 | jq

...
{
  "messageType": "DATA_MESSAGE",
  "owner": "669361545709",
  "logGroup": "/aws/lambda/tf-lambda-firehose-to-s3",
  "logStream": "2023/12/28/[$LATEST]44af24c678394bc88dd0144c96ff4dda",
  "subscriptionFilters": [
    "tf-lambda-firehose-to-s3"
  ],
  "logEvents": [
    {
      "id": "37995668886194617371310200156999564750827854672241033216",
      "timestamp": 1703784718759,
      "message": "START RequestId: d3cf1623-9722-4eca-b586-1bdb53bbab17 Version: $LATEST\n"
    },
    {
      "id": "37995668886194617371310200156999564750827854672241033217",
      "timestamp": 1703784718759,
      "message": "Hello world. Current Time is 2023-12-28 17:31:58\n"
    },
    {
      "id": "37995668886216918116508730780141100469100503033747013634",
      "timestamp": 1703784718760,
      "message": "END RequestId: d3cf1623-9722-4eca-b586-1bdb53bbab17\n"
    },
    {
      "id": "37995668886216918116508730780141100469100503033747013635",
      "timestamp": 1703784718760,
      "message": "REPORT RequestId: d3cf1623-9722-4eca-b586-1bdb53bbab17\tDuration: 1.12 ms\tBilled Duration: 2 ms\tMemory Size: 128 MB\tMax Memory Used: 39 MB\t\n"
    }
  ]
}
```