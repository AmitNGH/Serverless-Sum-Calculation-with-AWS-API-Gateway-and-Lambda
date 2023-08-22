import json
import boto3

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
    
    client.publish(
        TopicArn = "arn:aws:sns:eu-central-1:331086376726:sendSum", 
        Message = result
    );
    
    return {
        'statusCode': 200,
        'body': json.dumps(result)
    }
