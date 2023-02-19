'use strict';

const AWS = require('aws-sdk');
const POLICY_INTENT = 'policy'
const SERVICE_INTENT = 'service'
const RETURN_INTENT = 'returnpolicy'
const KENDRA_INTENT = 'kendraIntent'

// Payload that we construct from intent slots
var payload = {}

// Close dialog with the user,
// reporting fulfillmentState of Failed or Fulfilled
function close(sessionAttributes, fulfillmentState, message) {
    return {
        sessionAttributes,
        dialogAction: {
            type: 'Close',
            fulfillmentState,
            message,
        },
    };
}

// --------------- readPolicy -----------------------
async function readPolicy(intentRequest, callback) {
    const slots = intentRequest.currentIntent.slots;
    const title = slots.policyTitle;

    try {
        const result = `This is the response of Your given ${title} Policy `;
        return result;
    } catch (error) {
        console.error(error);
    }
}

// --------------- service -----------------------
async function service(intentRequest, callback) {

    try {
        const result = `This is the response of Your Weekend Question, Yes wee open on  Weekend `;
        return result;
    } catch (error) {
        console.error(error);
    }
}

// --------------- service -----------------------
async function returnpolicy(intentRequest, callback) {

    try {
        const result = `This is the response of Your return Question, Yes we return`;
        return result;
    } catch (error) {
        console.error(error);
    }
}


// --------------- kendra -----------------------
async function kendra(intentRequest, callback) {

    try {
        const kendra = new AWS.Kendra({apiVersion: '2019-02-03'});
         // Set up the parameters for the query
    const params = {
        // IndexId: process.env.INDEX_ID, // the Kendra index ID
        IndexId: "b9d48501-e953-4a8e-a7e1-3816beceb31b", // the Kendra index ID
        QueryText: "Do you use organic milk in all your products?", // the query string
        QueryResultTypeFilter: 'ANSWER', // return only answers, not documents
    };

    console.log("--83---inside kendra--",params)
    // Query the Kendra index
        const result1 = await kendra.query(params).promise();
        const result = `This is kendra the response of Your return Question, Yes we return`;
        console.log("-----------result1-----",result1);
        return result;
    } catch (error) {
        console.log("--83---error--",error)
        console.error(error);
    }
}


// --------------- Events -----------------------
async function dispatch(intentRequest, context, callback) {
    const intentName = intentRequest.currentIntent.name;

    // will store our response contet to be sent back to Lex
    let responseContent = ''
    let slotToElicit;
    let message;

    switch (intentName) {
        case POLICY_INTENT:
            responseContent = await readPolicy(intentRequest);
            break;
        case SERVICE_INTENT:
            responseContent = await service(intentRequest);
            break;
        case RETURN_INTENT:
            responseContent = await returnpolicy(intentRequest);
            break;
        case KENDRA_INTENT:
                responseContent = await kendra(intentRequest);
            break;
        default:
            responseContent = `Can't find an answer to that`;
    }


    // map of slot names, configured for the intent, to slot values that
    // Amazon Lex has recognized in the user conversation.
    // A slot value remains null until the user provides a value.
    const slots = intentRequest.currentIntent.slots;

    // invocationSource indicates why Amazon Lex is invoking the Lambda function,
    // Amazon Lex sets this to one of the following values:
    // DialogCodeHook – Amazon Lex sets this value to direct the Lambda function
    // to initialize the function and to validate the user's data input.
    // FulfillmentCodeHook – Lex sets this value to
    // direct the Lambda function to fulfill an intent.
    const source = intentRequest.invocationSource;

    // Application-specific session attributes that the client
    // sends in the request.
    // If you want Amazon Lex to include them in the response to the client,
    // your Lambda function should send these back to Amazon Lex in the response
    const sessionAttributes = intentRequest.sessionAttributes;

    console.log("-------responseContent-----",responseContent);

    if (source !== 'DialogCodeHook') {
        callback(
            close(
                sessionAttributes,
                'Fulfilled',
                {
                    'contentType': 'PlainText',
                    'content': `Fulfill intent named ${intentName}
                    ResponseContent: ${JSON.stringify(responseContent)}`
                }
            )
        );
    }
}

// --------------- Main handler -----------------------

// Route the incoming request based on intent.
// The JSON body of the request is provided in the event slot.
exports.handler = (event, context, callback) => {
    console.log("-----event-----",event);
    try {
        dispatch(event,
            context,
            (response) => {
                callback(null, response);
            });
    } catch (err) {
        callback(err);
    }
};
