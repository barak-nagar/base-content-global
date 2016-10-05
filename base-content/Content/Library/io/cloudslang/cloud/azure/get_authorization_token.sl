#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Generates the authorization token for Azure API calls.
#! @input identifier: the Identifier text box in the Credentials section of the Service Management API tab of System Settings
#! @input primary_or_secondary_key: the Primary Key or the Secondary Key in the Credentials section of the Service
#!                                  Management API tab of System Settings
#! @input expiry: the expiration date and time for the access token, the value must be in the format MM/DD/YYYY H:MM PM|AM
#!               Example: 08/04/2014 10:03 PM
#! @output return_result: the authorization token for Azure
#! @output exception: the error message of the operation, if any
#! @output return_code: '0' if success, '-1' otherwise
#! @result SUCCESS: operation succeeded and returned the value for the authorization header
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.azure

operation:
  name: get_authorization_token

  inputs:
    - identifier
    - primary_or_secondary_key
    - primaryOrSecondaryKey:
        default: ${get("primary_or_secondary_key", "")}
        required: false
        private: true
    - expiry

  java_action:
    gav: 'io.cloudslang.content:cs-azure:0.0.1'
    class_name: io.cloudslang.content.azure.actions.GetAuthorizationToken
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - exception
    - return_code: ${returnCode}
  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
