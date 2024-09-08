Feature: Select collection

Background: Authorize users and create collection
Given auth with user role 'admin'
  And auth with user role 'editor'
  And auth with user role 'writer'
  And auth with user role 'reader'
    # Insert collection
Given set request token from global param 'admin_token' 
  And set request param 'is_locked' from value '0'
  And set request param 'collection_name' from fake 'collection_name'
  And set request param 'collection_summary' from fake 'collection_summary'
 When send 'POST' request to url 'collection'
 Then response code is '201'
  And response params contain 'collection_id'
  And save response param 'collection_id' to global param 'collection_id'

@collection @select
Scenario: Select collection when collection_id not found
Given set request token from global param 'reader_token' 
  And set request placeholder 'collection_id' from value '99999999'
 When send 'GET' request to url 'collection/:collection_id'
 Then response code is '404'
  And error loc is 'collection_id'
  And error type is 'resource_not_found'

@collection @select
Scenario: Select collection when user is reader
Given set request token from global param 'reader_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'GET' request to url 'collection/:collection_id'
 Then response code is '200'

@collection @select
Scenario: Select collection when user is writer
Given set request token from global param 'writer_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'GET' request to url 'collection/:collection_id'
 Then response code is '200'

@collection @select
Scenario: Select collection when user is editor
Given set request token from global param 'editor_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'GET' request to url 'collection/:collection_id'
 Then response code is '200'

@collection @select
Scenario: Select collection when user is admin
Given set request token from global param 'admin_token' 
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'GET' request to url 'collection/:collection_id'
 Then response code is '200'

@collection @select
Scenario: Select collection when token is missing
Given delete request token
  And set request placeholder 'collection_id' from global param 'collection_id'
 When send 'GET' request to url 'collection/:collection_id'
 Then response code is '403'
