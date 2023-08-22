import json
import boto3
import os

def lambda_handler(event, context):
    
    # Input Validation
    
    try:
        firstNumber = float(event['queryStringParameters']['firstNumber'])
        secondNumber = float(event['queryStringParameters']['secondNumber'])
        
    except :
        return { 
                'statusCode': 200,
                'body': "Wrong input, Parameters should be with firstNumber and secondNumber keys and numbers only"
            }
    
    # Calculate Sum
    
    result = "The sum of the numbers is " + str(firstNumber + secondNumber);
    
    # Send SNS Event
    
    client = boto3.client("sns")
    snsTopicArn = os.environ['snsTopicArn']
    
    client.publish(
        TopicArn = snsTopicArn, 
        Message = result
    );
    
    return {
        'statusCode': 200,
        'body': result
    }