# Changes to SendGrid CFC

This document summarizes the changes made to update the SendGrid CFC to be compatible with the SendGrid v3 Mail API specification.

## Summary

The SendGrid.cfc component has been completely refactored to align with the official SendGrid v3 Mail API specification. The previous implementation had several issues that prevented it from working correctly with the SendGrid API, including incorrect JSON structure for CC/BCC recipients and the presence of unrelated database functions.

## Major Changes

### 1. Fixed API Structure Issues

**Before:**
```javascript
// INCORRECT: CC and BCC were objects at root level
{
    "personalizations": [...],
    "from": {...},
    "cc": {"email": "cc@example.com", "name": "CC Name"},  // ❌ Wrong location
    "bcc": {"email": "bcc@example.com", "name": "BCC Name"}, // ❌ Wrong location
    "subject": "..."
}
```

**After:**
```javascript
// CORRECT: CC and BCC are arrays within personalizations
{
    "personalizations": [{
        "to": [{"email": "to@example.com"}],
        "cc": [{"email": "cc@example.com"}],  // ✅ Correct location and format
        "bcc": [{"email": "bcc@example.com"}] // ✅ Correct location and format
    }],
    "from": {"email": "from@example.com"}
}
```

### 2. Removed Malformed JSON

The original file contained a 106-line JSON comment/example (lines 57-163) that was not properly closed and corrupted the cfhttpparam body value. This has been completely removed.

### 3. Removed Unrelated Functions

Removed two functions that were not related to SendGrid:
- `getTableData()` - Database query function for project users
- `getDocumentsData()` - Database query function for documents

These functions were specific to a particular application and should not be in a general-purpose SendGrid component.

### 4. Added Full v3 API Support

#### New `sendMail()` Function
- Accepts full SendGrid v3 API mail data structure
- Supports all v3 API features:
  - Multiple recipients (to, cc, bcc)
  - Attachments (files and inline images)
  - Dynamic templates and substitutions
  - Categories and custom arguments
  - Tracking settings (open, click, subscription)
  - Mail settings (sandbox mode, bypass list management)
  - Scheduled sending
  - Batch operations
- Proper JSON serialization of complex structures
- Comprehensive error handling and response parsing

#### New `sendSimpleEmail()` Helper Function
- Simplified interface for common use cases
- Single recipient support (one to, one cc, one bcc)
- Backwards-compatible parameter names
- Internally converts to proper v3 API structure
- Calls `sendMail()` for consistency

#### New Batch Operation Functions
- `createBatchId()` - Generate batch IDs for grouping emails
- `validateBatchId()` - Validate a batch ID

### 5. Improved Error Handling

**Before:**
```cfscript
// Minimal error information
return {
    'status': "error",
    'error' = {
        'code' = 500,
        'message' = e.message
    }
};
```

**After:**
```cfscript
// Comprehensive error response with SendGrid error details
return {
    "success": false,
    "statusCode": 400,
    "message": "Email send failed: The from email does not contain a valid address.",
    "errors": [
        {
            "message": "The from email does not contain a valid address.",
            "field": "from.email",
            "help": {...}
        }
    ]
};
```

### 6. Better Environment Variable Handling

**Before:**
```cfscript
var sendGridAPIKey = server.system.environment.sendgrid_api_key;
// Would throw error if variable doesn't exist
```

**After:**
```cfscript
// Safe checking with clear error message
if (structKeyExists(server, "system") && 
    structKeyExists(server.system, "environment") && 
    structKeyExists(server.system.environment, "sendgrid_api_key")) {
    sendGridAPIKey = server.system.environment.sendgrid_api_key;
} else {
    throw(type="SendGrid.MissingAPIKey", 
          message="SendGrid API key not found in server.system.environment.sendgrid_api_key");
}
```

### 7. Improved Logging

**Before:**
```cfscript
writeLog(text = "Email Sent", type = "information", file = "SendMailCFC");
```

**After:**
```cfscript
writeLog(text="Email sent successfully via SendGrid", type="information", file="SendGrid");
// Detailed error logging with full context
```

## New Examples Directory

Created comprehensive examples demonstrating all features:

1. **basic-email.cfm** - Simple email sending with text and HTML content
2. **email-with-cc-bcc.cfm** - Using CC and BCC recipients correctly
3. **multiple-recipients.cfm** - Sending to multiple recipients at once
4. **email-with-attachment.cfm** - Adding file attachments and inline images
5. **dynamic-template.cfm** - Using SendGrid dynamic templates with Handlebars
6. **advanced-features.cfm** - Categories, tracking settings, scheduling, custom args
7. **batch-operations.cfm** - Creating and using batch IDs for bulk operations

Each example includes:
- Working code with proper error handling
- Detailed comments explaining the functionality
- HTML output showing success/failure
- Additional code snippets for variations
- Best practices and tips

## Documentation Updates

### README.md
- Complete rewrite focusing on the CFC functionality
- Quick start guide with code examples
- Comprehensive API method documentation
- Response structure documentation
- Links to examples and SendGrid documentation
- Installation and setup instructions

### examples/README.md
- Detailed overview of all examples
- Basic usage patterns
- API key security best practices
- Response structure explanation
- Links to SendGrid official documentation

## Breaking Changes

The following changes break backwards compatibility:

1. **Function Name Change**: `sendEmail()` → Use `sendSimpleEmail()` or `sendMail()`
2. **Parameter Changes**: While `sendSimpleEmail()` maintains similar parameters, the old function had hardcoded default values that are no longer present
3. **Response Structure**: New consistent response format with `success`, `statusCode`, `message` fields
4. **Removed Functions**: `getTableData()` and `getDocumentsData()` no longer exist

## Migration Guide

### Old Code:
```cfscript
sendmail = new SendMail();
result = sendmail.sendEmail(
    toEmail = "user@example.com",
    fromEmail = "sender@example.com",
    subject = "Test",
    message = "Plain text",
    htmlMessage = "<p>HTML</p>"
);
```

### New Code (Option 1 - Simple):
```cfscript
sendgrid = new SendGrid();
result = sendgrid.sendSimpleEmail(
    toEmail = "user@example.com",
    fromEmail = "sender@example.com",
    subject = "Test",
    textContent = "Plain text",
    htmlContent = "<p>HTML</p>"
);
```

### New Code (Option 2 - Full API):
```cfscript
sendgrid = new SendGrid();
mailData = {
    "personalizations": [{
        "to": [{"email": "user@example.com"}],
        "subject": "Test"
    }],
    "from": {"email": "sender@example.com"},
    "content": [
        {"type": "text/plain", "value": "Plain text"},
        {"type": "text/html", "value": "<p>HTML</p>"}
    ]
};
result = sendgrid.sendMail(mailData);
```

## Testing

Manual testing is required with an actual SendGrid API key. The examples provide a comprehensive test suite that can be executed to verify:

1. Basic email sending
2. CC/BCC functionality
3. Multiple recipients
4. Attachments
5. Templates
6. Tracking and analytics
7. Batch operations

Set the environment variable and run each example CFM file to test.

## References

- [SendGrid v3 Mail API Documentation](https://docs.sendgrid.com/api-reference/mail-send/mail-send)
- [SendGrid Personalizations](https://docs.sendgrid.com/for-developers/sending-email/personalizations)
- [SendGrid Dynamic Templates](https://docs.sendgrid.com/ui/sending-email/how-to-send-an-email-with-dynamic-templates)
- [SendGrid OAI Specification](spec/yaml/tsg_mail_v3.yaml)
