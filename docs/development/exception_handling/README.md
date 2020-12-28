# Exception Handling

In order to funnel and create a chokepoint for error reporting we utilize the
`Errors::Reporter` class. This will report expected errors to our error 
reporting / bugtracking tools. It would be great to expand this reporter to
take in some optional session info as well and log the bug / reports and create
issues automatically for users that admins can check out to see if there was
an impact.
