var AWSCognito = require('amazon-cognito-identity-js');
//var CognitoUserPool = AmazonCognitoIdentity.CognitoUserPool;

    var poolData = {
        UserPoolId : 'us-west-2_vgFmxBLLV',
        ClientId : '7vo64go5vvknokfrmlcnpf5eah'
	};

    var userPool = new AWSCognito.CognitoUserPool(poolData);
    var userData = {
        Username : 'milind',
        Pool : userPool
    };

    var cognitoUser = new AWSCognito.CognitoUser(userData);
    cognitoUser.confirmRegistration('404726', true, function(err, result) {
        if (err) {
            console.log(err);
            return;
        }
        console.log('call result: ' + result);
    });
