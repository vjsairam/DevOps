Best Practice 

Set the RetentionInDays in CloudFormation stack. 

YAML
Type: AWS::Logs::LogGroup
Properties: 
  KmsKeyId: String
  LogGroupName: String
  RetentionInDays: Integer

RetentionInDays
    The number of days to retain the log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 2192, 2557, 2922, 3288, and 3653.
    To set a log group to never have log events expire, use DeleteRetentionPolicy.
    Required: No
    Type: Integer
    Update requires: No interruption


Ref - https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-logs-loggroup.html