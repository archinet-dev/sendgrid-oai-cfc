<cfscript>
/**
 * Example 5: Dynamic Template
 * 
 * This example demonstrates how to send an email using a SendGrid Dynamic Template.
 * Dynamic templates allow you to create email designs in SendGrid's UI and
 * populate them with dynamic data at send time using Handlebars syntax.
 * 
 * Prerequisites:
 * 1. Create a Dynamic Template in SendGrid (starts with "d-")
 * 2. Add dynamic content using Handlebars (e.g., {{name}}, {{order_id}})
 */

// Create instance of SendGrid component
sendgrid = new SendGrid();

// Build mail data with dynamic template
mailData = {
    "personalizations": [{
        "to": [{"email": "recipient@example.com", "name": "John Doe"}],
        "dynamic_template_data": {
            "name": "John",
            "order_id": "123456",
            "order_total": "$99.99",
            "order_items": [
                {"name": "Product A", "quantity": 2, "price": "$29.99"},
                {"name": "Product B", "quantity": 1, "price": "$40.01"}
            ],
            "delivery_date": "February 15, 2026",
            "tracking_url": "https://example.com/track/123456"
        }
    }],
    "from": {
        "email": "orders@example.com",
        "name": "Example Shop"
    },
    "template_id": "d-1234567890abcdef1234567890abcdef" // Replace with your template ID
};

// Send the email
result = sendgrid.sendMail(mailData);

// Display results
writeOutput("<h2>Dynamic Template Example</h2>");

if (result.success) {
    writeOutput("<div style='background-color: #d4edda; padding: 20px; border-radius: 5px;'>");
    writeOutput("<h3 style='color: #155724;'>✓ Template Email Sent Successfully!</h3>");
    writeOutput("<p><strong>Recipient:</strong> John Doe (recipient@example.com)</p>");
    writeOutput("<p><strong>Template ID:</strong> d-1234567890abcdef1234567890abcdef</p>");
    writeOutput("<p><strong>Dynamic Data Sent:</strong></p>");
    writeOutput("<ul>");
    writeOutput("<li>Name: John</li>");
    writeOutput("<li>Order ID: 123456</li>");
    writeOutput("<li>Order Total: $99.99</li>");
    writeOutput("<li>Delivery Date: February 15, 2026</li>");
    writeOutput("</ul>");
    writeOutput("<p><strong>Status:</strong> " & result.message & "</p>");
    writeOutput("</div>");
} else {
    writeOutput("<div style='background-color: #f8d7da; padding: 20px; border-radius: 5px;'>");
    writeOutput("<h3 style='color: #721c24;'>✗ Failed to Send Template Email</h3>");
    writeOutput("<p><strong>Error:</strong> " & result.message & "</p>");
    
    if (structKeyExists(result, "errors") && arrayLen(result.errors) > 0) {
        writeOutput("<p><strong>Detailed Errors:</strong></p><ul>");
        for (error in result.errors) {
            writeOutput("<li>" & error.message & "</li>");
        }
        writeOutput("</ul>");
    }
    writeOutput("</div>");
}
</cfscript>

<hr>

<h3>How to Create a Dynamic Template:</h3>
<ol>
    <li>Log in to your SendGrid account</li>
    <li>Navigate to Email API &gt; Dynamic Templates</li>
    <li>Click "Create a Dynamic Template"</li>
    <li>Give it a name and click "Create"</li>
    <li>Click "Add Version" and select a design option</li>
    <li>Use the editor to design your email with Handlebars placeholders</li>
    <li>Save and note the Template ID (starts with "d-")</li>
</ol>

<h3>Example Template Handlebars Syntax:</h3>
<pre><code>
&lt;!-- In your SendGrid template: --&gt;
&lt;h1&gt;Hello {{name}}!&lt;/h1&gt;
&lt;p&gt;Your order #{{order_id}} has been confirmed.&lt;/p&gt;
&lt;p&gt;Total: {{order_total}}&lt;/p&gt;

&lt;h2&gt;Order Items:&lt;/h2&gt;
&lt;ul&gt;
{{#each order_items}}
  &lt;li&gt;{{this.name}} - Qty: {{this.quantity}} - {{this.price}}&lt;/li&gt;
{{/each}}
&lt;/ul&gt;

&lt;p&gt;Estimated delivery: {{delivery_date}}&lt;/p&gt;
&lt;p&gt;&lt;a href="{{tracking_url}}"&gt;Track your order&lt;/a&gt;&lt;/p&gt;
</code></pre>

<h3>Alternative: Legacy Templates (Substitution Tags)</h3>
<p>For older SendGrid templates (IDs that don't start with "d-"), use <code>substitutions</code> instead:</p>
<pre><code>
mailData = {
    "personalizations": [{
        "to": [{"email": "recipient@example.com"}],
        "substitutions": {
            "-name-": "John",
            "-order_id-": "123456"
        }
    }],
    "from": {"email": "sender@example.com"},
    "template_id": "abc123-def456" // Legacy template ID
};
</code></pre>

<div style="background-color: #d1ecf1; padding: 15px; border-radius: 5px; margin-top: 20px;">
    <strong>Tip:</strong> Dynamic templates are more powerful and flexible than legacy templates. 
    They support Handlebars syntax for conditionals, loops, and complex data structures.
</div>
