import json
import boto3
from datetime import datetime
from datetime import timedelta

def lambda_handler(event, context):
    client = boto3.client('rds')
    now = datetime.now() - timedelta(days=365)   #change the retention days as needed.
    date = now.strftime("%d-%m-%Y")
    snapshots = client.describe_db_snapshots()
    for i in snapshots['DBSnapshots']:
        S_type = i['SnapshotType']
        S_date= i['SnapshotCreateTime']
        S_date = S_date.strftime("%d-%m-%Y")
        if S_type == "manual":
            if S_date == date:
                ID = i['DBSnapshotIdentifier']
    #            client.delete_db_snapshot( DBSnapshotIdentifier=ID )
                print("We have deleted the {} RDS Snapshot".format(ID))