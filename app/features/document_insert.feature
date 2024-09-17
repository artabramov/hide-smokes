Feature: Insert document

Background: Authorize users
    # auth users
Given auth with user role 'admin'
  And auth with user role 'editor'
  And auth with user role 'writer'
  And auth with user role 'reader'
    # insert collection
Given set request token from global param 'admin_token' 
  And set request param 'is_locked' from value '0'
  And set request param 'collection_name' from fake 'collection_name'
 When send 'POST' request to url 'collection'
 Then response code is '201'
  And response params contain 'collection_id'
  And save response param 'collection_id' to global param 'collection_id'

@document @insert
Scenario Outline: Insert document when collection_id not found
    # insert document
Given set request token from global param 'admin_token' 
  And set request param 'collection_id' from value '<collection_id>'
  And set request param 'document_name' from fake 'document_name'
  And set request param 'document_summary' from fake 'document_summary'
  And set request param 'tags' from fake 'document_tags'
  And set request file from sample format 'pdf'
 When send 'POST' request to url 'document'
 Then response code is '404'
  And error loc is 'collection_id'
  And error type is 'resource_not_found'
    # delete collection
Given set request token from global param 'admin_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'DELETE' request to url 'collection/:collection_id'
 Then response code is '200'
  And response params contain 'collection_id'

Examples:
| collection_id |
| 0             |
| -1            |
| 9999999999    |

@document @insert
Scenario Outline: Insert document when collection_id is invalid
    # insert document
Given set request token from global param 'admin_token' 
  And set request param 'collection_id' from value '<collection_id>'
  And set request param 'document_name' from fake 'document_name'
  And set request param 'document_summary' from fake 'document_summary'
  And set request param 'tags' from fake 'document_tags'
  And set request file from sample format 'pdf'
 When send 'POST' request to url 'document'
 Then response code is '422'
  And error loc is 'collection_id'
  And error type is '<error_type>'
    # delete collection
Given set request token from global param 'admin_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'DELETE' request to url 'collection/:collection_id'
 Then response code is '200'
  And response params contain 'collection_id'

Examples:
| collection_id | error_type  |
| none          | missing     |
| tabs          | int_parsing |
| spaces        | int_parsing |
| string(0)     | int_parsing |
| string(1)     | int_parsing |
| 123.5         | int_parsing |
| 123,0         | int_parsing |

@document @insert
Scenario Outline: Insert document when document_name is invalid
    # insert document
Given set request token from global param 'admin_token' 
  And set request param 'collection_id' from global param 'collection_id'
  And set request param 'document_name' from value '<document_name>'
  And set request param 'document_summary' from fake 'document_summary'
  And set request param 'tags' from fake 'document_tags'
  And set request file from sample format 'pdf'
 When send 'POST' request to url 'document'
 Then response code is '422'
  And error loc is 'document_name'
  And error type is '<error_type>'
    # delete collection
Given set request token from global param 'admin_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'DELETE' request to url 'collection/:collection_id'
 Then response code is '200'
  And response params contain 'collection_id'

Examples:
| document_name | error_type      |
| string(257)   | string_too_long |

@document @insert
Scenario Outline: Insert document when document_name is correct or missing
    # insert document
Given set request token from global param 'admin_token' 
  And set request param 'collection_id' from global param 'collection_id'
  And set request param 'document_name' from value '<document_name>'
  And set request param 'document_summary' from fake 'document_summary'
  And set request param 'tags' from fake 'document_tags'
  And set request file from sample format 'pdf'
 When send 'POST' request to url 'document'
 Then response code is '201'
  And response params contain 'document_id'
  And response params contain 'revision_id'
  And response contains '2' params
    # delete collection
Given set request token from global param 'admin_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'DELETE' request to url 'collection/:collection_id'
 Then response code is '200'
  And response params contain 'collection_id'

Examples:
| document_name |
| none          |
| tabs          |
| spaces        |
| string(0)     |
| string(1)     |
| string(256)   |

@document @insert
Scenario Outline: Insert document when document_summary is invalid
    # insert document
Given set request token from global param 'admin_token' 
  And set request param 'collection_id' from global param 'collection_id'
  And set request param 'document_name' from fake 'document_name'
  And set request param 'document_summary' from value '<document_summary>'
  And set request param 'tags' from fake 'document_tags'
  And set request file from sample format 'pdf'
 When send 'POST' request to url 'document'
 Then response code is '422'
  And error loc is 'document_summary'
  And error type is '<error_type>'
    # delete collection
Given set request token from global param 'admin_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'DELETE' request to url 'collection/:collection_id'
 Then response code is '200'
  And response params contain 'collection_id'

Examples:
| document_summary | error_type      |
| string(513)      | string_too_long |

@document @insert
Scenario Outline: Insert document when document_summary is correct
    # insert document
Given set request token from global param 'admin_token' 
  And set request param 'collection_id' from global param 'collection_id'
  And set request param 'document_name' from fake 'document_name'
  And set request param 'document_summary' from value '<document_summary>'
  And set request param 'tags' from fake 'document_tags'
  And set request file from sample format 'pdf'
 When send 'POST' request to url 'document'
 Then response code is '201'
  And response params contain 'document_id'
  And response params contain 'revision_id'
  And response contains '2' params
    # delete collection
Given set request token from global param 'admin_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'DELETE' request to url 'collection/:collection_id'
 Then response code is '200'
  And response params contain 'collection_id'

Examples:
| document_summary |
| none             |
| tabs             |
| spaces           |
| string(0)        |
| string(1)        |
| string(512)      |

@document @insert
Scenario: Insert document when collection is locked
    # lock collection
Given set request token from global param 'admin_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
  And set request param 'is_locked' from value '1'
  And set request param 'collection_name' from fake 'collection_name'
 When send 'PUT' request to url 'collection/:collection_id'
 Then response code is '200'
  And response params contain 'collection_id'
    # insert document
Given set request token from global param 'admin_token' 
  And set request param 'collection_id' from global param 'collection_id'
  And set request param 'document_name' from fake 'document_name'
  And set request param 'document_summary' from fake 'document_summary'
  And set request param 'tags' from fake 'document_tags'
  And set request file from sample format 'pdf'
 When send 'POST' request to url 'document'
 Then response code is '423'
  And error loc is 'collection_id'
  And error type is 'resource_locked'
    # delete collection
Given set request token from global param 'admin_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'DELETE' request to url 'collection/:collection_id'
 Then response code is '200'
  And response params contain 'collection_id'

@document @insert
Scenario: Insert document when app is locked
    # lock app
Given set request token from global param 'admin_token' 
 When send 'GET' request to url 'system/lock'
 Then response code is '200'
  And response params contain 'is_locked'
  And response param 'is_locked' equals 'True'
    # insert document
Given set request token from global param 'admin_token' 
  And set request param 'collection_id' from global param 'collection_id'
  And set request param 'document_name' from fake 'document_name'
  And set request param 'document_summary' from fake 'document_summary'
  And set request param 'tags' from fake 'document_tags'
  And set request file from sample format 'pdf'
 When send 'POST' request to url 'document'
 Then response code is '503'
    # unlock app
Given set request token from global param 'admin_token' 
 When send 'GET' request to url 'system/unlock'
 Then response code is '200'
  And response params contain 'is_locked'
  And response param 'is_locked' equals 'False'
    # insert document
Given set request token from global param 'admin_token' 
  And set request param 'collection_id' from global param 'collection_id'
  And set request param 'document_name' from fake 'document_name'
  And set request param 'document_summary' from fake 'document_summary'
  And set request param 'tags' from fake 'document_tags'
  And set request file from sample format 'pdf'
 When send 'POST' request to url 'document'
 Then response code is '201'
  And response params contain 'document_id'
  And response params contain 'revision_id'
    # delete collection
Given set request token from global param 'admin_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'DELETE' request to url 'collection/:collection_id'
 Then response code is '200'
  And response params contain 'collection_id'

@document @insert
Scenario: Insert document when user is admin
    # insert document
Given set request token from global param 'admin_token' 
  And set request param 'collection_id' from global param 'collection_id'
  And set request param 'document_name' from fake 'document_name'
  And set request param 'document_summary' from fake 'document_summary'
  And set request param 'tags' from fake 'document_tags'
  And set request file from sample format 'pdf'
 When send 'POST' request to url 'document'
 Then response code is '201'
  And response params contain 'document_id'
  And response params contain 'revision_id'
  And response contains '2' params
    # delete collection
Given set request token from global param 'admin_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'DELETE' request to url 'collection/:collection_id'
 Then response code is '200'
  And response params contain 'collection_id'

@document @insert
Scenario: Insert document when user is editor
    # insert document
Given set request token from global param 'editor_token' 
  And set request param 'collection_id' from global param 'collection_id'
  And set request param 'document_name' from fake 'document_name'
  And set request param 'document_summary' from fake 'document_summary'
  And set request param 'tags' from fake 'document_tags'
  And set request file from sample format 'pdf'
 When send 'POST' request to url 'document'
 Then response code is '201'
  And response params contain 'document_id'
  And response params contain 'revision_id'
  And response contains '2' params
    # delete collection
Given set request token from global param 'admin_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'DELETE' request to url 'collection/:collection_id'
 Then response code is '200'
  And response params contain 'collection_id'

@document @insert
Scenario: Insert document when user is writer
    # insert document
Given set request token from global param 'writer_token' 
  And set request param 'collection_id' from global param 'collection_id'
  And set request param 'document_name' from fake 'document_name'
  And set request param 'document_summary' from fake 'document_summary'
  And set request param 'tags' from fake 'document_tags'
  And set request file from sample format 'pdf'
 When send 'POST' request to url 'document'
 Then response code is '201'
  And response params contain 'document_id'
  And response params contain 'revision_id'
  And response contains '2' params
    # delete collection
Given set request token from global param 'admin_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'DELETE' request to url 'collection/:collection_id'
 Then response code is '200'
  And response params contain 'collection_id'

@document @insert
Scenario: Insert document when user is reader
    # insert document
Given set request token from global param 'reader_token' 
  And set request param 'collection_id' from global param 'collection_id'
  And set request param 'document_name' from fake 'document_name'
  And set request param 'document_summary' from fake 'document_summary'
  And set request param 'tags' from fake 'document_tags'
  And set request file from sample format 'pdf'
 When send 'POST' request to url 'document'
 Then response code is '403'
  And error loc is 'user_token'
  And error type is 'user_rejected'
    # delete collection
Given set request token from global param 'admin_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'DELETE' request to url 'collection/:collection_id'
 Then response code is '200'
  And response params contain 'collection_id'

@document @insert
Scenario: Insert document when token is missing
    # insert document
Given delete request token
  And set request param 'collection_id' from global param 'collection_id'
  And set request param 'document_name' from fake 'document_name'
  And set request param 'document_summary' from fake 'document_summary'
  And set request param 'tags' from fake 'document_tags'
  And set request file from sample format 'pdf'
 When send 'POST' request to url 'document'
 Then response code is '403'
    # delete collection
Given set request token from global param 'admin_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'DELETE' request to url 'collection/:collection_id'
 Then response code is '200'
  And response params contain 'collection_id'
