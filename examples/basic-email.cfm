<cfscript>
/**
 * Example 1: Basic Email
 * 
 * This example demonstrates how to send a simple email with both
 * plain text and HTML content using the sendSimpleEmail helper function.
 */

// Create instance of SendGrid component
sendgrid = new SendGrid();

// Send a basic email
result = sendgrid.sendSimpleEmail(
    toEmail = "recipient@example.com",
    toName = "John Doe",
    fromEmail = "sender@example.com",
    fromName = "My Company",
    subject = "Welcome to SendGrid!",
    textContent = "Hello John! Welcome to our service. This is the plain text version of the email.",
    htmlContent = "<html><body><h1>Welcome!</h1><p>Hello <strong>John</strong>!</p><p>Welcome to our service. This is the HTML version of the email.</p></body></html>"
);

// Check result
if (result.success) {
    writeOutput("<h2>Success!</h2>");
    writeOutput("<p>Email sent successfully!</p>");
    writeOutput("<p>Status Code: " & result.statusCode & "</p>");
    writeOutput("<p>Message: " & result.message & "</p>");
} else {
    writeOutput("<h2>Error</h2>");
    writeOutput("<p>Failed to send email.</p>");
    writeOutput("<p>Status Code: " & result.statusCode & "</p>");
    writeOutput("<p>Error Message: " & result.message & "</p>");
    
    // Display detailed errors if available
    if (structKeyExists(result, "errors") && arrayLen(result.errors) > 0) {
        writeOutput("<h3>Detailed Errors:</h3><ul>");
        for (error in result.errors) {
            writeOutput("<li>");
            if (structKeyExists(error, "field")) {
                writeOutput("<strong>Field:</strong> " & error.field & " - ");
            }
            if (structKeyExists(error, "message")) {
                writeOutput(error.message);
            }
            writeOutput("</li>");
        }
        writeOutput("</ul>");
    }
}
</cfscript>
