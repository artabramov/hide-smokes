Feature: Delete userpic

Background: Authorize users
Given auth with user role 'admin'
  And auth with user role 'editor'
  And auth with user role 'writer'
  And auth with user role 'reader'

@user @userpic @delete
Scenario: Upload userpic when user_id is invalid
Given set request token from global param 'admin_token' 
  And set request placeholder 'user_id' from global param 'reader_id'
 When send 'DELETE' request to url 'user/:user_id/userpic'
 Then response code is '403'
  And error loc is 'user_id'
  And error type is 'resource_forbidden'

@user @userpic @delete
Scenario: Upload userpic when user is admin
Given set request token from global param 'admin_token' 
  And set request placeholder 'user_id' from global param 'admin_id'
 When send 'DELETE' request to url 'user/:user_id/userpic'
 Then response code is '200'
  And response params contain 'user_id'

@user @userpic @delete
Scenario: Upload userpic when user is editor
Given set request token from global param 'editor_token' 
  And set request placeholder 'user_id' from global param 'editor_id'
 When send 'DELETE' request to url 'user/:user_id/userpic'
 Then response code is '200'
  And response params contain 'user_id'

@user @userpic @delete
Scenario: Upload userpic when user is writer
Given set request token from global param 'writer_token' 
  And set request placeholder 'user_id' from global param 'writer_id'
 When send 'DELETE' request to url 'user/:user_id/userpic'
 Then response code is '200'
  And response params contain 'user_id'

@user @userpic @delete
Scenario: Upload userpic when user is reader
Given set request token from global param 'reader_token' 
  And set request placeholder 'user_id' from global param 'reader_id'
 When send 'DELETE' request to url 'user/:user_id/userpic'
 Then response code is '200'
  And response params contain 'user_id'

@user @userpic @delete
Scenario: Upload userpic when token is missing
Given delete request token 
  And set request placeholder 'user_id' from global param 'reader_id'
 When send 'DELETE' request to url 'user/:user_id/userpic'
 Then response code is '403'