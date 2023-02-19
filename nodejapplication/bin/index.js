#!/usr/bin/env node

var AWS = require('aws-sdk');

const { LexRuntime } = require('aws-sdk');
const yargs = require("yargs");

try {

  const options = yargs
  .usage("Usage: -n <text>")
  .option("t", { alias: "text", describe: "text", type: "string", demandOption: false })
  .argv;

  console.log("------text-----",options.n);

  const lex = new LexRuntime(
    { region: "us-east-1" ,
    credentials: new AWS.Credentials({
      accessKeyId: "AKIA5WMFGBPT27ZTHO2E",         // Add your access IAM accessKeyId
      secretAccessKey: "s88vmfnI9D4Hj7p4intK/w4PMfYItpM8o4qUxovX"      // Add your access IAM secretAccessKey
    })}
  );
  
  const params = {
    botAlias: '$LATEST',
    botName: 'kendra',
    inputText: options.n,
    userId: 'my-user-id',
  };
  
  lex.postText(params, (err, data) => {
    if (err) {
      console.log(err, err.stack);
    } else {
      console.log(data);
    }
  });



} catch (error) {
  console.log("----error--- : ",error);
  throw error;
}

