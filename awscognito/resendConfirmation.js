var AWSCognito = require('amazon-cognito-identity-js');

    	var poolData = {
            UserPoolId : 'us-west-2_vgFmxBLLV',
            ClientId : '7vo64go5vvknokfrmlcnpf5eah'
	};

	var userPool = new AWSCognito.CognitoUserPool(poolData);
    	
	var userData = {
        	Username : 'jainsourabh2',
        	Pool : userPool
    	};

	var cognitoUser = new AWSCognito.CognitoUser(userData);

    	cognitoUser.resendConfirmationCode(function(err, result) {
        	if (err) {
            		console.log(err);
            		return;
        	}
        	console.log('call result: ' + result);
    	});
