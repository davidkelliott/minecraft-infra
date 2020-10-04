import boto3
import os
region = 'eu-west-2'
instances = [os.environ['EC2_ID']]
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.start_instances(InstanceIds=instances)
    print('started your instances: ' + str(instances)) 