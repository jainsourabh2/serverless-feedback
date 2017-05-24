'use strict';

const uuid = require('uuid');
const AWS = require('aws-sdk');
const dynamoDB = new AWS.DynamoDB.DocumentClient();

module.exports.postfeedback = (event, context, callback) => {
	var body;
	const timestamp = new Date().getTime();
	try{
		body = JSON.parse(event.body);
	}catch(ex){
		console.error(ex);
		body = event.body;
	}
	let data = body.feedback;
	let questions = body.questions;
	let placeid = body.placeid;
	let userid = body.userid;
        const params = {
                TableName: process.env.DYNAMODB_FEEDBACK_TABLE,
		Item: {
		  id: uuid.v1(),
		  userid: userid,
		  placeid: placeid,
		  feedback: JSON.stringify(data),
		  questions: JSON.stringify(questions),
		  datetime: timestamp
		}
        };
        dynamoDB.put(params, (error) => {
                if(error){
                        callback(null,error);
                }
                else{
                        const response={
                                statusCode: 200,
                                body: JSON.parse(JSON.stringify({message:"Successfully Inserted"}))
                        };
                        callback(null,response);
                }
        });
};
