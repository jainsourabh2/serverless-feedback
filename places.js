'use strict';

const apiKey 	= 	'AIzaSyBEsHP5d2bf24_vAE46FaTYihBu8JLCibE';
const radius	= 	1000;
const gp	=	require('node-googleplaces');
const request	=	require('request');

module.exports.locationlisting = (event, context, callback) => {
	let lat,lng,type='restaurant';
	//check if the latitude and longitude both are present in the input parametes
	try{
		lat = event.queryStringParameters.lat;
		lng = event.queryStringParameters.lng;
		type = event.queryStringParameters.type;
	}catch(e){
		lat=null;
		lng=null;
	}
	
	//process response only if both the latitude and longitude are present
	if (lat!==null && lng!==null){
		let loc = lat + ',' + lng
		const places = new gp('AIzaSyBEsHP5d2bf24_vAE46FaTYihBu8JLCibE');
		const params = {
  			location: loc,
  			radius: 500,
			type: type,
		};

		places.nearbySearch(params, (err, res) => {
			const response={
				statusCode: 200,
				body: res.text
			};
  			callback(null,response);
		});
	//return error response if lat or long is missing.
	}else{
		const errresponse={
                                statusCode: 500,
                                body: JSON.stringify({statusCode:500,msg:'Missing Input Parameters. Either latitude or longitude or both not provided'})
                        };
		callback(null,errresponse);	
	}

};

module.exports.placeDetails = (event, context, callback) => {

	let photoReference,url,maxwidth=400;

        try{
                photoReference = event.queryStringParameters.photoReference;
        }catch(e){
                photoReference=null;
        }

	if (photoReference!=null){
		url = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference='+photoReference+'&key='+apiKey;
		console.log(url);

		request(url,{encoding: 'base64'}, function (error, googleresponse, body) {
                	const response={
                        	statusCode: 200,
                                body: JSON.stringify({statusCode:200,out:body})
                        };
                	callback(null,response);		
		});
	}else{
                const errresponse={
                                statusCode: 500,
                                body: JSON.stringify({statusCode:500,msg:'photoReference paramter is not provided'})
                        };
                callback(null,errresponse);

	}
};
