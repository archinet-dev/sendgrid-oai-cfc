<cfscript>
/**
 * Example 6: Advanced Features
 * 
 * This example demonstrates advanced SendGrid features including:
 * - Categories (for tracking and analytics)
 * - Custom arguments (metadata that travels with your email)
 * - Tracking settings (open tracking, click tracking)
 * - Mail settings (bypass list management, sandbox mode)
 * - Scheduled sending (send_at timestamp)
 */

// Create instance of SendGrid component
sendgrid = new SendGrid();

// Calculate send time (e.g., 1 hour from now)
scheduledTime = dateAdd("h", 1, now());
sendAtTimestamp = dateDiff("s", createDateTime(1970, 1, 1, 0, 0, 0), scheduledTime);

// Build mail data with advanced features
mailData = {
    "personalizations": [{
        "to": [{"email": "recipient@example.com", "name": "John Doe"}],
        "subject": "Your Monthly Newsletter - February 2026",
        "custom_args": {
            "campaign_id": "newsletter-feb-2026",
            "user_id": "12345",
            "segment": "premium-users"
        },
        "send_at": sendAtTimestamp  // Schedule for 1 hour from now
    }],
    "from": {
        "email": "newsletter@example.com",
        "name": "Example Newsletter"
    },
    "reply_to": {
        "email": "support@example.com",
        "name": "Customer Support"
    },
    "content": [
        {
            "type": "text/plain",
            "value": "Hello! Welcome to our February newsletter. Click the link to view online."
        },
        {
            "type": "text/html",
            "value": "<html><body><h1>February Newsletter</h1><p>Hello!</p><p>Welcome to our February newsletter.</p><p><a href='https://example.com/newsletter/feb-2026'>View Online</a></p></body></html>"
        }
    ],
    "categories": [
        "newsletter",
        "monthly",
        "premium-users"
    ],
    "tracking_settings": {
        "click_tracking": {
            "enable": true,
            "enable_text": false  // Only track clicks in HTML, not plain text
        },
        "open_tracking": {
            "enable": true,
            "substitution_tag": "%open-track%"
        },
        "subscription_tracking": {
            "enable": false
        }
    },
    "mail_settings": {
        "bypass_list_management": {
            "enable": false  // Respect unsubscribe lists
        },
        "footer": {
            "enable": false
        },
        "sandbox_mode": {
            "enable": false  // Set to true for testing without actually sending
        }
    }
};

// Send the email
result = sendgrid.sendMail(mailData);

// Display results
writeOutput("<h2>Advanced Features Example</h2>");

if (result.success) {
    writeOutput("<div style='background-color: #d4edda; padding: 20px; border-radius: 5px;'>");
    writeOutput("<h3 style='color: #155724;'>✓ Advanced Email Scheduled Successfully!</h3>");
    writeOutput("<p><strong>Recipient:</strong> recipient@example.com</p>");
    writeOutput("<p><strong>Scheduled Send Time:</strong> " & dateFormat(scheduledTime, "yyyy-mm-dd") & " " & timeFormat(scheduledTime, "HH:mm:ss") & "</p>");
    writeOutput("<p><strong>Categories:</strong> newsletter, monthly, premium-users</p>");
    writeOutput("<p><strong>Custom Arguments:</strong></p>");
    writeOutput("<ul>");
    writeOutput("<li>Campaign ID: newsletter-feb-2026</li>");
    writeOutput("<li>User ID: 12345</li>");
    writeOutput("<li>Segment: premium-users</li>");
    writeOutput("</ul>");
    writeOutput("<p><strong>Tracking Settings:</strong></p>");
    writeOutput("<ul>");
    writeOutput("<li>Click Tracking: Enabled (HTML only)</li>");
    writeOutput("<li>Open Tracking: Enabled</li>");
    writeOutput("<li>Subscription Tracking: Disabled</li>");
    writeOutput("</ul>");
    writeOutput("<p><strong>Status:</strong> " & result.message & "</p>");
    writeOutput("</div>");
} else {
    writeOutput("<div style='background-color: #f8d7da; padding: 20px; border-radius: 5px;'>");
    writeOutput("<h3 style='color: #721c24;'>✗ Failed to Send Email</h3>");
    writeOutput("<p><strong>Error:</strong> " & result.message & "</p>");
    writeOutput("</div>");
}
</cfscript>

<hr>

<h3>Feature Explanations:</h3>

<h4>1. Categories</h4>
<p>Categories help you organize and track emails in SendGrid's analytics. You can assign up to 10 categories per email.</p>
<pre><code>
"categories": ["newsletter", "monthly", "premium-users"]
</code></pre>

<h4>2. Custom Arguments</h4>
<p>Custom arguments are metadata that travels with your email and appears in webhook events. Use them to track user IDs, campaign IDs, or any custom data.</p>
<pre><code>
"custom_args": {
    "campaign_id": "newsletter-feb-2026",
    "user_id": "12345"
}
</code></pre>

<h4>3. Scheduled Sending</h4>
<p>Schedule emails for future delivery (up to 72 hours in advance) using Unix timestamps.</p>
<pre><code>
// Send 2 hours from now
scheduledTime = dateAdd("h", 2, now());
sendAtTimestamp = dateDiff("s", createDateTime(1970, 1, 1, 0, 0, 0), scheduledTime);

"send_at": sendAtTimestamp
</code></pre>

<h4>4. Tracking Settings</h4>
<p>Control how SendGrid tracks opens and clicks:</p>
<ul>
    <li><strong>Click Tracking:</strong> Tracks when recipients click links in your email</li>
    <li><strong>Open Tracking:</strong> Tracks when recipients open your email (using a tracking pixel)</li>
    <li><strong>Subscription Tracking:</strong> Automatically adds unsubscribe links</li>
</ul>

<h4>5. Mail Settings</h4>
<ul>
    <li><strong>Sandbox Mode:</strong> Test email sending without actually delivering emails</li>
    <li><strong>Bypass List Management:</strong> Send to suppressed addresses (use carefully)</li>
    <li><strong>Footer:</strong> Automatically append a footer to emails</li>
</ul>

<div style="background-color: #fff3cd; padding: 15px; border-radius: 5px; margin-top: 20px;">
    <strong>Testing Tip:</strong> Use <code>"sandbox_mode": {"enable": true}</code> to test your emails without actually sending them. SendGrid will validate the request and return a success response, but won't deliver the email.
</div>

<h3>Sandbox Mode Example:</h3>
<pre><code>
// Test mode - no emails actually sent
mailData = {
    // ... other properties ...
    "mail_settings": {
        "sandbox_mode": {
            "enable": true  // Validate only, don't send
        }
    }
};
</code></pre>
