import datetime
def lambda_handler(event, context):
    print(f"[{context.aws_request_id}] Hello world. Current Time is {datetime.datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')}")

