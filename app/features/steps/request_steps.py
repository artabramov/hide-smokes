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


@given("set request header token from global param '{global_param}'")
def step_impl(context, global_param: str):
    """
    Sets the request token in the headers by prefixing a value from
    global parameters with a predefined prefix. The resulting token
    is then stored in the request headers.
    """
    auth_header = AUTH_PREFIX + context.global_params[global_param]
    context.request_headers[AUTH_HEADER] = auth_header


@given("set request header token from response param '{response_param}'")
def step_impl(context, response_param: str):
    """
    Sets the request token in the headers using a value from the
    response parameters. The value is prefixed with a predefined
    string and then stored in the request headers.
    """
    auth_header = AUTH_PREFIX + context.response_params[response_param]
    context.request_headers[AUTH_HEADER] = auth_header


@given("delete request header token")
def step_impl(context):
    """
    Removes the authentication token from the request headers in
    the context, if it exists, by deleting the entry associated
    with the relevant key.
    """
    if AUTH_HEADER in context.request_headers:
        del context.request_headers[AUTH_HEADER]


@given("set request path param '{path_param}' from config param '{config_param}'")
def step_impl(context, path_param: str, config_param: str):
    """
    Sets a request path parameter in the context using a value retrieved
    from the configuration parameters. The specified configuration key
    is used to obtain the corresponding value, which is then updated
    in the request path.
    """
    context.request_path[path_param] = context.config_params[config_param]


@given("set request query param '{query_param}' from config param '{config_param}'")
def step_impl(context, query_param: str, config_param: str):
    context.request_query[query_param] = context.config_params[config_param]


@given("set request path param '{path_param}' from global param '{global_param}'")
def step_impl(context, path_param: str, global_param: str):
    """
    Sets a request path parameter in the context using a value retrieved 
    from global parameters. The specified global parameter key is used
    to obtain the corresponding value, which updates the request path.
    """
    param = context.global_params[global_param]
    context.request_path[path_param] = param


@given("set request path param '{path_param}' from value '{value}'")
def step_impl(context, path_param: str, value: str):
    """
    Sets a request path parameter in the context based on the provided
    value. If the value is "none," the corresponding entry is removed
    from the request path. Otherwise, the value is processed and stored
    in the request path.
    """
    if value == "none":
        if value in context.request_path:
            del context.request_path[path_param]
    
    else:
        context.request_path[path_param] = _get_actual_value(value)


@given("set request path param '{path_param}' from fake '{fake_provider}'")
def step_impl(context, path_param: str, fake_provider: str):
    """
    Sets a request path parameter using a value generated by a fake
    data provider. This function retrieves the appropriate fake provider
    function and invokes it to generate the value assigned to the
    specified request path parameter.
    """
    context.request_path[path_param] = getattr(fake, fake_provider)()


@given("set request body param '{body_param}' from value '{value}'")
def step_impl(context, body_param: str, value: str):
    """
    Sets a request body parameter based on the provided value.
    If the value is "none," the corresponding entry is removed
    from the request body. Otherwise, the value is processed and
    assigned to the specified body parameter.
    """
    if value == "none":
        if body_param in context.request_body:
            del context.request_body[body_param]

    else:
        context.request_body[body_param] = _get_actual_value(value)


@given("set request body param '{body_param}' from fake '{fake_provider}'")
def step_impl(context, body_param: str, fake_provider: str):
    """
    Sets a request body parameter using a value generated by a fake
    data provider. The appropriate fake provider function is retrieved
    and invoked to generate the value assigned to the specified body
    parameter.
    """
    context.request_body[body_param] = getattr(fake, fake_provider)()


@given("set request body param '{body_param}' from global param '{global_param}'")
def step_impl(context, body_param: str, global_param: str):
    """
    Sets a request body parameter using a value from global parameters. 
    The specified global parameter is used to retrieve the value, which
    is then assigned to the specified body parameter.
    """
    context.request_body[body_param] = context.global_params[global_param]


@given("set request query param '{query_param}' from value '{value}'")
def step_impl(context, query_param: str, value: str):
    """
    Sets a request query parameter based on the provided value. If the
    value is "none," the corresponding entry is removed from the request
    query. Otherwise, the value is processed and assigned to the
    specified query parameter.
    """
    if value == "none":
        if query_param in context.request_query:
            del context.request_query[query_param]

    else:
        context.request_query[query_param] = _get_actual_value(value)


@given("set request query param '{query_param}' from fake '{fake_provider}'")
def step_impl(context, query_param: str, fake_provider: str):
    """
    Sets a request query parameter using a value generated by a fake
    data provider. The appropriate fake provider function is retrieved
    and invoked to generate the value assigned to the specified query
    parameter.
    """
    context.request_query[query_param] = getattr(fake, fake_provider)()


@given("set request body param '{body_param}' from config param '{config_param}'")
def step_impl(context, body_param, config_param):
    context.request_body[body_param] = context.config_params[config_param]


# @given("set request param '{request_param}' from global param '{global_param}'")
# def step_impl(context, request_param, global_param):
#     """
#     Sets a request parameter from a global parameter value. The function
#     retrieves the value of a global parameter from the context and
#     assigns it to a request parameter in the context.
#     """
#     param = context.global_params[global_param]
#     context.request_params[request_param] = param


@given("set request file from sample format '{file_extension}'")
def step_impl(context, file_extension: str):
    """
    Sets up a request sample file with the specified extension from the
    configured base path, and stores the file data, filename, and MIME
    type in the context for use in subsequent requests.
    """
    base_path = context.config_params["file_samples_base_path"]
    filename = "sample." + file_extension
    mimetype = "image/" + file_extension

    file_data = None
    with open(base_path + filename, "rb") as fn:
        file_data = fn.read()

    context.request_files = {"file": (filename, file_data, mimetype)}


@given("delete request file")
def step_impl(context):
    context.request_files = {}


@given("generate request query param 'user_totp' from config param '{config_param}'")
def step_impl(context, config_param):
    """
    Generates a user_totp request parameter using a time-based one-time
    password (TOTP) value derived from the specified configuration
    parameter. The function retrieves the MFA key from config_params
    using config_param, creates a TOTP object with this key, and assigns
    the current TOTP value to context.request_params.
    """
    mfa_key = context.config_params[config_param]
    context.request_query["user_totp"] = pyotp.TOTP(mfa_key).now()


@then("delete global param '{global_param}'")
def step_impl(context, global_param):
    """
    Deletes a global parameter from global_params if it exists. The
    function checks if global_param is present in context.global_params
    and removes it if found.
    """
    if global_param in context.global_params:
        del context.global_params[global_param]


def _get_actual_value(value: str) -> str:
    """
    Returns a value based on the provided description: an empty string
    for "empty", a string of 8 spaces for "spaces", a string of 8 tabs
    for "tabs", or a random string of a specified length if the
    description is in the format "string(n)". For other inputs, the
    function returns the value as is.
    """
    if value == "empty":
        return ""

    elif value == "spaces":
        return " " * 8

    elif value == "tabs":
        return "   " * 8
    
    elif value == "dict":
        return {}

    elif value.startswith("string(") and value.endswith(")"):
        string_len = int(value[len("string("):-1])
        random_string = "".join(random.choices(STRING_CHARACTERS, k=string_len))
        return random_string

    else:
        return value


@when("send request to external url from global param '{global_param}'")
def step_impl(context, global_param: str):
    """
    Sends a GET request to a URL derived from a global parameter by
    replacing the external base URL with an internal base URL, then
    stores the response status code and content in the context.
    """
    external_url = context.global_params[global_param]
    internal_url = external_url.replace(
        context.config_params["external_base_url"],
        context.config_params["internal_base_url"])

    response = requests.get(internal_url)

    context.response_code = response.status_code
    context.response_content = response.content


@when("send '{request_method}' request to url '{request_url}'")
def step_impl(context, request_method, request_url):
    """
    Sends an HTTP request of the specified method (GET, POST, PUT,
    DELETE) to a constructed URL. The URL is built using a base URL
    from config_params and any placeholders in the request URL are
    replaced with values from request_path. The request is
    sent with headers, parameters, and files from the context, and
    the response status code and body are stored in context. The
    request headers and parameters are then cleared from the context.
    """
    url = context.config_params["internal_base_url"] + request_url
    for placeholder in context.request_path:
        url = url.replace(":" + placeholder,
                          str(context.request_path[placeholder]))

    headers = context.request_headers
    headers["accept"] = "application/json"

    if request_method == "POST" and context.request_files:
        response = requests.post(
            url, headers=headers, files=context.request_files)

    elif request_method == "POST":
        response = requests.post(
            url, json=context.request_body, headers=headers)

    elif request_method == "GET":
        response = requests.get(
            url, headers=headers, params=context.request_query)

    elif request_method == "PUT":
        response = requests.put(
            url, json=context.request_body, headers=headers)

    elif request_method == "DELETE":
        response = requests.delete(
            url, headers=headers, params=context.request_query)

    context.response_code = response.status_code
    context.response_content = response.content

    try:
        context.response_params = json.loads(response.text)
    except Exception:
        context.response_params = {}

    context.request_headers = {}
    context.request_query = {}
