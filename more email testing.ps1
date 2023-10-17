### Ask for credentials
 
$username = Read-Host 'Enter e-mail address'
$password = Read-Host "Enter password of $username" -AsSecureString
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $password
$subject = 'Alert: Test!'
$body = 'This is for testing purposes'
 
### Splatting with Hash Table
 
$hash = @{
 
To = 'evan.stueve@countryfinancial.com'
From = $username
Subject = $subject
Body = $body
BodyAsHtml = $true
SmtpServer = 'smtp.office365.com'
UseSSL = $true
Credential = $cred
Port = 587 #587 #25
 
}
 
### Send Mail
 
Send-MailMessage @hash -WarningAction Ignore

#this all failed