<cfscript>
/**
 * Example 2: Email with CC and BCC
 * 
 * This example demonstrates how to send an email with CC and BCC recipients
 * using the sendSimpleEmail helper function.
 */

// Create instance of SendGrid component
sendgrid = new SendGrid();

// Send email with CC and BCC
result = sendgrid.sendSimpleEmail(
    toEmail = "recipient@example.com",
    toName = "Primary Recipient",
    fromEmail = "sender@example.com",
    fromName = "My Company",
    ccEmail = "cc-recipient@example.com",
    ccName = "CC Recipient",
    bccEmail = "bcc-recipient@example.com",
    bccName = "BCC Recipient",
    subject = "Meeting Notes - Q1 Planning",
    textContent = "Hi Team, Please find the meeting notes attached. The CC recipient will see they are copied, but the BCC recipient will receive a copy without others knowing.",
    htmlContent = "<html><body><h2>Meeting Notes</h2><p>Hi Team,</p><p>Please find the meeting notes for our Q1 planning session.</p><ul><li>CC recipient will see they are copied</li><li>BCC recipient receives a copy without others knowing</li></ul></body></html>",
    replyToEmail = "noreply@example.com",
    replyToName = "No Reply"
);

// Display results
writeOutput("<h2>Email with CC and BCC</h2>");

if (result.success) {
    writeOutput("<div style='color: green;'>");
    writeOutput("<h3>✓ Success!</h3>");
    writeOutput("<p>Email sent to: recipient@example.com</p>");
    writeOutput("<p>CC: cc-recipient@example.com</p>");
    writeOutput("<p>BCC: bcc-recipient@example.com (hidden from other recipients)</p>");
    writeOutput("<p>Status: " & result.message & "</p>");
    writeOutput("</div>");
} else {
    writeOutput("<div style='color: red;'>");
    writeOutput("<h3>✗ Failed</h3>");
    writeOutput("<p>Error: " & result.message & "</p>");
    writeOutput("</div>");
}
</cfscript>
