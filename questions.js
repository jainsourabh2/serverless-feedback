'use strict';

const AWS = require('aws-sdk');
const dynamoDB = new AWS.DynamoDB.DocumentClient();
const sns = new AWS.SNS();
const ses = new AWS.SES();

module.exports.fetchquestions = (event, context, callback) => {

	let placeid;

	if(typeof event.queryStringParameters == 'undefined'){
		placeid = 'dd328a1e5a3392cad0a93f3657e696ecd56c93ab';		
	}else{
		placeid = event.queryStringParameters.placeid;
	}
	
	const params = {
		TableName: process.env.DYNAMODB_QUESTIONS_TABLE,
		Key: {
			placeid: placeid
		}
	};
	
	const defaultParams = {
		TableName: process.env.DYNAMODB_QUESTIONS_TABLE,
		Key: {
			placeid: 'dd328a1e5a3392cad0a93f3657e696ecd56c93ab',
		}
	}	

	const SNSinfo = {
		Message: "Thanks for registering to SpeakIt!!",
		TopicArn: "arn:aws:sns:us-west-2:679279306327:" + process.env.SNS_TOPIC_NAME
	}

//        const SNSinfo = {
//                Message: "Thanks for registering to SpeakIt!!",
//                PhoneNumber: '+918767208564'
//        }

	const emailParams = {
		Destination: {
			ToAddresses: ["jainsourabh2@gmail.com","sourabh.jain@mastek.com"]
		},
		Message: {
			Body: {
				Text: {
					Data: "Welcome to SES"
				}
			},
			Subject: {
				Data: "Welcome"
			}
		},
		ReplyToAddresses: ["jainsourabh2@gmail.com"],
		Source: "jainsourabh2@gmail.com"
	}
	
	dynamoDB.get(params, (error,result) => {
		if(error){
			callback(null,error);
		}
		else{
			if(typeof result.Item == 'undefined'){
				dynamoDB.get(defaultParams, (error,defaultResult) => {
			                if(error){
                        			callback(null,error);
                			} else {
						let response = {
							statusCode: 200,
							body: JSON.parse(JSON.stringify(defaultResult.Item.questions))
						};
						callback(null,response);		
					}

				});

                                //const response={
                                //        statusCode: 502,
                                //        body: JSON.stringify({message:"Place not configured"}),
                                //};
                                //callback(null,response);				
			}else{
        			let response={
                			statusCode: 200,
                			body: JSON.parse(JSON.stringify(result.Item.questions))
        			};

				//sns.publish(SNSinfo,(error) => {
				//	if(error){
				//		console.log("error occured : " + error);
				//	}
				//});

				//ses.sendEmail(emailParams, function (err, data) {
      				//	if (err) {
          			//		console.log(err, err.stack);
          			//		callback(err);
      				//	}
  				//});


				callback(null,response);
			}
		}
	});
};

module.exports.postquestion = (event, context, callback) => {
	let body = JSON.parse(event.body);
	let data = body.questions;
	let placeid = body.placeid;
        const params = {
                TableName: process.env.DYNAMODB_QUESTIONS_TABLE,
		Item: {
		  placeid: placeid,
		  questions: JSON.stringify(data)
		}
        };

        dynamoDB.put(params, (error) => {
                if(error){
                        callback(null,error);
                }
                else{
                        const response={
                                statusCode: 200,
                                body: JSON.stringify({message:"Successfully Inserted",statusCode: 200})
                        };
			console.log(response);
                        callback(null,response);
                }
        });
};
