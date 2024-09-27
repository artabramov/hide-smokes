Feature: List revisions

Background: Auth users
    # auth users
Given auth with user role 'admin'
  And auth with user role 'editor'
  And auth with user role 'writer'
  And auth with user role 'reader'

@revision @list
Scenario Outline: List revisions when mediafile_id is invalid
    # list revisions
Given set request header token from global param 'admin_token' 
  And set request query param 'mediafile_id__eq' from value '<mediafile_id>'
  And set request query param 'offset' from value '0'
  And set request query param 'limit' from value '1'
  And set request query param 'order_by' from value 'id'
  And set request query param 'order' from value 'asc'
 When send 'GET' request to url 'revisions'
 Then response code is '422'
  And error loc is 'query' and 'mediafile_id__eq'
  And error type is '<error_type>'
  And response contains '1' params

Examples:
| collection_id | error_type         |
| tabs          | int_parsing        |
| spaces        | int_parsing        |
| 123.4         | int_parsing        |
| 123,0         | int_parsing        |
| string(0)     | int_parsing        |
| string(8)     | int_parsing        |

@revision @list
Scenario Outline: List revisions when mediafile_id is correct
    # list revisions
Given set request header token from global param 'admin_token' 
  And set request query param 'mediafile_id__eq' from value '<mediafile_id>'
  And set request query param 'offset' from value '0'
  And set request query param 'limit' from value '1'
  And set request query param 'order_by' from value 'id'
  And set request query param 'order' from value 'asc'
 When send 'GET' request to url 'revisions'
 Then response code is '200'
  And response params contain 'revisions'
  And response params contain 'revisions_count'
  And response contains '2' params

Examples:
| mediafile_id |
| none        |
| 0           |
| 0.0         |
| -123        |
| -123.0      |
| +123        |
| +123.0      |

@revision @list
Scenario Outline: List revisions when offset is invalid
    # list revisions
Given set request header token from global param 'admin_token' 
  And set request query param 'offset' from value '<offset>'
  And set request query param 'limit' from value '1'
  And set request query param 'order_by' from value 'id'
  And set request query param 'order' from value 'asc'
 When send 'GET' request to url 'revisions'
 Then response code is '422'
  And error loc is 'query' and 'offset'
  And error type is '<error_type>'
  And response contains '1' params

Examples:
| offset    | error_type         |
| none      | missing            |
| tabs      | int_parsing        |
| spaces    | int_parsing        |
| 123.4     | int_parsing        |
| 123,0     | int_parsing        |
| -123      | greater_than_equal |
| string(0) | int_parsing        |
| string(8) | int_parsing        |

@revision @list
Scenario Outline: List revisions when offset is correct
    # list revisions
Given set request header token from global param 'admin_token' 
  And set request query param 'offset' from value '<offset>'
  And set request query param 'limit' from value '1'
  And set request query param 'order_by' from value 'id'
  And set request query param 'order' from value 'asc'
 When send 'GET' request to url 'revisions'
 Then response code is '200'
  And response params contain 'revisions'
  And response params contain 'revisions_count'
  And response contains '2' params

Examples:
| offset |
| 0      |
| 0.0    |
| 123    |
| 123.0  |
| +123   |

@revision @list
Scenario Outline: List revisions when limit is invalid
    # list revisions
Given set request header token from global param 'admin_token' 
  And set request query param 'offset' from value '0'
  And set request query param 'limit' from value '<limit>'
  And set request query param 'order_by' from value 'id'
  And set request query param 'order' from value 'asc'
 When send 'GET' request to url 'revisions'
 Then response code is '422'
  And error loc is 'query' and 'limit'
  And error type is '<error_type>'
  And response contains '1' params

Examples:
| limit     | error_type         |
| none      | missing            |
| tabs      | int_parsing        |
| spaces    | int_parsing        |
| 0         | greater_than_equal |
| 0.0       | greater_than_equal |
| 123.4     | int_parsing        |
| 123,0     | int_parsing        |
| -123      | greater_than_equal |
| string(0) | int_parsing        |
| string(8) | int_parsing        |

@revision @list
Scenario Outline: List revisions when limit is correct
    # list revisions
Given set request header token from global param 'admin_token' 
  And set request query param 'offset' from value '0'
  And set request query param 'limit' from value '<limit>'
  And set request query param 'order_by' from value 'id'
  And set request query param 'order' from value 'asc'
 When send 'GET' request to url 'revisions'
 Then response code is '200'
  And response params contain 'revisions'
  And response params contain 'revisions_count'
  And response contains '2' params

Examples:
| limit |
| 1     |
| 123   |
| 123.0 |
| +123  |

@revision @list
Scenario Outline: List revisions when order_by is invalid
    # list revisions
Given set request header token from global param 'admin_token' 
  And set request query param 'offset' from value '0'
  And set request query param 'limit' from value '1'
  And set request query param 'order_by' from value '<order_by>'
  And set request query param 'order' from value 'asc'
 When send 'GET' request to url 'revisions'
 Then response code is '422'
  And error loc is 'query' and 'order_by'
  And error type is '<error_type>'
  And response contains '1' params

Examples:
| order_by  | error_type    |
| none      | missing       |
| tabs      | literal_error |
| spaces    | literal_error |
| 0         | literal_error |
| 123       | literal_error |
| string(8) | literal_error |

@revision @list
Scenario Outline: List revisions when order_by is correct
    # list revisions
Given set request header token from global param 'admin_token' 
  And set request query param 'offset' from value '0'
  And set request query param 'limit' from value '1'
  And set request query param 'order_by' from value '<order_by>'
  And set request query param 'order' from value 'asc'
 When send 'GET' request to url 'revisions'
 Then response code is '200'
  And response params contain 'revisions'
  And response params contain 'revisions_count'
  And response contains '2' params

Examples:
| order_by          |
| id                |
| created_date      |

@revision @list
Scenario Outline: List revisions when order is invalid
    # list revisions
Given set request header token from global param 'admin_token' 
  And set request query param 'offset' from value '0'
  And set request query param 'limit' from value '1'
  And set request query param 'order_by' from value 'id'
  And set request query param 'order' from value '<order>'
 When send 'GET' request to url 'revisions'
 Then response code is '422'
  And error loc is 'query' and 'order'
  And error type is '<error_type>'
  And response contains '1' params

Examples:
| order  | error_type    |
| none   | missing       |
| tabs   | literal_error |
| spaces | literal_error |
| 0      | literal_error |
| 123    | literal_error |
| ASC    | literal_error |
| DESC   | literal_error |
| RAND   | literal_error |
| rand   | literal_error |

@revision @list
Scenario Outline: List revisions when order is correct
    # list revisions
Given set request header token from global param 'admin_token' 
  And set request query param 'offset' from value '0'
  And set request query param 'limit' from value '1'
  And set request query param 'order_by' from value 'id'
  And set request query param 'order' from value '<order>'
 When send 'GET' request to url 'revisions'
 Then response code is '200'
  And response params contain 'revisions'
  And response params contain 'revisions_count'
  And response contains '2' params

Examples:
| order |
| asc   |
| desc  |

# @revision @list
# Scenario: List revisions when app is locked
#     # lock app
# Given set request header token from global param 'admin_token' 
#  When send 'GET' request to url 'system/lock'
#  Then response code is '200'
#   And response params contain 'is_locked'
#   And response param 'is_locked' equals 'True'
#     # list revisions
# Given set request header token from global param 'admin_token' 
#   And set request query param 'offset' from value '0'
#   And set request query param 'limit' from value '1'
#   And set request query param 'order_by' from value 'id'
#   And set request query param 'order' from value 'asc'
#  When send 'GET' request to url 'revisions'
#  Then response code is '503'
#     # unlock app
# Given set request header token from global param 'admin_token' 
#  When send 'GET' request to url 'system/unlock'
#  Then response code is '200'
#   And response params contain 'is_locked'
#   And response param 'is_locked' equals 'False'
#     # list revisions
# Given set request header token from global param 'admin_token' 
#   And set request query param 'offset' from value '0'
#   And set request query param 'limit' from value '1'
#   And set request query param 'order_by' from value 'id'
#   And set request query param 'order' from value 'asc'
#  When send 'GET' request to url 'revisions'
#  Then response code is '200'
#   And response params contain 'revisions'
#   And response params contain 'revisions_count'
#   And response contains '2' params

@revision @list
Scenario: List revisions when user is admin
    # list revisions
Given set request header token from global param 'admin_token' 
  And set request query param 'offset' from value '0'
  And set request query param 'limit' from value '1'
  And set request query param 'order_by' from value 'id'
  And set request query param 'order' from value 'asc'
 When send 'GET' request to url 'revisions'
 Then response code is '200'
  And response params contain 'revisions'
  And response params contain 'revisions_count'
  And response contains '2' params

@revision @list
Scenario: List revisions when user is editor
    # list revisions
Given set request header token from global param 'editor_token' 
  And set request query param 'offset' from value '0'
  And set request query param 'limit' from value '1'
  And set request query param 'order_by' from value 'id'
  And set request query param 'order' from value 'asc'
 When send 'GET' request to url 'revisions'
 Then response code is '200'
  And response params contain 'revisions'
  And response params contain 'revisions_count'
  And response contains '2' params

@revision @list
Scenario: List revisions when user is writer
    # list revisions
Given set request header token from global param 'writer_token' 
  And set request query param 'offset' from value '0'
  And set request query param 'limit' from value '1'
  And set request query param 'order_by' from value 'id'
  And set request query param 'order' from value 'asc'
 When send 'GET' request to url 'revisions'
 Then response code is '200'
  And response params contain 'revisions'
  And response params contain 'revisions_count'
  And response contains '2' params

@revision @list
Scenario: List revisions when user is reader
    # list revisions
Given set request header token from global param 'reader_token' 
  And set request query param 'offset' from value '0'
  And set request query param 'limit' from value '1'
  And set request query param 'order_by' from value 'id'
  And set request query param 'order' from value 'asc'
 When send 'GET' request to url 'revisions'
 Then response code is '200'
  And response params contain 'revisions'
  And response params contain 'revisions_count'
  And response contains '2' params

@revision @list
Scenario: List revisions when token is missing
    # list revisions
Given delete request header token
  And set request query param 'offset' from value '0'
  And set request query param 'limit' from value '1'
  And set request query param 'order_by' from value 'id'
  And set request query param 'order' from value 'asc'
 When send 'GET' request to url 'revisions'
 Then response code is '403'
