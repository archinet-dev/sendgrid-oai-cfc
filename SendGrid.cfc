component displayname="SendGrid" hint="CFC for sending email via SendGrid v3 Mail API" output="false" {
    
    /**
     * Send an email using SendGrid v3 Mail API
     * 
     * @mailData      [struct]  - Complete mail data structure following SendGrid v3 API spec
     * 
     * Example mailData structure:
     * {
     *   "personalizations": [{
     *     "to": [{"email": "recipient@example.com", "name": "Recipient Name"}],
     *     "cc": [{"email": "cc@example.com", "name": "CC Name"}],
     *     "bcc": [{"email": "bcc@example.com", "name": "BCC Name"}],
     *     "subject": "Email Subject"
     *   }],
     *   "from": {"email": "sender@example.com", "name": "Sender Name"},
     *   "reply_to": {"email": "reply@example.com", "name": "Reply Name"},
     *   "content": [
     *     {"type": "text/plain", "value": "Plain text content"},
     *     {"type": "text/html", "value": "<p>HTML content</p>"}
     *   ]
     * }
     */
    public struct function sendMail(required struct mailData) output="false" {
        try {
            // Get SendGrid API key from environment variable
            var sendGridAPIKey = "";
            if (structKeyExists(server, "system") && structKeyExists(server.system, "environment") && structKeyExists(server.system.environment, "sendgrid_api_key")) {
                sendGridAPIKey = server.system.environment.sendgrid_api_key;
            } else {
                throw(type="SendGrid.MissingAPIKey", message="SendGrid API key not found in server.system.environment.sendgrid_api_key");
            }
            
            // Validate required mailData structure
            if (!structKeyExists(arguments.mailData, "personalizations") || !isArray(arguments.mailData.personalizations) || arrayLen(arguments.mailData.personalizations) == 0) {
                throw(type="SendGrid.InvalidMailData", message="mailData must contain a personalizations array with at least one personalization");
            }
            
            if (!structKeyExists(arguments.mailData, "from") || !structKeyExists(arguments.mailData.from, "email")) {
                throw(type="SendGrid.InvalidMailData", message="mailData must contain a from object with an email address");
            }
            
            // Convert mailData struct to JSON
            var jsonBody = serializeJSON(arguments.mailData);
            
            // Make HTTP request to SendGrid API
            var result = {};
            cfhttp(
                method = "POST",
                url    = "https://api.sendgrid.com/v3/mail/send",
                result = "result",
                timeout = "30"
            ) {
                cfhttpparam(type="header", name="Authorization", value="Bearer #sendGridAPIKey#");
                cfhttpparam(type="header", name="Content-Type", value="application/json");
                cfhttpparam(type="body", value="#jsonBody#");
            }
            
            // Parse response
            var statusCode = val(result.responseHeader["Status_Code"]);
            
            // Success: SendGrid returns 202 Accepted with empty body on success
            if (statusCode == 202) {
                writeLog(text="Email sent successfully via SendGrid", type="information", file="SendGrid");
                return {
                    "success": true,
                    "statusCode": 202,
                    "message": "Email accepted for delivery"
                };
            } else {
                // Error response
                var errorMessage = "Email send failed with status code #statusCode#";
                var errors = [];
                
                if (len(result.fileContent)) {
                    try {
                        var errorData = deserializeJSON(result.fileContent);
                        if (structKeyExists(errorData, "errors") && isArray(errorData.errors)) {
                            errors = errorData.errors;
                            errorMessage = "Email send failed: " & arrayToList(errors.map(function(err) {
                                return structKeyExists(err, "message") ? err.message : "Unknown error";
                            }), "; ");
                        }
                    } catch (any jsonError) {
                        // If we can't parse the error response, use the raw content
                        errorMessage &= " - " & result.fileContent;
                    }
                }
                
                writeLog(text=errorMessage, type="error", file="SendGrid");
                
                return {
                    "success": false,
                    "statusCode": statusCode,
                    "message": errorMessage,
                    "errors": errors
                };
            }
        } catch (any e) {
            var errorMessage = "SendGrid error: #e.message#";
            if (structKeyExists(e, "detail") && len(e.detail)) {
                errorMessage &= " - #e.detail#";
            }
            
            writeLog(text=errorMessage, type="error", file="SendGrid");
            
            return {
                "success": false,
                "statusCode": 500,
                "message": errorMessage,
                "error": e
            };
        }
    } 
    
    /**
     * Simple email sending helper function
     * Provides a simplified interface for common email sending scenarios
     * 
     * @toEmail       [string]  - Email address to send to (required)
     * @toName        [string]  - Name of recipient (optional)
     * @fromEmail     [string]  - Email address to send from (required)
     * @fromName      [string]  - Name of sender (optional)
     * @ccEmail       [string]  - Email address to CC (optional)
     * @ccName        [string]  - Name of CC recipient (optional)
     * @bccEmail      [string]  - Email address to BCC (optional)
     * @bccName       [string]  - Name of BCC recipient (optional)
     * @subject       [string]  - Email subject (required)
     * @textContent   [string]  - Plain text email content (optional)
     * @htmlContent   [string]  - HTML email content (optional, at least one content type required)
     * @replyToEmail  [string]  - Reply-to email address (optional)
     * @replyToName   [string]  - Reply-to name (optional)
     */
    public struct function sendSimpleEmail(
        required string toEmail,
        string toName = "",
        required string fromEmail,
        string fromName = "",
        string ccEmail = "",
        string ccName = "",
        string bccEmail = "",
        string bccName = "",
        required string subject,
        string textContent = "",
        string htmlContent = "",
        string replyToEmail = "",
        string replyToName = ""
    ) output="false" {
        
        // Build personalizations array
        var personalization = {
            "to": [{"email": arguments.toEmail}],
            "subject": arguments.subject
        };
        
        // Add optional name for recipient
        if (len(arguments.toName)) {
            personalization.to[1]["name"] = arguments.toName;
        }
        
        // Add CC if provided
        if (len(arguments.ccEmail)) {
            personalization["cc"] = [{"email": arguments.ccEmail}];
            if (len(arguments.ccName)) {
                personalization.cc[1]["name"] = arguments.ccName;
            }
        }
        
        // Add BCC if provided
        if (len(arguments.bccEmail)) {
            personalization["bcc"] = [{"email": arguments.bccEmail}];
            if (len(arguments.bccName)) {
                personalization.bcc[1]["name"] = arguments.bccName;
            }
        }
        
        // Build from object
        var from = {"email": arguments.fromEmail};
        if (len(arguments.fromName)) {
            from["name"] = arguments.fromName;
        }
        
        // Build content array
        var content = [];
        if (len(arguments.textContent)) {
            arrayAppend(content, {"type": "text/plain", "value": arguments.textContent});
        }
        if (len(arguments.htmlContent)) {
            arrayAppend(content, {"type": "text/html", "value": arguments.htmlContent});
        }
        
        // Validate at least one content type is provided
        if (arrayLen(content) == 0) {
            return {
                "success": false,
                "statusCode": 400,
                "message": "At least one content type (textContent or htmlContent) must be provided"
            };
        }
        
        // Build mail data structure
        var mailData = {
            "personalizations": [personalization],
            "from": from,
            "content": content
        };
        
        // Add reply-to if provided
        if (len(arguments.replyToEmail)) {
            mailData["reply_to"] = {"email": arguments.replyToEmail};
            if (len(arguments.replyToName)) {
                mailData.reply_to["name"] = arguments.replyToName;
            }
        }
        
        // Use main sendMail function
        return sendMail(mailData);
    }

    /**
     * Create a batch ID for grouping mail sends
     * Batch IDs can be used to schedule, pause, or cancel email sends
     * 
     * @return struct with batch_id on success, or error information
     */
    public struct function createBatchId() output="false" {
        try {
            // Get SendGrid API key from environment variable
            var sendGridAPIKey = "";
            if (structKeyExists(server, "system") && structKeyExists(server.system, "environment") && structKeyExists(server.system.environment, "sendgrid_api_key")) {
                sendGridAPIKey = server.system.environment.sendgrid_api_key;
            } else {
                throw(type="SendGrid.MissingAPIKey", message="SendGrid API key not found in server.system.environment.sendgrid_api_key");
            }
            
            // Make HTTP request to SendGrid API
            var result = {};
            cfhttp(
                method = "POST",
                url    = "https://api.sendgrid.com/v3/mail/batch",
                result = "result",
                timeout = "30"
            ) {
                cfhttpparam(type="header", name="Authorization", value="Bearer #sendGridAPIKey#");
                cfhttpparam(type="header", name="Content-Type", value="application/json");
            }
            
            // Parse response
            var statusCode = val(result.responseHeader["Status_Code"]);
            
            if (statusCode == 201) {
                var responseData = deserializeJSON(result.fileContent);
                writeLog(text="Batch ID created successfully: #responseData.batch_id#", type="information", file="SendGrid");
                return {
                    "success": true,
                    "statusCode": 201,
                    "batch_id": responseData.batch_id
                };
            } else {
                var errorMessage = "Batch ID creation failed with status code #statusCode#";
                if (len(result.fileContent)) {
                    errorMessage &= " - " & result.fileContent;
                }
                
                writeLog(text=errorMessage, type="error", file="SendGrid");
                
                return {
                    "success": false,
                    "statusCode": statusCode,
                    "message": errorMessage
                };
            }
        } catch (any e) {
            var errorMessage = "SendGrid batch ID creation error: #e.message#";
            if (structKeyExists(e, "detail") && len(e.detail)) {
                errorMessage &= " - #e.detail#";
            }
            
            writeLog(text=errorMessage, type="error", file="SendGrid");
            
            return {
                "success": false,
                "statusCode": 500,
                "message": errorMessage,
                "error": e
            };
        }
    }

    /**
     * Validate a batch ID
     * 
     * @batchId  [string]  - The batch ID to validate
     * @return struct with validation result
     */
    public struct function validateBatchId(required string batchId) output="false" {
        try {
            // Get SendGrid API key from environment variable
            var sendGridAPIKey = "";
            if (structKeyExists(server, "system") && structKeyExists(server.system, "environment") && structKeyExists(server.system.environment, "sendgrid_api_key")) {
                sendGridAPIKey = server.system.environment.sendgrid_api_key;
            } else {
                throw(type="SendGrid.MissingAPIKey", message="SendGrid API key not found in server.system.environment.sendgrid_api_key");
            }
            
            // Make HTTP request to SendGrid API
            var result = {};
            cfhttp(
                method = "GET",
                url    = "https://api.sendgrid.com/v3/mail/batch/#arguments.batchId#",
                result = "result",
                timeout = "30"
            ) {
                cfhttpparam(type="header", name="Authorization", value="Bearer #sendGridAPIKey#");
            }
            
            // Parse response
            var statusCode = val(result.responseHeader["Status_Code"]);
            
            if (statusCode == 200) {
                var responseData = deserializeJSON(result.fileContent);
                return {
                    "success": true,
                    "statusCode": 200,
                    "valid": true,
                    "batch_id": responseData.batch_id
                };
            } else if (statusCode == 400) {
                return {
                    "success": false,
                    "statusCode": 400,
                    "valid": false,
                    "message": "Invalid batch ID"
                };
            } else {
                var errorMessage = "Batch ID validation failed with status code #statusCode#";
                if (len(result.fileContent)) {
                    errorMessage &= " - " & result.fileContent;
                }
                
                return {
                    "success": false,
                    "statusCode": statusCode,
                    "message": errorMessage
                };
            }
        } catch (any e) {
            var errorMessage = "SendGrid batch ID validation error: #e.message#";
            if (structKeyExists(e, "detail") && len(e.detail)) {
                errorMessage &= " - #e.detail#";
            }
            
            writeLog(text=errorMessage, type="error", file="SendGrid");
            
            return {
                "success": false,
                "statusCode": 500,
                "message": errorMessage,
                "error": e
            };
        }
    }
}