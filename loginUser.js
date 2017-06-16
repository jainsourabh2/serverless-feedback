'use strict';

const AWSCognito = require('amazon-cognito-identity-js');

module.exports.createUser = (event, context, callback) => {

        let body;
        try{
                body = JSON.parse(event.body);
        }catch(ex){
                body = event.body;
        }

        let email = body.email;
        let mobile = body.mobile;
        let username = body.username;
        let password = body.password;

    	let poolData = {
        	UserPoolId : process.env.USER_POOL_ID,
        	ClientId : process.env.CLIENT_ID
    	};

	let userPool = new AWSCognito.CognitoUserPool(poolData);
	let attributeList = [];

    	let dataEmail = {
        	Name : 'email',
        	Value : email
    	};
 
    	let dataPhoneNumber = {
        	Name : 'phone_number',
        	Value : mobile
    	};

    	let attributeEmail = new AWSCognito.CognitoUserAttribute(dataEmail);
    	let attributePhoneNumber = new AWSCognito.CognitoUserAttribute(dataPhoneNumber);
    	attributeList.push(attributeEmail);
    	attributeList.push(attributePhoneNumber);
	
    	userPool.signUp(username, password, attributeList, null, function(err, result){
        	if (err) {
            		console.log(err);
            		return;
        	}
  		
		const response = {
    			statusCode: 200,
    			body: JSON.stringify({
      				message: 'User Created. User Validation Pending!',
				statusCode: 200
    			}),
  		};

  		callback(null, response);

	});

  // Use this code if you don't use the http event with the LAMBDA-PROXY integration
  //   //   // callback(null, { message: 'Go Serverless v1.0! Your function executed successfully!', event });
};

module.exports.authenticateUser = (event, context, callback) => {

        let body;
        try{
                body = JSON.parse(event.body);
        }catch(ex){
                body = event.body;
        }

        let username = body.username;
        let password = body.password;

    	let poolData = {
            UserPoolId : process.env.USER_POOL_ID,
            ClientId : process.env.CLIENT_ID
	};

 	let authenticationData = {
        	Username : username,
        	Password : password,
    	};

 	let authenticationDetails = new AWSCognito.AuthenticationDetails(authenticationData);

	let userPool = new AWSCognito.CognitoUserPool(poolData);

	let userData = {
        	Username : username,
        	Pool : userPool
    	};

	let cognitoUser = new AWSCognito.CognitoUser(userData);
	
	cognitoUser.authenticateUser(authenticationDetails, {
        	onSuccess: function (result) {
                	const response = {
                        	statusCode: 200,
                        	body: JSON.stringify({
                                	authorization: result.getIdToken().getJwtToken(),
					statusCode: 200
                        	}),
                	};
                	callback(null, response);
		}
	});

};

module.exports.confirmUser = (event, context, callback) => {

        let body;
        try{
                body = JSON.parse(event.body);
        }catch(ex){
                body = event.body;
        }

        let username = body.username;
        let code = body.code;

    	var poolData = {
        	UserPoolId : process.env.USER_POOL_ID,
        	ClientId : process.env.CLIENT_ID
	};

    	var userPool = new AWSCognito.CognitoUserPool(poolData);
    	var userData = {
        	Username : username,
        	Pool : userPool
    	};

    	var cognitoUser = new AWSCognito.CognitoUser(userData);
    	cognitoUser.confirmRegistration(code, true, function(err, result) {
        	if (err) {
            		console.log(err);
            		return;
        	}

                const response = {
                	statusCode: 200,
                        body: JSON.stringify({
                        	message: 'User Confirmed!!',
				statusCode: 200
                        }),
                };
		callback(null, response);
    	});
	
};

module.exports.resendConfirmation = (event, context, callback) => {

        let body;
        try{
                body = JSON.parse(event.body);
        }catch(ex){
                body = event.body;
        }

	let username = body.username;

        let poolData = {
                UserPoolId : process.env.USER_POOL_ID,
                ClientId : process.env.CLIENT_ID
        };

	let userPool = new AWSCognito.CognitoUserPool(poolData);

	let userData = {
        	Username : username,
        	Pool : userPool
    	};

	let cognitoUser = new AWSCognito.CognitoUser(userData);

    	cognitoUser.resendConfirmationCode(function(err, result) {
        	if (err) {
            		console.log(err);
            		return;
        	}

                const response = {
                        statusCode: 200,
                        body: JSON.stringify({
                                message: 'ReConfirmation Code Sent',
				statusCode: 200
                        })
                };
                callback(null, response);
    	});
};

module.exports.deleteUser = (event, context, callback) => {

        let body;
        try{
                body = JSON.parse(event.body);
        }catch(ex){
                body = event.body;
        }

        let username = body.username;
	let password = body.password;

        let poolData = {
                UserPoolId : process.env.USER_POOL_ID,
                ClientId : process.env.CLIENT_ID
        };

 	let authenticationData = {
        	Username : username,
        	Password : password
    	};

	let authenticationDetails = new AWSCognito.AuthenticationDetails(authenticationData);

        let userPool = new AWSCognito.CognitoUserPool(poolData);

        let userData = {
                Username : username,
                Pool : userPool
        };

        let cognitoUser = new AWSCognito.CognitoUser(userData);

	cognitoUser.authenticateUser(authenticationDetails, {
        	onSuccess: function (result) {
        		cognitoUser.deleteUser(function(err, result) {
                		if (err) {
                        		console.log(err);
                        		return;
                		}
                		const response = {
                        		statusCode: 200,
                        		body: JSON.stringify({
                                		message: 'User deleted.',
						statusCode: 200
                        		})
                		};
                		callback(null, response);
        		});
		}
	});
};
