<cfscript>
/**
 * Example 3: Multiple Recipients
 * 
 * This example demonstrates how to send an email to multiple recipients
 * using the full sendMail API. Each recipient in the 'to' array will
 * receive the same email and can see the other recipients.
 */

// Create instance of SendGrid component
sendgrid = new SendGrid();

// Build mail data with multiple recipients
mailData = {
    "personalizations": [{
        "to": [
            {"email": "recipient1@example.com", "name": "Alice Smith"},
            {"email": "recipient2@example.com", "name": "Bob Johnson"},
            {"email": "recipient3@example.com", "name": "Carol Williams"}
        ],
        "cc": [
            {"email": "manager@example.com", "name": "Manager"}
        ],
        "subject": "Team Update - Project Alpha"
    }],
    "from": {
        "email": "sender@example.com",
        "name": "Project Coordinator"
    },
    "reply_to": {
        "email": "project-alpha@example.com",
        "name": "Project Alpha Team"
    },
    "content": [
        {
            "type": "text/plain",
            "value": "Hello Team,\n\nThis is an update on Project Alpha. All team members are receiving this email.\n\nBest regards,\nProject Coordinator"
        },
        {
            "type": "text/html",
            "value": "<html><body><h2>Team Update</h2><p>Hello Team,</p><p>This is an update on <strong>Project Alpha</strong>. All team members are receiving this email.</p><p>Best regards,<br>Project Coordinator</p></body></html>"
        }
    ],
    "categories": ["project-alpha", "team-updates"]
};

// Send the email
result = sendgrid.sendMail(mailData);

// Display results
writeOutput("<h2>Multiple Recipients Example</h2>");

if (result.success) {
    writeOutput("<div style='background-color: #d4edda; padding: 20px; border-radius: 5px;'>");
    writeOutput("<h3 style='color: #155724;'>✓ Email Sent Successfully!</h3>");
    writeOutput("<p><strong>Recipients:</strong></p>");
    writeOutput("<ul>");
    writeOutput("<li>Alice Smith (recipient1@example.com)</li>");
    writeOutput("<li>Bob Johnson (recipient2@example.com)</li>");
    writeOutput("<li>Carol Williams (recipient3@example.com)</li>");
    writeOutput("</ul>");
    writeOutput("<p><strong>CC:</strong> Manager (manager@example.com)</p>");
    writeOutput("<p><strong>Status Code:</strong> " & result.statusCode & "</p>");
    writeOutput("<p><strong>Message:</strong> " & result.message & "</p>");
    writeOutput("</div>");
} else {
    writeOutput("<div style='background-color: #f8d7da; padding: 20px; border-radius: 5px;'>");
    writeOutput("<h3 style='color: #721c24;'>✗ Failed to Send Email</h3>");
    writeOutput("<p><strong>Status Code:</strong> " & result.statusCode & "</p>");
    writeOutput("<p><strong>Error:</strong> " & result.message & "</p>");
    
    if (structKeyExists(result, "errors") && arrayLen(result.errors) > 0) {
        writeOutput("<p><strong>Detailed Errors:</strong></p><ul>");
        for (error in result.errors) {
            writeOutput("<li>");
            if (structKeyExists(error, "field")) {
                writeOutput("<strong>" & error.field & ":</strong> ");
            }
            if (structKeyExists(error, "message")) {
                writeOutput(error.message);
            }
            writeOutput("</li>");
        }
        writeOutput("</ul>");
    }
    writeOutput("</div>");
}
</cfscript>

<hr>

<h3>Code Example:</h3>
<pre><code>
sendgrid = new SendGrid();

mailData = {
    "personalizations": [{
        "to": [
            {"email": "recipient1@example.com", "name": "Alice Smith"},
            {"email": "recipient2@example.com", "name": "Bob Johnson"},
            {"email": "recipient3@example.com", "name": "Carol Williams"}
        ],
        "cc": [{"email": "manager@example.com", "name": "Manager"}],
        "subject": "Team Update - Project Alpha"
    }],
    "from": {"email": "sender@example.com", "name": "Project Coordinator"},
    "content": [
        {"type": "text/plain", "value": "Plain text content..."},
        {"type": "text/html", "value": "&lt;html&gt;HTML content...&lt;/html&gt;"}
    ]
};

result = sendgrid.sendMail(mailData);
</code></pre>
