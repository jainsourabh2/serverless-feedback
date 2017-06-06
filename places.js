'use strict';

const apiKey 	= 	'AIzaSyBEsHP5d2bf24_vAE46FaTYihBu8JLCibE';
const radius	= 	1000;
const types	=	'restaurant';	
const gp	=	require('node-googleplaces');

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
                                body: "Missing Input Parameters. Either latitude or longitude or both not provided"
                        };
		callback(null,errresponse);	
	}

};
