var AWSCognito = require('amazon-cognito-identity-js');
//var CognitoUserPool = AmazonCognitoIdentity.CognitoUserPool;

    var poolData = {
        UserPoolId : 'us-west-2_vgFmxBLLV',
        ClientId : '7vo64go5vvknokfrmlcnpf5eah'
    };

      //var CognitoUserPool = AmazonCognitoIdentity.CognitoUserPool(poolData);	
    var userPool = new AWSCognito.CognitoUserPool(poolData);

var attributeList = [];
 
    var dataEmail = {
        Name : 'email',
        Value : 'milind.vengurlekar@mastek.com'
    };
 
    var dataPhoneNumber = {
        Name : 'phone_number',
        Value : '+918850902827'
    };
    var attributeEmail = new AWSCognito.CognitoUserAttribute(dataEmail);
    var attributePhoneNumber = new AWSCognito.CognitoUserAttribute(dataPhoneNumber);
 
    attributeList.push(attributeEmail);
    attributeList.push(attributePhoneNumber);
 
    userPool.signUp('milind', 'Sourabh007#', attributeList, null, function(err, result){
        if (err) {
            console.log(err);
            return;
        }
        cognitoUser = result.user;
        console.log('user name is ' + cognitoUser.getUsername());
    });
