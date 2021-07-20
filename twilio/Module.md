# Twilio Connector

## Overview

Twilio’s APIs power its platform for communications. Behind these APIs is a software layer connecting and optimizing communications networks around the world to allow your users to call and message anyone, globally. Twilio has a whole host of APIs, from SMS to Voice to Wireless! You can find Twilio's API reference documentation throughout Twilio product documentation. For more information, Please browse the various [Twilio APIs here](https://www.twilio.com/docs/api).
As twilio supports for [HTTP Basic authentication](https://en.wikipedia.org/wiki/Basic_access_authentication). It needs the URL authentication for each request using the credentials provided by the twilio. You can find both your account SID and auth token in the Twilio Console after signing up for [a free Twilio trial account](http://twilio.com/try-twilio?_ga=2.127476109.1229618101.1613523745-690133185.1613523745). 
Twilio uses webhooks to asynchronously let your application know when events happen, like getting an incoming call or receiving an SMS message.

The Twilio connector allows you to send SMS, voice and WhatsApp messages through the Twilio REST API and also connector provides the facility to receive inbound HTTP(S) requests (also known as webhooks) from Twilio's servers.
The Twilio connector consists with two modules

* Twilio client module  - The default module that has the twilio client which can be used to communicate through the SMS, VoiceCalls and Whatsapp messages.

* Webhook listener module  - The module that provides the listener supports for the twilio events such as SentSMSEvent, VoiceCallRinging etc.

This module supports Ballerina Swan Lake Beta 2 version

## Configuring connector

### Prerequisites

* [Twilio Account](https://www.twilio.com/) to obtain Account SID, Auth Token and Twilio phone number

* Java 11 Installed. 
Java Development Kit (JDK) with version 11 is required.

* Ballerina Swan Lake Beta2 is required. 

* (optional)[ngork](https://ngrok.com/) is requried to test listner samples using localhost

### Obtaining tokens

1. Create a twilio account and follow [this link](https://support.twilio.com/hc/en-us/articles/223136107-How-does-Twilio-s-Free-Trial-work-) to obtain a twilio phone number. If you use a trail account, you may need to verify your recipient phone numbers before having any communication with them.

2. Go to this follow [this link](https://support.twilio.com/hc/en-us/articles/223136027-Auth-Tokens-and-How-to-Change-Them) to obtain twilio Account Auth Token. 

3. If you want to use Whatsapp service, Please configure your twilio phone number to use whatsApp services. You can find more detail on Twilio Whatsapp service [here](https://www.twilio.com/docs/whatsapp/api#manage-and-configure-your-whatsapp-enabled-twilio-numbers)

4. Now you can use the obtained credential to use Twilio client connector. To do that, you may create a twilio client as shown in the samples with the following configuration record. You can also use Ballerina configurable variables to provide the credentials.

```ballerina
twilio:TwilioConfiguration twilioConfig = {
        accountSId: <YOUR ACCOUNT SID>,
        authToken: <YOUR AUTH TOKEN>
    };
```

# Quickstart

1.  Have a [Quick Tour](https://ballerina.io/learn/getting-started/quick-tour/) section to download and install Ballerina.  

2.  To use Twilio endpoint, you need to provide the following:

       - Account SId
       - Auth Token

![image](../twilio/samples/docs/dashboardTokens.png)

3. Import the Twilio module to your Ballerina program as follows. You can use [configurable variables](https://ballerina.io/learn/by-example/configurable.html) to provide the necessary credentials.

```ballerina
import ballerina/log;
import ballerinax/twilio;

configurable string accountSId = ?;
configurable string authToken = ?;

public function main() {
    //Twilio Client configuration
    twilio:TwilioConfiguration twilioConfig = {
        accountSId: accountSId,
        authToken: authToken
    };

    //Twilio Client
    twilio:Client twilioClient = new (twilioConfig);

    //Get account detail remote function is called by the twilio client
    var details = twilioClient->getAccountDetails();

    //Response is printed as log messages
    if (details is twilio:Account) {
        log:printInfo("Account Detail: " + details.toString());
    } else {
        log:printInfo(details.message());
    }
}
```

## Snippets
* Send an SMS
This section shows how to use the connector to send an SMS. You will need a verfied phone number if you are using a trial account to send the message from your twilio phone number. if the SMS is sent successfully it will provides SMSResponse record with details of the SMS otherwise it will provide the error occured.
Sample is available at: samples/client samples/sendSMS.bal
```ballerina
    //Send SMS remote function is called by the twilio client
    var details = twilioClient->sendSms(fromMobile, toMobile, message);

    //Response is printed as log messages
    if (details is twilio:SmsResponse) {
        log:printInfo("SMS_SID: " + details.sid.toString() + ", Body: " + details.body.toString());
    } else {
        log:printInfo(details.message());
    }
```
* Send a whatappMessage
As the following example, the connector supports to send whatapp messages and if the message is successfully sent , you will get WhatsAppResponse record otherwsie an error message.
Sample is available at: samples/client samples/sendWhatsappMessage.bal
```ballerina
    //Send whatsapp remote function is called by the twilio client
    var details = twilioClient->sendWhatsAppMessage(fromNo = fromMobile, toNo = toMobile, message = "Test Whatsapp");

    //Response is printed as log messages
    if (details is twilio:WhatsAppResponse) {
        log:printInfo("Message Detail: " + details.toString());
    } else {
        log:printInfo(details.message());
    }
```
* Make a voice call
You can make voice call with twilio voice enabled phone number. The following should be provided in addition to the account access credentials.
1. `fromNo` - the voice-enabled Twilio phone number you added to your account earlier
2. `toNo` - the person you'd like to call
3. `VoiceCallInput` - Instructions in the form [TwiML](https://www.twilio.com/docs/voice/twiml) that explains what should happen when the other party picks up the phone.
4. `statusCallback` - Optionally, instead of passing the Twiml parameter, you can provide a Url that returns TwiML Voice instructions.
Sample is available at: samples/client samples/makeVoiceCall.bal
```ballerina
    //Voice message type: twilio:MESSAGE_IN_TEXT or twilio:TWIML_URL
    twilio:VoiceCallInput voiceInput = { 
        userInput:messageOrLink, 
        userInputType: twilio:MESSAGE_IN_TEXT
    };

    //Make voice Call remote function is called by the twilio client
     var details = twilioClient->makeVoiceCall(fromMobile, toMobile, voiceInput);

    //Response is printed as log messages
    if (details is twilio:VoiceCallResponse) {
        log:printInfo("Message Detail: " + details.toString());
    } else {
        log:printInfo(details.message());
    }
```   
* Get a message
This section shows you how to get a message details  from your account. you need to provide message sid to retrieve the details from the message list of your account. If the request is successful, it will send the MessageResourceResponse record else an error message with the details.
Sample is available at: samples/client samples/getMessage.bal
```ballerina    
    //Set Message resource SID to get the message detail
    string messageSid = "<Add Mesaage SID>";

    //Get SMS remote function is called by the twilio client
    var details = twilioClient->getMessage(messageSid);
    
    //Response is printed as log messages
    if (details is twilio:MessageResourceResponse) {
        log:printInfo("Message Detail: " +details.toString());
    } else {
        log:printInfo(details.message());
    }
```
### [You can find more samples here](https://github.com/ballerina-platform/module-ballerinax-twilio/tree/master/twilio/samples)
