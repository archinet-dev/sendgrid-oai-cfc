<cfscript>
/**
 * Example 7: Batch Operations
 * 
 * This example demonstrates how to use batch IDs to group email sends together.
 * Batch IDs allow you to:
 * - Group related emails together
 * - Schedule multiple emails with the same send time
 * - Cancel or pause scheduled emails by batch ID
 * 
 * Use cases:
 * - Bulk newsletter sending
 * - Campaign management
 * - Scheduled notification batches
 */

// Create instance of SendGrid component
sendgrid = new SendGrid();

writeOutput("<h2>Batch Operations Example</h2>");

// Step 1: Create a batch ID
writeOutput("<h3>Step 1: Creating Batch ID</h3>");
batchResult = sendgrid.createBatchId();

if (batchResult.success) {
    batchId = batchResult.batch_id;
    
    writeOutput("<div style='background-color: #d4edda; padding: 15px; border-radius: 5px; margin: 10px 0;'>");
    writeOutput("<p>✓ Batch ID created successfully</p>");
    writeOutput("<p><strong>Batch ID:</strong> <code>" & batchId & "</code></p>");
    writeOutput("</div>");
    
    // Step 2: Validate the batch ID
    writeOutput("<h3>Step 2: Validating Batch ID</h3>");
    validateResult = sendgrid.validateBatchId(batchId);
    
    if (validateResult.valid) {
        writeOutput("<div style='background-color: #d4edda; padding: 15px; border-radius: 5px; margin: 10px 0;'>");
        writeOutput("<p>✓ Batch ID is valid</p>");
        writeOutput("</div>");
        
        // Step 3: Send emails using the batch ID
        writeOutput("<h3>Step 3: Sending Emails with Batch ID</h3>");
        
        // Calculate send time (2 hours from now)
        scheduledTime = dateAdd("h", 2, now());
        sendAtTimestamp = dateDiff("s", createDateTime(1970, 1, 1, 0, 0, 0), scheduledTime);
        
        // Send first email in batch
        mailData1 = {
            "personalizations": [{
                "to": [{"email": "user1@example.com", "name": "User 1"}],
                "subject": "Campaign Newsletter - Part of Batch"
            }],
            "from": {"email": "campaigns@example.com", "name": "Campaign Manager"},
            "content": [{
                "type": "text/html",
                "value": "<p>This is the first email in the batch.</p>"
            }],
            "batch_id": batchId,
            "send_at": sendAtTimestamp
        };
        
        result1 = sendgrid.sendMail(mailData1);
        
        // Send second email in batch
        mailData2 = {
            "personalizations": [{
                "to": [{"email": "user2@example.com", "name": "User 2"}],
                "subject": "Campaign Newsletter - Part of Batch"
            }],
            "from": {"email": "campaigns@example.com", "name": "Campaign Manager"},
            "content": [{
                "type": "text/html",
                "value": "<p>This is the second email in the batch.</p>"
            }],
            "batch_id": batchId,
            "send_at": sendAtTimestamp
        };
        
        result2 = sendgrid.sendMail(mailData2);
        
        // Send third email in batch
        mailData3 = {
            "personalizations": [{
                "to": [{"email": "user3@example.com", "name": "User 3"}],
                "subject": "Campaign Newsletter - Part of Batch"
            }],
            "from": {"email": "campaigns@example.com", "name": "Campaign Manager"},
            "content": [{
                "type": "text/html",
                "value": "<p>This is the third email in the batch.</p>"
            }],
            "batch_id": batchId,
            "send_at": sendAtTimestamp
        };
        
        result3 = sendgrid.sendMail(mailData3);
        
        // Display batch results
        if (result1.success && result2.success && result3.success) {
            writeOutput("<div style='background-color: #d4edda; padding: 15px; border-radius: 5px; margin: 10px 0;'>");
            writeOutput("<p>✓ All 3 emails scheduled successfully in batch!</p>");
            writeOutput("<p><strong>Batch ID:</strong> <code>" & batchId & "</code></p>");
            writeOutput("<p><strong>Scheduled Send Time:</strong> " & dateFormat(scheduledTime, "yyyy-mm-dd") & " " & timeFormat(scheduledTime, "HH:mm:ss") & "</p>");
            writeOutput("<p><strong>Recipients:</strong></p>");
            writeOutput("<ul>");
            writeOutput("<li>user1@example.com</li>");
            writeOutput("<li>user2@example.com</li>");
            writeOutput("<li>user3@example.com</li>");
            writeOutput("</ul>");
            writeOutput("<p><strong>Note:</strong> You can cancel this batch before it sends using the Cancel Scheduled Sends API with batch ID: " & batchId & "</p>");
            writeOutput("</div>");
        } else {
            writeOutput("<div style='background-color: #f8d7da; padding: 15px; border-radius: 5px; margin: 10px 0;'>");
            writeOutput("<p>✗ Some emails failed to schedule</p>");
            writeOutput("<ul>");
            if (!result1.success) writeOutput("<li>Email 1: " & result1.message & "</li>");
            if (!result2.success) writeOutput("<li>Email 2: " & result2.message & "</li>");
            if (!result3.success) writeOutput("<li>Email 3: " & result3.message & "</li>");
            writeOutput("</ul>");
            writeOutput("</div>");
        }
    } else {
        writeOutput("<div style='background-color: #f8d7da; padding: 15px; border-radius: 5px; margin: 10px 0;'>");
        writeOutput("<p>✗ Batch ID validation failed</p>");
        writeOutput("<p>" & validateResult.message & "</p>");
        writeOutput("</div>");
    }
} else {
    writeOutput("<div style='background-color: #f8d7da; padding: 15px; border-radius: 5px; margin: 10px 0;'>");
    writeOutput("<p>✗ Failed to create batch ID</p>");
    writeOutput("<p>" & batchResult.message & "</p>");
    writeOutput("</div>");
}
</cfscript>

<hr>

<h3>Benefits of Using Batch IDs:</h3>
<ul>
    <li><strong>Group Management:</strong> Manage multiple emails as a single unit</li>
    <li><strong>Bulk Scheduling:</strong> Schedule many emails to send at the same time</li>
    <li><strong>Cancellation:</strong> Cancel all emails in a batch with a single API call</li>
    <li><strong>Pause/Resume:</strong> Pause and resume scheduled batches</li>
    <li><strong>Analytics:</strong> Track performance of related emails together</li>
</ul>

<h3>How to Cancel a Batch:</h3>
<p>To cancel a scheduled batch, you would use the Cancel Scheduled Sends API (not included in this CFC, but available via direct API call):</p>
<pre><code>
// Cancel batch using cURL (outside of this CFC)
curl --request POST \
  --url https://api.sendgrid.com/v3/user/scheduled_sends \
  --header 'Authorization: Bearer YOUR_API_KEY' \
  --header 'Content-Type: application/json' \
  --data '{
    "batch_id": "YOUR_BATCH_ID",
    "status": "cancel"
  }'
</code></pre>

<h3>Best Practices:</h3>
<ol>
    <li><strong>Create a new batch ID for each campaign</strong> - Don't reuse batch IDs</li>
    <li><strong>Store batch IDs</strong> - Keep track of batch IDs in your database for later reference</li>
    <li><strong>Schedule wisely</strong> - Emails can only be scheduled up to 72 hours in advance</li>
    <li><strong>Test first</strong> - Use sandbox mode to test batch operations before sending real emails</li>
    <li><strong>Monitor status</strong> - Check the status of scheduled batches before they send</li>
</ol>

<div style="background-color: #d1ecf1; padding: 15px; border-radius: 5px; margin-top: 20px;">
    <strong>Tip:</strong> Batch IDs are most useful for scheduled sends. For immediate sends, they provide less value unless you're using them for analytics grouping.
</div>

<h3>Code Summary:</h3>
<pre><code>
// 1. Create batch ID
batchResult = sendgrid.createBatchId();
batchId = batchResult.batch_id;

// 2. Validate batch ID (optional)
validateResult = sendgrid.validateBatchId(batchId);

// 3. Send emails with batch ID
mailData = {
    // ... email properties ...
    "batch_id": batchId,
    "send_at": scheduledTimestamp
};

result = sendgrid.sendMail(mailData);
</code></pre>
