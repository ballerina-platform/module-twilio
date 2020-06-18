// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/encoding;
import ballerina/http;
import ballerina/lang.'boolean;
import ballerina/log;

# Check for HTTP response and if response is success parse HTTP response object into `json` and parse error otherwise.
# + httpResponse - HTTP response or HTTP Connector error with network related errors
# + return - `json` payload or `error` if anything wrong happen when HTTP client invocation or parsing response to `json`
function parseResponseToJson(http:Response|error httpResponse) returns @tainted json|error {
    if (httpResponse is http:Response) {
        var jsonResponse = httpResponse.getJsonPayload();
        
        if (jsonResponse is json) {
            if (httpResponse.statusCode != http:STATUS_OK && httpResponse.statusCode != http:STATUS_CREATED) {
                string code = "";
                if (jsonResponse?.error_code != ()) {
                    code = jsonResponse.error_code.toString();
                } else if (jsonResponse?.'error != ()) {
                    code = jsonResponse.'error.toString();
                }

                string message = jsonResponse.message.toString();
                string errorMessage = httpResponse.statusCode.toString() + " " + httpResponse.reasonPhrase;
                if (code != "") {
                    errorMessage += " - " + code;
                }
                errorMessage += " : " + message;
                return prepareError(errorMessage);
            }
            return jsonResponse;
        } else {
            return prepareError("Error occurred while accessing the JSON payload of the response");
        }
    } else {
        return prepareError("Error occurred while invoking the REST API");
    }
}

# Create URL encoded request body with given key and value.
# + requestBody - Request body to be appended values
# + key - Key of the form value parameter
# + value - Value of the form value parameter
# + return - Created request body with encoded string or `error` if anything wrong happen when encoding the value
function createUrlEncodedRequestBody(string requestBody, string key, string value) returns string|error {
    var encodedVar = encoding:encodeUriComponent(value, CHARSET_UTF8);
    string encodedString = "";
    string body = "";
    if (encodedVar is string) {
        encodedString = encodedVar;
    } else {
        return prepareError("Error occurred while encoding the string");
    }
    if (requestBody != "") {
        body = requestBody + "&";
    }
    return body + key + "=" + encodedString;
}

function convertToBoolean(json|error value) returns boolean {
    if (value is json) {
        boolean|error result = 'boolean:fromString(value.toString());
        if (result is boolean) {
            return result;
        }
    }
    return false;
}

function prepareError(string message, error? err = ()) returns Error {
    log:printError(message, err);
    Error twilioError;
    if (err is error) {
        twilioError = TwilioError(message, err);
    } else {
        twilioError = TwilioError(message);
    }
    return twilioError;
}
