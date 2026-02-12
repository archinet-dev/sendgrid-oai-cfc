<cfscript>
/**
 * Example 4: Email with Attachment
 * 
 * This example demonstrates how to send an email with file attachments.
 * Attachments must be Base64 encoded before sending to SendGrid.
 */

// Create instance of SendGrid component
sendgrid = new SendGrid();

// For this example, we'll create a simple text file and encode it
// In a real scenario, you would read an actual file from disk

// Create sample file content
sampleFileContent = "This is a sample text file attachment.\n\nIt demonstrates how to send attachments via SendGrid.";

// Base64 encode the content
base64Content = toBase64(sampleFileContent);

// Build mail data with attachment
mailData = {
    "personalizations": [{
        "to": [{"email": "recipient@example.com", "name": "John Doe"}],
        "subject": "Document Attached - Please Review"
    }],
    "from": {
        "email": "sender@example.com",
        "name": "Document Service"
    },
    "content": [
        {
            "type": "text/plain",
            "value": "Hello,\n\nPlease find the attached document for your review.\n\nBest regards,\nDocument Service"
        },
        {
            "type": "text/html",
            "value": "<html><body><p>Hello,</p><p>Please find the attached document for your review.</p><p>Best regards,<br><strong>Document Service</strong></p></body></html>"
        }
    ],
    "attachments": [
        {
            "content": base64Content,
            "type": "text/plain",
            "filename": "sample-document.txt",
            "disposition": "attachment"
        }
    ]
};

// Send the email
result = sendgrid.sendMail(mailData);

// Display results
writeOutput("<h2>Email with Attachment Example</h2>");

if (result.success) {
    writeOutput("<div style='background-color: #d4edda; padding: 20px; border-radius: 5px; margin: 20px 0;'>");
    writeOutput("<h3 style='color: #155724;'>✓ Email with Attachment Sent Successfully!</h3>");
    writeOutput("<p><strong>Recipient:</strong> recipient@example.com</p>");
    writeOutput("<p><strong>Attachment:</strong> sample-document.txt (text/plain)</p>");
    writeOutput("<p><strong>Status:</strong> " & result.message & "</p>");
    writeOutput("</div>");
} else {
    writeOutput("<div style='background-color: #f8d7da; padding: 20px; border-radius: 5px; margin: 20px 0;'>");
    writeOutput("<h3 style='color: #721c24;'>✗ Failed to Send Email</h3>");
    writeOutput("<p><strong>Error:</strong> " & result.message & "</p>");
    writeOutput("</div>");
}
</cfscript>

<hr>

<h3>Multiple Attachments Example:</h3>
<pre><code>
// Example with multiple attachments
mailData = {
    "personalizations": [{
        "to": [{"email": "recipient@example.com"}],
        "subject": "Multiple Documents Attached"
    }],
    "from": {"email": "sender@example.com"},
    "content": [{"type": "text/plain", "value": "Please find the documents attached."}],
    "attachments": [
        {
            "content": toBase64(fileRead("/path/to/document1.pdf")),
            "type": "application/pdf",
            "filename": "document1.pdf",
            "disposition": "attachment"
        },
        {
            "content": toBase64(fileRead("/path/to/report.xlsx")),
            "type": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            "filename": "report.xlsx",
            "disposition": "attachment"
        }
    ]
};
</code></pre>

<h3>Inline Images Example:</h3>
<p>For inline images (displayed in the email body), use <code>disposition: "inline"</code> and a <code>content_id</code>:</p>
<pre><code>
mailData = {
    "personalizations": [{
        "to": [{"email": "recipient@example.com"}],
        "subject": "Email with Inline Image"
    }],
    "from": {"email": "sender@example.com"},
    "content": [{
        "type": "text/html",
        "value": "&lt;html&gt;&lt;body&gt;&lt;p&gt;Here is the image:&lt;/p&gt;&lt;img src='cid:logo'&gt;&lt;/body&gt;&lt;/html&gt;"
    }],
    "attachments": [{
        "content": toBase64(fileReadBinary("/path/to/logo.png")),
        "type": "image/png",
        "filename": "logo.png",
        "disposition": "inline",
        "content_id": "logo"
    }]
};
</code></pre>

<div style="background-color: #fff3cd; padding: 15px; border-radius: 5px; margin-top: 20px;">
    <strong>Note:</strong> The total size of all attachments cannot exceed 30MB. Large files should be hosted externally and linked in the email instead.
</div>
