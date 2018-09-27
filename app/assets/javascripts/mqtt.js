/**
 * utilities to do sigv4
 * @class SigV4Utils
 */

function SigV4Utils() {}

SigV4Utils.getSignatureKey = function (key, date, region, service) {
    var kDate = AWS.util.crypto.hmac('AWS4' + key, date, 'buffer');
    var kRegion = AWS.util.crypto.hmac(kDate, region, 'buffer');
    var kService = AWS.util.crypto.hmac(kRegion, service, 'buffer');
    var kCredentials = AWS.util.crypto.hmac(kService, 'aws4_request', 'buffer');
    return kCredentials;
};

SigV4Utils.getSignedUrl = function(host, region, credentials) {
    var datetime = AWS.util.date.iso8601(new Date()).replace(/[:\-]|\.\d{3}/g, '');
    var date = datetime.substr(0, 8);

    var method = 'GET';
    var protocol = 'wss';
    var uri = '/mqtt';
    var service = 'iotdevicegateway';
    var algorithm = 'AWS4-HMAC-SHA256';

    var credentialScope = date + '/' + region + '/' + service + '/' + 'aws4_request';
    var canonicalQuerystring = 'X-Amz-Algorithm=' + algorithm;
    canonicalQuerystring += '&X-Amz-Credential=' + encodeURIComponent(credentials.accessKeyId + '/' + credentialScope);
    canonicalQuerystring += '&X-Amz-Date=' + datetime;
    canonicalQuerystring += '&X-Amz-SignedHeaders=host';

    var canonicalHeaders = 'host:' + host + '\n';
    var payloadHash = AWS.util.crypto.sha256('', 'hex')
    var canonicalRequest = method + '\n' + uri + '\n' + canonicalQuerystring + '\n' + canonicalHeaders + '\nhost\n' + payloadHash;

    var stringToSign = algorithm + '\n' + datetime + '\n' + credentialScope + '\n' + AWS.util.crypto.sha256(canonicalRequest, 'hex');
    var signingKey = SigV4Utils.getSignatureKey(credentials.secretAccessKey, date, region, service);
    var signature = AWS.util.crypto.hmac(signingKey, stringToSign, 'hex');

    canonicalQuerystring += '&X-Amz-Signature=' + signature;
    if (credentials.sessionToken) {
        canonicalQuerystring += '&X-Amz-Security-Token=' + encodeURIComponent(credentials.sessionToken);
    }

    var requestUrl = protocol + '://' + host + uri + '?' + canonicalQuerystring;
    return requestUrl;
};


$(function() {
    var signed_url = SigV4Utils.getSignedUrl('a1n5u982zrd0mu.iot.us-east-1.amazonaws.com', 'us-east-1', {'secretAccessKey': 'm/JkJ/Z1KL0u4ibZgDnoGGPU9MJIJAhp38qVqMrR', 'accessKeyId': 'AKIAIOT3XMRGRUFP4HYQ'})
    // console.log(signed_url);
    var client = new Paho.MQTT.Client(signed_url, 'websocket_client');
    // console.log(client);

    // set callback handlers
    client.onConnectionLost = function (responseObject) {
        console.log("Connection Lost: "+responseObject.errorMessage);
    };

    // Connect the client, providing an onConnect callback
    client.connect({
        onSuccess: function onConnect(){
            console.log('Connected!');
            var topic = 'ensemble/data-stream';
            client.subscribe(topic);
            console.log('subscribed to ' + topic);
        }
    });

    client.onMessageArrived = function (message) {
        // console.log("Message Arrived: " + message.payloadString);
        pl = JSON.parse(message.payloadString);
        if (pl.x && pl.y) {
            console.log('point added');
            realtime_series.addPoint([pl.x, pl.y]);
        }
        else {
            console.log('data ignored: ' + message.payloadString);
        }
        // console.log('Topic:     ' + message.destinationName);
        // console.log('QoS:       ' + message.qos);
        // console.log('Retained:  ' + message.retained);
        // console.log('Duplicate: ' + message.duplicate);
    };
});