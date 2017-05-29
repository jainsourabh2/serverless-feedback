'use strict';

const AWS = require('aws-sdk');
const sns = new AWS.SNS();

module.exports.pushCommit = (event, context, callback) => {

	const SNSinfo = {
			Message: "User has committed to github",
			TopicArn: "arn:aws:sns:us-west-2:679279306327:" + process.env.SNS_TOPIC_NAME
		};

	sns.publish(SNSinfo,(error) => {
		if(error){
			console.log("error occured : " + error);
		}
	});

  	const response = {
    		statusCode: 200,
    		body: JSON.stringify({
      			input: event,
    		}),
  	};

  	callback(null, response);

  // Use this code if you don't use the http event with the LAMBDA-PROXY integration
  //   // callback(null, { message: 'Go Serverless v1.0! Your function executed successfully!', event });
};
