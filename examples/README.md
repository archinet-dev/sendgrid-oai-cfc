# SendGrid CFC Examples

This directory contains examples demonstrating how to use the SendGrid CFC to send emails using the SendGrid v3 Mail API.

## Prerequisites

1. **SendGrid API Key**: You need a SendGrid API key. Sign up at [SendGrid](https://sendgrid.com/) to get one.
2. **Environment Variable**: Set the API key as an environment variable:
   ```bash
   export sendgrid_api_key="your_api_key_here"
   ```
   Or configure it in your ColdFusion server's system environment variables.

## Examples Overview

1. **[basic-email.cfm](basic-email.cfm)** - Simple email with plain text and HTML content
2. **[email-with-cc-bcc.cfm](email-with-cc-bcc.cfm)** - Email with CC and BCC recipients
3. **[multiple-recipients.cfm](multiple-recipients.cfm)** - Send to multiple recipients
4. **[email-with-attachment.cfm](email-with-attachment.cfm)** - Email with file attachments
5. **[dynamic-template.cfm](dynamic-template.cfm)** - Using SendGrid dynamic templates
6. **[advanced-features.cfm](advanced-features.cfm)** - Categories, tracking settings, scheduling
7. **[batch-operations.cfm](batch-operations.cfm)** - Creating and using batch IDs

## Basic Usage

### Simple Email Helper

The `sendSimpleEmail()` function provides an easy interface for common scenarios:

```cfscript
sendgrid = new SendGrid();

result = sendgrid.sendSimpleEmail(
    toEmail = "recipient@example.com",
    toName = "John Doe",
    fromEmail = "sender@example.com",
    fromName = "My Company",
    subject = "Hello from SendGrid!",
    textContent = "This is the plain text version.",
    htmlContent = "<p>This is the <strong>HTML</strong> version.</p>"
);

if (result.success) {
    writeOutput("Email sent successfully!");
} else {
    writeOutput("Error: " & result.message);
}
```

### Advanced Mail API

The `sendMail()` function gives you full control over the SendGrid v3 Mail API:

```cfscript
sendgrid = new SendGrid();

mailData = {
    "personalizations": [{
        "to": [
            {"email": "recipient1@example.com", "name": "Recipient 1"},
            {"email": "recipient2@example.com", "name": "Recipient 2"}
        ],
        "cc": [{"email": "cc@example.com", "name": "CC Recipient"}],
        "subject": "Hello from SendGrid!"
    }],
    "from": {"email": "sender@example.com", "name": "My Company"},
    "content": [
        {"type": "text/plain", "value": "Plain text content"},
        {"type": "text/html", "value": "<p>HTML content</p>"}
    ]
};

result = sendgrid.sendMail(mailData);
```

## Response Structure

All functions return a struct with the following fields:

- `success` (boolean) - Whether the operation was successful
- `statusCode` (numeric) - HTTP status code from SendGrid API
- `message` (string) - Success or error message
- `errors` (array, optional) - Array of error objects if the request failed

Example success response:
```json
{
    "success": true,
    "statusCode": 202,
    "message": "Email accepted for delivery"
}
```

Example error response:
```json
{
    "success": false,
    "statusCode": 400,
    "message": "Email send failed: The from email does not contain a valid address.",
    "errors": [
        {
            "message": "The from email does not contain a valid address.",
            "field": "from.email"
        }
    ]
}
```

## API Key Security

**Important:** Never hardcode your API key in your code. Always use environment variables or secure configuration management.

For ColdFusion, the CFC looks for the API key in `server.system.environment.sendgrid_api_key`.

## Further Reading

- [SendGrid v3 Mail Send API Documentation](https://docs.sendgrid.com/api-reference/mail-send/mail-send)
- [SendGrid Personalizations Documentation](https://docs.sendgrid.com/for-developers/sending-email/personalizations)
- [SendGrid Dynamic Templates](https://docs.sendgrid.com/ui/sending-email/how-to-send-an-email-with-dynamic-templates)
