"""
This module provides step definitions for behavior-driven development
(BDD) scenarios using the Behave framework, focusing on HTTP request
handling and parameter management. It includes steps for setting request
placeholders from values or global parameters, generating request tokens
from response or global parameters, configuring request parameters with
various types of values or fake data, and sending HTTP requests with the
appropriate method and parameters. Additionally, it supports deleting
global parameters and handling TOTP generation. The module facilitates
comprehensive testing by managing request and response details
dynamically.
"""

import json
import random
import string
import requests, pyotp
from behave import *
from app.fake_providers import fake

REQUEST_HEADERS = {"accept": "application/json"}
AUTH_HEADER = "Authorization"
AUTH_PREFIX = "Bearer "
STRING_CHARACTERS = string.ascii_letters


@given("set request token from global param '{global_param}'")
def step_impl(context, global_param):
    """
    Sets the request token in request_headers by prefixing the value
    from global_params associated with global_param with AUTH_PREFIX,
    and then storing the result under the AUTH_HEADER key.
    """
    auth_header = AUTH_PREFIX + context.global_params[global_param]
    context.request_headers[AUTH_HEADER] = auth_header


@given("set request token from response param '{response_param}'")
def step_impl(context, response_param):
    """
    Sets the request token in request_headers using a value
    from response_params, by prefixing the value associated with
    response_param with AUTH_PREFIX and storing it under the
    AUTH_HEADER key.
    """
    auth_header = AUTH_PREFIX + context.response_params[response_param]
    context.request_headers[AUTH_HEADER] = auth_header


@given("delete request token")
def step_impl(context):
    """
    Removes the authentication token from the request_headers in the
    context if it exists, by deleting the entry associated with the 
    corresponding key.
    """
    if AUTH_HEADER in context.request_headers:
        del context.request_headers[AUTH_HEADER]


@given("set request placeholder '{request_placeholder}' from config param '{config_param}'")
def step_impl(context, request_placeholder, config_param):
    """
    Sets a request placeholder in the context with a value retrieved
    from config parameters, updating the request_placeholders dict using
    the specified config parameter key to get the corresponding value
    from config_params.
    """
    param = context.config_params[config_param]
    context.request_placeholders[request_placeholder] = param


@given("set request placeholder '{request_placeholder}' from global param '{global_param}'")
def step_impl(context, request_placeholder, global_param):
    """
    Sets a request placeholder in the context with a value retrieved
    from global parameters, updating the request_placeholders dict using
    the specified global parameter key to get the corresponding value
    from global_params.
    """
    param = context.global_params[global_param]
    context.request_placeholders[request_placeholder] = param


@given("set request placeholder '{request_placeholder}' from value '{value}'")
def step_impl(context, request_placeholder, value):
    """
    Sets a value for a request placeholder in the context, allowing for
    dynamic data assignment in BDD scenarios. This step updates the
    request_placeholders dict in the context with the given placeholder
    key and its corresponding value.
    """
    context.request_placeholders[request_placeholder] = value


@given("set request param '{request_param}' from value '{value}'")
def step_impl(context, request_param, value):
    """
    Sets or modifies a request parameter in request_params based on the
    specified value. If value is none, the parameter is removed. If
    empty, it's set to an empty string. If spaces, it's set to eight
    spaces. If tabs, it's set to eight tab characters. If value starts
    is string, it generates a random string of the specified length and
    sets it as the parameter value. Otherwise, the parameter is set 
    directly to the provided value.
    """
    if value == "none":
        if request_param in context.request_params:
            del context.request_params[request_param]

    elif value == "empty":
        context.request_params[request_param] = ""

    elif value == "spaces":
        context.request_params[request_param] = " " * 8

    elif value == "tabs":
        context.request_params[request_param] = "   " * 8

    elif value.startswith("string(") and value.endswith(")"):
        string_len = int(value[len("string("):-1])
        random_string = "".join(random.choices(STRING_CHARACTERS, k=string_len))
        context.request_params[request_param] = random_string

    else:
        context.request_params[request_param] = value


@given("set request param '{request_param}' from fake '{fake_provider}'")
def step_impl(context, request_param, fake_provider):
    """
    Sets a request parameter in request_params using a value generated
    by a fake data provider. The function retrieves the fake provider
    function from the fake module using getattr and invokes it to
    generate the value to be assigned to the specified request_param.
    """
    context.request_params[request_param] = getattr(fake, fake_provider)()


@given("set request param '{request_param}' from config param '{config_param}'")
def step_impl(context, request_param, config_param):
    """
    Sets a request parameter in request_params using the value of a
    configuration parameter from config_params. The function assigns
    the value associated with config_param in context.config_params
    to the specified request_param in context.request_params.
    """
    context.request_params[request_param] = context.config_params[config_param]


@given("generate request param 'user_totp' from config param '{config_param}'")
def step_impl(context, config_param):
    """
    Generates a user_totp request parameter using a time-based one-time
    password (TOTP) value derived from the specified configuration
    parameter. The function retrieves the MFA key from config_params
    using config_param, creates a TOTP object with this key, and assigns
    the current TOTP value to context.request_params.
    """
    mfa_key = context.config_params[config_param]
    context.request_params["user_totp"] = pyotp.TOTP(mfa_key).now()


@then("delete global param '{global_param}'")
def step_impl(context, global_param):
    """
    Deletes a global parameter from global_params if it exists. The
    function checks if global_param is present in context.global_params
    and removes it if found.
    """
    if global_param in context.global_params:
        del context.global_params[global_param]


@when("send '{request_method}' request to url '{request_url}'")
def step_impl(context, request_method, request_url):
    """
    Sends an HTTP request of the specified method (GET, POST, PUT,
    DELETE) to a constructed URL. The URL is built using a base URL
    from config_params and any placeholders in the request URL are
    replaced with values from request_placeholders. The request is
    sent with headers, parameters, and files from the context, and
    the response status code and body are stored in context. The
    request headers and parameters are then cleared from the context.
    """
    url = context.config_params["base_url"] + request_url
    for placeholder in context.request_placeholders:
        url = url.replace(":" + placeholder,
                          str(context.request_placeholders[placeholder]))

    headers = context.request_headers
    headers["accept"] = "application/json"
    params = context.request_params

    if request_method == "POST":
        response = requests.post(url, headers=headers, params=params,
                                 files=context.request_files)

    elif request_method == "GET":
        response = requests.get(url, headers=headers, params=params)

    elif request_method == "PUT":
        response = requests.put(url, headers=headers, params=params)

    elif request_method == "DELETE":
        response = requests.delete(url, headers=headers, params=params)

    context.response_code = response.status_code
    context.response_params = json.loads(response.text)

    context.request_headers = {}
    context.request_params = {}
