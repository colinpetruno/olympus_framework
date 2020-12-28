# SessionInfo

`Members::SessionInfo` is a class used to wrap up the required information to
do most of the authentication and permissions heavylifting. It is created by
giving the member object to `SessionInfo`. It will then ensure to effectively
cache the relevant permissions and other objects often needed like `Company`
and `Account`.

