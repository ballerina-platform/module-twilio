
## Overview

The Twilio Listener connector allows you to listen to Twilio SMS and Call status change events.
1. Listen to incoming message events and message status change callback events from the twilio SMS
2. Listen to incoming call events and call status change callback events from the twilio Voice Call

### Note:

Callback URL registration method depends on the event type.
1. Twilio SMS
 - Incoming Messages
    - Callback webhook URL has to be registered in the console under the particular Twilio number.
 - Status change events
    - Callback webhook URL has to be registered at the time of sending the SMS (from the client connector)
2. Twilio Call
 - Incoming Call
    - Callback webhook URL has to be registered in the console under the particular Twilio number.
 - Status change events
    - Callback webhook URL has to be registered at the time of making the call (from the client connector)

This module supports Ballerina Swan Lake Beta 2 version

## Configuring connector

### Prerequisites

* [Twilio Account](https://www.twilio.com/) to obtain Account SID, Auth Token and Twilio phone number

* Java 11 Installed. 
Java Development Kit (JDK) with version 11 is required.

* Ballerina Swan Lake Beta 2 is required. 

* (optional)[ngork](https://ngrok.com/) is requried to test listner samples using localhost

### Obtaining tokens

1. Create a twilio account and follow [this link](https://support.twilio.com/hc/en-us/articles/223136107-How-does-Twilio-s-Free-Trial-work-) to obtain a twilio phone number. If you use a trail account, you may need to verify your recipient phone numbers before having any communication with them.

2. Go to this follow [this link](https://support.twilio.com/hc/en-us/articles/223136027-Auth-Tokens-and-How-to-Change-Them) to obtain twilio Account Auth Token. 

3. You need to provide port number where the twilio listener listens for any twilio events requests from Twilio service

4. You also need to provide a callback url before running the listener with suffix "onChange" example: <YOUR_CALL_BACK_URL>/onChange

5. To Listen to incoming SMS or Voice call events, you need to add a callback url in your twilio account as shown in the following figure.

```ballerina
twilio:TwilioConfiguration twilioConfig = {
        accountSId: <YOUR ACCOUNT SID>,
        authToken: <YOUR AUTH TOKEN>
    };
```

# Quickstart

1.  Have a [Quick Tour](https://ballerina.io/learn/getting-started/quick-tour/) section to download and install Ballerina.

2. Import the Twilio listener module to your Ballerina program as follows.

	```ballerina
	import ballerina/log;
    import ballerinax/twilio;
    import ballerinax/twilio.'listener as twilioListener;

    configurable string & readonly twilioAuthToken = ?;
    configurable string & readonly callbackUrl = ?;
    configurable int & readonly port = ?;

    listener twilioListener:Listener tListener = new (port, twilioAuthToken, callbackUrl);

    service / on tListener {
        remote function onSmsDelivered(twilioListener:SmsStatusChangeEvent event) returns error? {
            log:printInfo("Delivered", event);
        }
    }
	```

## Snippets
* QUEUED/SENT/DELIVERED SMS Event
This examples shows how you can start a ballerina twilio listener using localhost. you will need to use ngork to expose a web server running on your local machine to the internet.
```ballerina
    service / on tListener {
        remote function onCallRang(twilioListener:CallStatusChangeEvent event) returns error? {
            log:printInfo("Ringing", event);
        }
        remote function onCallAnswered(twilioListener:CallStatusChangeEvent event) returns error? {
            log:printInfo("In Progress", event);
        }
        remote function onCallCompleted(twilioListener:CallStatusChangeEvent event) returns error? {
            log:printInfo("Completed", event);
        }
    }
}
```
* Ringing/InProgress/Completed Voice Call Events
This provides the listener support to the voice calls. you will need to use ngork to expose a web server running on your local machine to the internet. Find more sample from here.
```ballerina
    service / on tListener {
        remote function onCallRang(twilioListener:CallStatusChangeEvent event) returns error? {
            log:printInfo("Ringing", event);
        }
        remote function onCallAnswered(twilioListener:CallStatusChangeEvent event) returns error? {
            log:printInfo("In Progress", event);
        }
        remote function onCallCompleted(twilioListener:CallStatusChangeEvent event) returns error? {
            log:printInfo("Completed", event);
        }
    }
}
```
### [You can find more samples here](https://github.com/ballerina-platform/module-ballerinax-twilio/tree/master/twilio/samples)
