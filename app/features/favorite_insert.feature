Feature: Insert favorite

Background: Auth users and upload a datafile
    # auth users
Given auth with user role 'admin'
  And auth with user role 'editor'
  And auth with user role 'writer'
  And auth with user role 'reader'
    # upload datafile
Given set request header token from global param 'admin_token' 
  And set request file from sample format 'pdf'
 When send 'POST' request to url 'datafile'
 Then response code is '201'
  And response params contain 'datafile_id'
  And response params contain 'revision_id'
  And response contains '2' params
  And save response param 'datafile_id' to global param 'datafile_id'
    # remove file from request
Given delete request file

@favorite @insert
Scenario Outline: Insert favorite when datafile_id is not found
    # insert favorite
Given set request header token from global param 'admin_token' 
  And set request body param 'datafile_id' from value '<datafile_id>'
 When send 'POST' request to url 'favorite'
 Then response code is '404'
  And error loc is 'body' and 'datafile_id'
  And error type is 'resource_not_found'
  And response contains '1' params
    # delete datafile
Given set request header token from global param 'admin_token' 
  And set request path param 'datafile_id' from global param 'datafile_id'
 When send 'DELETE' request to url 'datafile/:datafile_id'
 Then response code is '200'
  And response params contain 'datafile_id'
  And response contains '1' params
  

Examples:
| datafile_id |
| 0           |
| -1          |
| 9999999999  |

@favorite @insert
Scenario: Insert favorite when app is locked
    # create lock
Given set request header token from global param 'admin_token' 
 When send 'POST' request to url 'lock'
 Then response code is '200'
  And response params contain 'is_locked'
  And response param 'is_locked' equals 'True'
  And response contains '1' params
    # insert favorite
Given set request header token from global param 'admin_token' 
  And set request body param 'datafile_id' from global param 'datafile_id'
 When send 'POST' request to url 'favorite'
 Then response code is '423'
    # delete lock
Given set request header token from global param 'admin_token' 
 When send 'DELETE' request to url 'lock'
 Then response code is '200'
  And response params contain 'is_locked'
  And response param 'is_locked' equals 'False'
  And response contains '1' params
    # insert favorite
Given set request header token from global param 'admin_token' 
  And set request body param 'datafile_id' from global param 'datafile_id'
 When send 'POST' request to url 'favorite'
 Then response code is '201'
  And response params contain 'favorite_id'
  And response contains '1' params
    # delete datafile
Given set request header token from global param 'admin_token' 
  And set request path param 'datafile_id' from global param 'datafile_id'
 When send 'DELETE' request to url 'datafile/:datafile_id'
 Then response code is '200'
  And response params contain 'datafile_id'
  And response contains '1' params

@favorite @insert
Scenario: Insert favorite when user is admin
    # insert favorite
Given set request header token from global param 'admin_token' 
  And set request body param 'datafile_id' from global param 'datafile_id'
 When send 'POST' request to url 'favorite'
 Then response code is '201'
  And response params contain 'favorite_id'
  And response contains '1' params
    # delete datafile
Given set request header token from global param 'admin_token' 
  And set request path param 'datafile_id' from global param 'datafile_id'
 When send 'DELETE' request to url 'datafile/:datafile_id'
 Then response code is '200'
  And response params contain 'datafile_id'
  And response contains '1' params

@favorite @insert
Scenario: Insert favorite when user is editor
    # insert favorite
Given set request header token from global param 'editor_token' 
  And set request body param 'datafile_id' from global param 'datafile_id'
 When send 'POST' request to url 'favorite'
 Then response code is '201'
  And response params contain 'favorite_id'
  And response contains '1' params
    # delete datafile
Given set request header token from global param 'admin_token' 
  And set request path param 'datafile_id' from global param 'datafile_id'
 When send 'DELETE' request to url 'datafile/:datafile_id'
 Then response code is '200'
  And response params contain 'datafile_id'
  And response contains '1' params

@favorite @insert
Scenario: Insert favorite when user is writer
    # insert favorite
Given set request header token from global param 'writer_token' 
  And set request body param 'datafile_id' from global param 'datafile_id'
 When send 'POST' request to url 'favorite'
 Then response code is '201'
  And response params contain 'favorite_id'
  And response contains '1' params
    # delete datafile
Given set request header token from global param 'admin_token' 
  And set request path param 'datafile_id' from global param 'datafile_id'
 When send 'DELETE' request to url 'datafile/:datafile_id'
 Then response code is '200'
  And response params contain 'datafile_id'
  And response contains '1' params

@favorite @insert
Scenario: Insert favorite when user is reader
    # insert favorite
Given set request header token from global param 'reader_token' 
  And set request body param 'datafile_id' from global param 'datafile_id'
 When send 'POST' request to url 'favorite'
 Then response code is '201'
  And response params contain 'favorite_id'
  And response contains '1' params
    # delete datafile
Given set request header token from global param 'admin_token' 
  And set request path param 'datafile_id' from global param 'datafile_id'
 When send 'DELETE' request to url 'datafile/:datafile_id'
 Then response code is '200'
  And response params contain 'datafile_id'
  And response contains '1' params

@favorite @insert
Scenario: Insert favorite when token is missing
    # insert favorite
Given delete request header token
  And set request body param 'datafile_id' from global param 'datafile_id'
 When send 'POST' request to url 'favorite'
 Then response code is '403'
    # delete datafile
Given set request header token from global param 'admin_token' 
  And set request path param 'datafile_id' from global param 'datafile_id'
 When send 'DELETE' request to url 'datafile/:datafile_id'
 Then response code is '200'
  And response params contain 'datafile_id'
  And response contains '1' params
