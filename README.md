# SendGrid ColdFusion Component (CFC)

This repository provides a ColdFusion Component (CFC) for integrating with the SendGrid v3 Mail API, along with OpenAPI specification files.

## 📧 SendGrid.cfc

A comprehensive ColdFusion Component for sending emails via the [SendGrid v3 Mail API](https://docs.sendgrid.com/api-reference/mail-send/mail-send). This CFC provides both simple and advanced email sending capabilities with full support for the latest SendGrid v3 API features.

### Features

- ✅ **Full v3 API Support** - Complete implementation of SendGrid v3 Mail API
- ✅ **Simple & Advanced Interfaces** - Easy-to-use helper functions plus full API control
- ✅ **Multiple Recipients** - Support for multiple To, CC, and BCC recipients
- ✅ **Rich Content** - Plain text and HTML email content
- ✅ **Attachments** - Send files as attachments or inline images
- ✅ **Dynamic Templates** - Use SendGrid's dynamic templates with Handlebars
- ✅ **Scheduling** - Schedule emails for future delivery (up to 72 hours)
- ✅ **Batch Operations** - Group emails with batch IDs for bulk management
- ✅ **Tracking & Analytics** - Categories, custom arguments, open/click tracking
- ✅ **Comprehensive Error Handling** - Detailed error responses and logging

### Installation

1. Copy `SendGrid.cfc` to your ColdFusion application
2. Set your SendGrid API key as an environment variable:
   ```bash
   export sendgrid_api_key="your_api_key_here"
   ```
   Or configure it in your ColdFusion server's system environment variables as `sendgrid_api_key`

### Quick Start

```cfscript
// Create instance
sendgrid = new SendGrid();

// Send a simple email
result = sendgrid.sendSimpleEmail(
    toEmail = "recipient@example.com",
    toName = "John Doe",
    fromEmail = "sender@example.com",
    fromName = "My Company",
    subject = "Hello from SendGrid!",
    textContent = "This is the plain text content.",
    htmlContent = "<p>This is the <strong>HTML</strong> content.</p>"
);

if (result.success) {
    writeOutput("Email sent successfully!");
} else {
    writeOutput("Error: " & result.message);
}
```

### Examples

Comprehensive examples are available in the [examples/](examples/) directory:

- **[basic-email.cfm](examples/basic-email.cfm)** - Simple email with plain text and HTML
- **[email-with-cc-bcc.cfm](examples/email-with-cc-bcc.cfm)** - Email with CC and BCC recipients
- **[multiple-recipients.cfm](examples/multiple-recipients.cfm)** - Send to multiple recipients
- **[email-with-attachment.cfm](examples/email-with-attachment.cfm)** - Sending file attachments
- **[dynamic-template.cfm](examples/dynamic-template.cfm)** - Using SendGrid dynamic templates
- **[advanced-features.cfm](examples/advanced-features.cfm)** - Categories, tracking, scheduling
- **[batch-operations.cfm](examples/batch-operations.cfm)** - Batch IDs and bulk operations

See the [examples README](examples/README.md) for detailed documentation.

### API Methods

#### sendSimpleEmail()

Simple helper function for common email scenarios with single recipients:

```cfscript
result = sendgrid.sendSimpleEmail(
    toEmail = "recipient@example.com",      // Required
    toName = "Recipient Name",              // Optional
    fromEmail = "sender@example.com",       // Required
    fromName = "Sender Name",               // Optional
    subject = "Email Subject",              // Required
    textContent = "Plain text content",     // Optional (one content type required)
    htmlContent = "<p>HTML content</p>",    // Optional (one content type required)
    ccEmail = "cc@example.com",             // Optional
    ccName = "CC Name",                     // Optional
    bccEmail = "bcc@example.com",           // Optional
    bccName = "BCC Name",                   // Optional
    replyToEmail = "reply@example.com",     // Optional
    replyToName = "Reply Name"              // Optional
);
```

#### sendMail()

Full control over the SendGrid v3 Mail API with support for all features:

```cfscript
mailData = {
    "personalizations": [{
        "to": [{"email": "recipient@example.com", "name": "Name"}],
        "cc": [{"email": "cc@example.com"}],
        "bcc": [{"email": "bcc@example.com"}],
        "subject": "Subject"
    }],
    "from": {"email": "sender@example.com", "name": "Sender"},
    "content": [
        {"type": "text/plain", "value": "Plain text"},
        {"type": "text/html", "value": "<p>HTML</p>"}
    ],
    "attachments": [{
        "content": toBase64(fileContent),
        "filename": "file.pdf",
        "type": "application/pdf"
    }],
    "categories": ["newsletter", "monthly"],
    "tracking_settings": {
        "click_tracking": {"enable": true},
        "open_tracking": {"enable": true}
    }
};

result = sendgrid.sendMail(mailData);
```

#### createBatchId()

Create a batch ID for grouping email sends:

```cfscript
batchResult = sendgrid.createBatchId();
if (batchResult.success) {
    batchId = batchResult.batch_id;
}
```

#### validateBatchId()

Validate a batch ID:

```cfscript
validateResult = sendgrid.validateBatchId(batchId);
if (validateResult.valid) {
    // Batch ID is valid
}
```

### Response Structure

All methods return a struct with:

```cfscript
{
    "success": true/false,           // Boolean indicating success
    "statusCode": 202,               // HTTP status code
    "message": "Success message",    // Descriptive message
    "errors": []                     // Array of error objects (if failed)
}
```

## 📚 OpenAPI Specification

This repository also contains [OpenAPI](https://www.openapis.org/) specification documents for the SendGrid API.

The SendGrid OAI specifications are automatically generated from the SendGrid OAS specifications using the `sendgrid-oas-transpiler`. 

The `sendgrid-oai` is utilized to auto-generate SendGrid helper libraries through the `sendgrid-oai-generator`.

Specification files can be found in the `spec/json/` and `spec/yaml/` directories.

### What is OpenAPI?

From the [OpenAPI Specification](https://github.com/OAI/OpenAPI-Specification):

> The OpenAPI Specification (OAS) defines a standard, programming language-agnostic interface document for HTTP APIs, which allows both humans and computers to discover and understand the capabilities of a service without requiring access to source code, additional documentation, or inspection of network traffic. When properly defined via OpenAPI, a consumer can understand and interact with the remote service with a minimal amount of implementation logic. Similar to what interface documentation have done for lower-level programming, the OpenAPI Specification removes guesswork in calling a service.

## Project Status

This project is currently in **Beta**. We expect the spec to be accurate, and it is currently in **active development**. If you've identified a mismatch between SendGrid's API behavior and this specification, [please open an issue](https://github.com/twilio/sendgrid-oai/issues/new).

## Requirements

- ColdFusion 10+ or Lucee 4.5+
- SendGrid API key
- Internet connection to SendGrid API endpoints

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

See [LICENSE](LICENSE) file for details.

## Support

- [SendGrid Documentation](https://docs.sendgrid.com/)
- [SendGrid API Reference](https://docs.sendgrid.com/api-reference)
- [SendGrid Support](https://support.sendgrid.com/)

## Related Projects

- [SendGrid Official Libraries](https://github.com/sendgrid)
- [SendGrid OAI Specification](https://github.com/twilio/sendgrid-oai)


