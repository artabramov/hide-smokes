Feature: List users

Background: Authorize users
Given auth with user role 'admin'
  And auth with user role 'editor'
  And auth with user role 'writer'
  And auth with user role 'reader'

@user @list
Scenario Outline: List users when is_active is invalid
Given set request token from global param 'reader_token' 
  And set request param 'is_active__eq' from value '<is_active>'
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '422'
  And error loc is 'is_active__eq'
  And error type is '<error_type>'

Examples:
| is_active | error_type   |
| tabs      | bool_parsing |
| spaces    | bool_parsing |
| string(0) | bool_parsing |
| yep       | bool_parsing |
| nope      | bool_parsing |
| a         | bool_parsing |
| -1        | bool_parsing |
| 2         | bool_parsing |

@user @list
Scenario Outline: List users when is_active is correct
Given set request token from global param 'reader_token' 
  And set request param 'is_active__eq' from value '<is_active>'
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '200'
  And response params contain 'users'
  And response params contain 'users_count'

Examples:
| is_active |
| none      |
| TRUE      |
| true      |
| FALSE     |
| false     |
| YES       |
| yes       |
| NO        |
| no        |
| Y         |
| y         |
| N         |
| n         |
| 1         |
| 0         |

@user @list
Scenario Outline: List users when user_role is invalid
Given set request token from global param 'reader_token' 
  And set request param 'user_role__eq' from value '<user_role>'
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '422'
  And error loc is 'user_role__eq'
  And error type is '<error_type>'

Examples:
| user_role | error_type |
| tabs      | enum       |
| spaces    | enum       |
| string(0) | enum       |
| string(1) | enum       |
| ADMIN     | enum       |
| EDITOR    | enum       |
| WRITER    | enum       |
| READER    | enum       |

@user @list
Scenario Outline: List users when user_role is correct
Given set request token from global param 'reader_token' 
  And set request param 'user_role__eq' from value '<user_role>'
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '200'
  And response params contain 'users'
  And response params contain 'users_count'

Examples:
| user_role |
| reader    |
| writer    |
| editor    |
| admin     |

@user @list
Scenario: List users when user_login is correct
Given set request token from global param 'reader_token' 
  And set request param 'user_login__ilike' from value 'dummy'
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '200'
  And response params contain 'users'
  And response params contain 'users_count'

@user @list
Scenario: List users when first_name is correct
Given set request token from global param 'reader_token' 
  And set request param 'first_name__ilike' from value 'dummy'
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '200'
  And response params contain 'users'
  And response params contain 'users_count'

@user @list
Scenario: List users when last_name is correct
Given set request token from global param 'reader_token' 
  And set request param 'last_name__ilike' from value 'dummy'
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '200'
  And response params contain 'users'
  And response params contain 'users_count'

@user @list
Scenario Outline: List users when offset is invalid
Given set request token from global param 'reader_token' 
  And set request param 'offset' from value '<offset>'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '422'
  And error loc is 'offset'
  And error type is '<error_type>'

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

@user @list
Scenario Outline: List users when offset is correct
Given set request token from global param 'reader_token' 
  And set request param 'offset' from value '<offset>'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '200'
  And response params contain 'users'
  And response params contain 'users_count'

Examples:
| offset |
| 0      |
| 0.0    |
| 123    |
| 123.0  |
| +123   |

@user @list
Scenario Outline: List users when limit is invalid
Given set request token from global param 'reader_token' 
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '<limit>'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '422'
  And error loc is 'limit'
  And error type is '<error_type>'

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

@user @list
Scenario Outline: List users when limit is correct
Given set request token from global param 'reader_token' 
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '<limit>'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '200'
  And response params contain 'users'
  And response params contain 'users_count'

Examples:
| limit |
| 1     |
| 123   |
| 123.0 |
| +123  |

@user @list
Scenario Outline: List users when order_by is invalid
Given set request token from global param 'reader_token' 
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value '<order_by>'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '422'
  And error loc is 'order_by'
  And error type is '<error_type>'

Examples:
| order_by  | error_type    |
| none      | missing       |
| tabs      | literal_error |
| spaces    | literal_error |
| 0         | literal_error |
| 123       | literal_error |
| string(8) | literal_error |

@user @list
Scenario Outline: List users when order_by is correct
Given set request token from global param 'reader_token' 
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value '<order_by>'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '200'
  And response params contain 'users'
  And response params contain 'users_count'

Examples:
| order_by        |
| id              |
| created_date    |
| updated_date    |
| last_login_date |
| user_role       |
| is_active       |
| user_login      |
| first_name      |
| last_name       |

@user @list
Scenario Outline: List users when order is invalid
Given set request token from global param 'reader_token' 
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value '<order>'
 When send 'GET' request to url 'users'
 Then response code is '422'
  And error loc is 'order'
  And error type is '<error_type>'

Examples:
| order  | error_type    |
| none   | missing       |
| tabs   | literal_error |
| spaces | literal_error |
| 0      | literal_error |
| 123    | literal_error |
| ASC    | literal_error |
| DESC   | literal_error |

@user @list
Scenario Outline: List users when order is correct
Given set request token from global param 'reader_token' 
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value '<order>'
 When send 'GET' request to url 'users'
 Then response code is '200'
  And response params contain 'users'
  And response params contain 'users_count'

Examples:
| order |
| asc   |
| desc  |
| rand  |

@user @list
Scenario Outline: List users when app is locked
    # lock app
Given set request token from global param 'admin_token' 
 When send 'GET' request to url 'system/lock'
 Then response code is '200'
  And response params contain 'is_locked'
  And response param 'is_locked' equals 'True'
    # list users
Given set request token from global param 'admin_token' 
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '503'
    # unlock app
Given set request token from global param 'admin_token' 
 When send 'GET' request to url 'system/unlock'
 Then response code is '200'
  And response params contain 'is_locked'
  And response param 'is_locked' equals 'False'
    # list users
Given set request token from global param 'admin_token' 
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '200'
  And response params contain 'users'
  And response params contain 'users_count'

@user @list
Scenario Outline: List users when user is admin
Given set request token from global param 'admin_token' 
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '200'
  And response params contain 'users'
  And response params contain 'users_count'

@user @list
Scenario Outline: List users when user is editor
Given set request token from global param 'editor_token' 
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '200'
  And response params contain 'users'
  And response params contain 'users_count'

@user @list
Scenario Outline: List users when user is writer
Given set request token from global param 'writer_token' 
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '200'
  And response params contain 'users'
  And response params contain 'users_count'

@user @list
Scenario Outline: List users when user is reader
Given set request token from global param 'reader_token' 
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '200'
  And response params contain 'users'
  And response params contain 'users_count'

@user @list
Scenario Outline: List users when token is missing
Given delete request token 
  And set request param 'offset' from value '0'
  And set request param 'limit' from value '1'
  And set request param 'order_by' from value 'id'
  And set request param 'order' from value 'asc'
 When send 'GET' request to url 'users'
 Then response code is '403'
