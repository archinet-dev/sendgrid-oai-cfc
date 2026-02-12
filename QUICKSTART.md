# SendGrid CFC Quick Start Guide

Get started with the SendGrid ColdFusion Component in 5 minutes!

## Step 1: Get Your SendGrid API Key

1. Sign up for a free SendGrid account at [https://sendgrid.com/](https://sendgrid.com/)
2. Navigate to Settings → API Keys
3. Click "Create API Key"
4. Give it a name (e.g., "ColdFusion Integration")
5. Select "Full Access" or at minimum "Mail Send" permissions
6. Copy the API key (you'll only see it once!)

## Step 2: Set Environment Variable

Set the API key as an environment variable on your ColdFusion server:

### On Linux/Mac:
```bash
export sendgrid_api_key="YOUR_API_KEY_HERE"
```

### On Windows:
```cmd
set sendgrid_api_key=YOUR_API_KEY_HERE
```

### In ColdFusion Administrator:
1. Go to Server Settings → Java and JVM
2. Add to JVM Arguments: `-Dsendgrid_api_key=YOUR_API_KEY_HERE`
3. Restart ColdFusion

## Step 3: Copy SendGrid.cfc to Your Application

Copy `SendGrid.cfc` to your ColdFusion application directory, for example:
```
/myapp/components/SendGrid.cfc
```

## Step 4: Send Your First Email

Create a test page (e.g., `test-email.cfm`):

```cfscript
<cfscript>
// Create instance of SendGrid component
sendgrid = new SendGrid();

// Send a simple test email
result = sendgrid.sendSimpleEmail(
    toEmail = "your-email@example.com",  // Change to your email
    toName = "Your Name",
    fromEmail = "test@yourdomain.com",   // Must be verified in SendGrid
    fromName = "Test Sender",
    subject = "Test Email from SendGrid CFC",
    textContent = "This is a test email sent via SendGrid CFC!",
    htmlContent = "<h1>Success!</h1><p>This is a test email sent via SendGrid CFC!</p>"
);

// Display result
if (result.success) {
    writeOutput("<h2 style='color: green;'>✓ Success!</h2>");
    writeOutput("<p>Email sent successfully!</p>");
    writeOutput("<p>Check your inbox at: your-email@example.com</p>");
} else {
    writeOutput("<h2 style='color: red;'>✗ Error</h2>");
    writeOutput("<p>Failed to send email.</p>");
    writeOutput("<p><strong>Error:</strong> " & result.message & "</p>");
}
</cfscript>
```

## Step 5: Run and Test

1. Access your test page in a browser: `http://localhost/test-email.cfm`
2. If successful, you should see a green success message
3. Check your email inbox for the test message

## Troubleshooting

### Error: "SendGrid API key not found"
- Make sure the environment variable is set correctly
- Restart ColdFusion after setting the variable
- Verify with: `<cfdump var="#server.system.environment.sendgrid_api_key#">`

### Error: "The from email does not contain a valid address"
- The from email must be verified in your SendGrid account
- Go to Settings → Sender Authentication in SendGrid
- Verify a single sender or domain

### Error: "authorization required"
- Your API key may be invalid or expired
- Create a new API key with "Mail Send" permissions
- Make sure the API key has no extra spaces or characters

### No Email Received
- Check your spam/junk folder
- Verify the to/from addresses are correct
- Check SendGrid's Activity Feed in the dashboard for delivery status
- Make sure you haven't hit your sending quota (free tier: 100 emails/day)

## Next Steps

Now that you have basic email working, explore more features:

1. **Send to Multiple Recipients** - See [examples/multiple-recipients.cfm](examples/multiple-recipients.cfm)
2. **Add Attachments** - See [examples/email-with-attachment.cfm](examples/email-with-attachment.cfm)
3. **Use Dynamic Templates** - See [examples/dynamic-template.cfm](examples/dynamic-template.cfm)
4. **Track Opens and Clicks** - See [examples/advanced-features.cfm](examples/advanced-features.cfm)

## Production Checklist

Before deploying to production:

- [ ] Store API key securely (environment variable, not in code)
- [ ] Verify your domain in SendGrid (better deliverability)
- [ ] Set up proper error handling and logging
- [ ] Test all email templates and content
- [ ] Configure unsubscribe management
- [ ] Set up webhook event handling (optional)
- [ ] Monitor sending limits and quotas
- [ ] Review SendGrid's email best practices

## Common Use Cases

### Welcome Email
```cfscript
sendgrid.sendSimpleEmail(
    toEmail = newUser.email,
    toName = newUser.name,
    fromEmail = "welcome@yourcompany.com",
    fromName = "Your Company",
    subject = "Welcome to " & application.name,
    htmlContent = renderTemplate("welcome-email", {user: newUser})
);
```

### Password Reset
```cfscript
sendgrid.sendSimpleEmail(
    toEmail = user.email,
    fromEmail = "security@yourcompany.com",
    subject = "Password Reset Request",
    htmlContent = "<p>Click here to reset: <a href='#resetLink#'>#resetLink#</a></p>"
);
```

### Order Confirmation
```cfscript
mailData = {
    "personalizations": [{
        "to": [{"email": order.customerEmail}],
        "dynamic_template_data": {
            "order_number": order.id,
            "order_total": order.total,
            "items": order.items
        }
    }],
    "from": {"email": "orders@yourcompany.com"},
    "template_id": "d-your-template-id"
};
sendgrid.sendMail(mailData);
```

## Resources

- [SendGrid CFC Documentation](README.md)
- [Example Files](examples/)
- [SendGrid API Docs](https://docs.sendgrid.com/api-reference/mail-send/mail-send)
- [SendGrid Best Practices](https://docs.sendgrid.com/ui/sending-email/deliverability)
- [Changes and Migration Guide](CHANGES.md)

## Need Help?

- Check the [examples/](examples/) directory for working code
- Review [CHANGES.md](CHANGES.md) for migration from old version
- Visit [SendGrid Support](https://support.sendgrid.com/)
- Check SendGrid's Activity Feed for delivery issues

Happy sending! 📧
