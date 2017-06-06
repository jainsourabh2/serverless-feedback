var AWSCognito = require('amazon-cognito-identity-js');

    	var poolData = {
            UserPoolId : 'us-west-2_vgFmxBLLV',
            ClientId : '7vo64go5vvknokfrmlcnpf5eah'
	};

 	var authenticationData = {
        	Username : 'milind',
        	Password : 'Sourabh007#',
    	};

 	var authenticationDetails = new AWSCognito.AuthenticationDetails(authenticationData);

	var userPool = new AWSCognito.CognitoUserPool(poolData);
    	
	var userData = {
        	Username : 'milind',
        	Pool : userPool
    	};

	var cognitoUser = new AWSCognito.CognitoUser(userData);
    	console.log("cognitoUser");	
	cognitoUser.authenticateUser(authenticationDetails, {
        	onSuccess: function (result) {
            	//	console.log('access token + ' + result.getAccessToken().getJwtToken());
			console.log('id token + ' + result.getIdToken().getJwtToken());
		}
	});
