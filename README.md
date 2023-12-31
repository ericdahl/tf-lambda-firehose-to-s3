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

### Logs after Transformation

```
zcat tmp-s3/logs/lambda/tf-lambda-firehose-to-s3-hello/2023/12/31/18/tf-lambda-firehose-to-s3-3-2023-12-31-18-43-24-31f965fd-de35-4eaa-98fb-8035e8998e41.gz
{"tag_name": "tf-lambda-firehose-to-s3", "time": "2023-12-31 18:43:14 UTC", "log": "[d3c7f1fa-1d4c-43da-8f4c-eed6633131f3] Hello world. Current Time is 2023-12-31 18:43:14\n"}
{"tag_name": "tf-lambda-firehose-to-s3", "time": "2023-12-31 18:44:14 UTC", "log": "[6a3a1eda-0eb9-4511-a66b-286ccfbcff5a] Hello world. Current Time is 2023-12-31 18:44:14\n"}

```

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