'use strict';

const uuid = require('uuid');
const AWS = require('aws-sdk');
const dynamoDB = new AWS.DynamoDB.DocumentClient();
const low = 0;
const high = 1;

const jsonResponse = JSON.parse('{"couponName":"eBay","couponDesc":"Shop for 5000 and above & Get Free Prepaid Mobile Recharge Worth Rs. 500","couponCode":"EBAY500","couponExpiry":"Valid till 31st Dec 2007"}');

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
			let couponRandom = Math.floor(Math.random() * (high - low + 1) + low);
			let response;
			if(couponRandom === 0)
			{
                        	response={
                                	statusCode: 200,
                                	body: JSON.parse(JSON.stringify({couponName:jsonResponse.couponName,couponDesc:jsonResponse.couponDesc,couponCode:jsonResponse.couponCode,couponExpiry:jsonResponse.couponExpiry}))
                        		};
			} else {
                                response={
                                        statusCode: 201,
                                        body: JSON.parse(JSON.stringify({couponName:"",couponDesc:"",couponCode:"",couponExpiry:""}))
                                        };
			}
			
			callback(null,response);
                }
        });
};
