import datetime
def lambda_handler(event, context):
    print(f"Hello world. Current Time is {datetime.datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')}")

