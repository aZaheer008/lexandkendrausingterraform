var AWS = require('aws-sdk');

//   (async () => {
//     let cmd = new StartConversationCommand(lexparams);
//     try {
//       const data = await client.send(cmd);
//       console.log("Success. Response is: ", data.message);
//     } catch (err) {
//       console.log("Error responding to message. ", err);
//     }
//     // Your code here...
//   })();

  const { LexRuntimeV2Client, RecognizeTextCommand } = require("@aws-sdk/client-lex-runtime-v2");
  const { HttpsConnection } = require("@aws-sdk/transport-http");

  const client = new LexRuntimeV2Client(
    { region: "us-east-1" ,
    credentials: new AWS.Credentials({
      accessKeyId: "accessKeyId",         // Add your access IAM accessKeyId
      secretAccessKey: "secretAccessKey"      // Add your access IAM secretAccessKey
    })}
);
  
  async function sendMessage(botId, botAliasId, localeId, sessionId, message) {
    const params = {
      botId,
      botAliasId,
      localeId,
      sessionId,
      inputText: message
    };
    const command = new RecognizeTextCommand(params);
    const response = await client.send(command);
    return response;
  }
  
  // Example usage:
  const botId = "kendra";
  const botAliasId = "my-bot-alias-id";
  const localeId = "en_US";
  const sessionId = "my-session-id";
  const message = "Do You return";
  
  sendMessage(botId,botAliasId, localeId, sessionId, message)
    .then((response) => {
      console.log("Bot response:", response);
    })
    .catch((error) => {
      console.error("Error sending message:", error);
    });