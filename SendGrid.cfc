component  displayname="SendMail" hint="CFC for Working SendGrid and Sending Mail" output="true" {
    /**
     * Send an email using SendGrid API
     * 
     * @toEmail       [string]  - Email address to send to
     * @toName        [string]  - Name of recipient
     * @fromEmail     [string]  - Email address to send from
     * @fromName      [string]  - Name of sender
     * @ccEmail       [string]  - Email address to send to
     * @ccName        [string]  - Name of recipient
     * @bccEmail      [string]  - Email address to send to
     * @bccName       [string]  - Name of recipient
     * @subject       [string]  - Email subject
     * @message       [string]  - Email message
     * @htmlMessage   [string]  - HTML Email message
     */
    remote struct function sendEmail(required email toEmail="bryan@archinet.net", string toName="Archinet User", required email fromEmail="notifications@archinet.net", string fromName="Archinet Notifications Team", email ccEmail="bryan@archinet.net", string ccName="Archinet Notifications Team", email bccEmail="notifications@archinet.net", string bccName="", required string subject="Archinet Email Notification", required string message="You have received this email because you are testing the SendMail.cfc sendEmail() function.", string htmlMessage="<strong>Testing HTML Email using sendgrid api with cURL. Test Link: <a href='https://projects.archinet.net'>Archinet</a></strong>") output="false" returnformat="json" {
        var errorResponse = {};

        //cfparam(name="arguments.toEmail", type="email", default="bryan@archinet.net");

        try {
          var sendGridAPIKey = server.system.environment.sendgrid_api_key;
            
            /*
            curl --request POST \
            --url https://api.sendgrid.com/v3/mail/send \
            --header "Authorization: Bearer #sendGridAPIKey#" \
            --header 'Content-Type: application/json' \
            --data '{"personalizations": [{"to": [{"email": "bryan@archinet.net", "name": "Bryan Rice"},{"email": "josh@archinet.net", "name": "Josh Ginsburg"}]}],"from": {"email": "notifications@archinet.net", "name": "Archinet Notifications Team"},"reply_to": {"email": "notifications@archinet.net", "name": "Archinet Notifications Team"},"subject": "Sending with SendGrid API Test","content": [{"type": "text/plain", "value": "Testing Plain Text Email using sendgrid api with cURL"},{"type": "text/html", "value": "<strong>Testing HTML Email using sendgrid api with cURL. Test Link: <a href=\"https://projects.archinet.net\">Archinet</a></strong>"}]}'
            */
            //Use cfhttp to send email based on sendgrid api curl example above
            var result = {};
            cfhttp(
                method = "POST",
                url    = "https://api.sendgrid.com/v3/mail/send",
                result = "result",
                timeout = "30"
            ) {
                cfhttpparam(type="header", name="Authorization", value="Bearer #sendGridAPIKey#");
                cfhttpparam(type="header", name="Content-Type",  value="application/json");
                cfhttpparam(
                    type="body",
                    value='{
                        "personalizations":[{"to":[{"email":"#arguments.toEmail#","name":"#arguments.toName#"}]}],
                        "from":{"email":"#arguments.fromEmail#","name":"#arguments.fromName#"},
                        "reply_to":{"email":"#arguments.fromEmail#","name":"#arguments.fromName#"},
                        "cc":{"email":"#arguments.ccEmail#","name":"#arguments.ccName#"},
                        "bcc":{"email":"#arguments.bccEmail#","name":"#arguments.bccName#"},
                        "subject":"#arguments.subject#",
                        "content":[
                            {"type":"text/plain","value":"#arguments.message#"},
                            {"type":"text/html","value":"#arguments.htmlMessage#"}
                        ]
                    }'
                );
                {
  "personalizations": [
    {
      "to": [
        {
          "email": "alex@example.com",
          "name": "Alex"
        },
        {
          "email": "bola@example.com",
          "name": "Bola"
        }
      ],
      "cc": [
        {
          "email": "charlie@example.com",
          "name": "Charlie"
        }
      ],
      "bcc": [
        {
          "email": "dana@example.com",
          "name": "Dana"
        }
      ]
    },
    {
      "from": {
        "email": "sales@example.com",
        "name": "Example Sales Team"
      },
      "to": [
        {
          "email": "ira@example.com",
          "name": "Ira"
        }
      ],
      "bcc": [
        {
          "email": "lee@example.com",
          "name": "Lee"
        }
      ]
    }
  ],
  "from": {
    "email": "orders@example.com",
    "name": "Example Order Confirmation"
  },
  "reply_to": {
    "email": "customer_service@example.com",
    "name": "Example Customer Service Team"
  },
  "subject": "Your Example Order Confirmation",
  "content": [
    {
      "type": "text/html",
      "value": "<p>Hello from Twilio SendGrid!</p><p>Sending with the email service trusted by developers and marketers for <strong>time-savings</strong>, <strong>scalability</strong>, and <strong>delivery expertise</strong>.</p><p>%open-track%</p>"
    }
  ],
  "attachments": [
    {
      "content": "PCFET0NUWVBFIGh0bWw+CjxodG1sIGxhbmc9ImVuIj4KCiAgICA8aGVhZD4KICAgICAgICA8bWV0YSBjaGFyc2V0PSJVVEYtOCI+CiAgICAgICAgPG1ldGEgaHR0cC1lcXVpdj0iWC1VQS1Db21wYXRpYmxlIiBjb250ZW50PSJJRT1lZGdlIj4KICAgICAgICA8bWV0YSBuYW1lPSJ2aWV3cG9ydCIgY29udGVudD0id2lkdGg9ZGV2aWNlLXdpZHRoLCBpbml0aWFsLXNjYWxlPTEuMCI+CiAgICAgICAgPHRpdGxlPkRvY3VtZW50PC90aXRsZT4KICAgIDwvaGVhZD4KCiAgICA8Ym9keT4KCiAgICA8L2JvZHk+Cgo8L2h0bWw+Cg==",
      "filename": "index.html",
      "type": "text/html",
      "disposition": "attachment"
    }
  ],
  "categories": [
    "cake",
    "pie",
    "baking"
  ],
  "send_at": 1617260400,
  "batch_id": "AsdFgHjklQweRTYuIopzXcVBNm0aSDfGHjklmZcVbNMqWert1znmOP2asDFjkl",
  "asm": {
    "group_id": 12345,
    "groups_to_display": [
      12345
    ]
  },
  "ip_pool_name": "transactional email",
  "mail_settings": {
    "bypass_list_management": {
      "enable": false
    },
    "footer": {
      "enable": false
    },
    "sandbox_mode": {
      "enable": false
    }
  },
  "tracking_settings": {
    "click_tracking": {
      "enable": true,
      "enable_text": false
    },
    "open_tracking": {
      "enable": true,
      "substitution_tag": "%open-track%"
    },
    "subscription_tracking": {
      "enable": false
    }
  }
}
            }
            
            // Success check: SendGrid returns 202 Accepted with empty body on success
            if (val(result.responseHeader["Status_Code"]) EQ 202) {
                writeLog(text = "Email Sent", type = "information", file = "SendMailCFC");
                // success
            } else {
                writeLog(text = "Email Not Sent", type = "error", file = "SendMailCFC");
                // log/debug: result.StatusCode, result.FileContent
            }
        } catch (any e) {
            writeLog(text = e.message, type = "error", file = "SendMailCFC");
            errorResponse = {
                'status': "error",
                'error' = {
                    'code' = 500,
                    'message' = e.message
                }
            };
                return errorResponse;
        }
        
        return {"success":true,"code":200,"status":"success"};
    } 

    /**
     * Get data for a table
     * 
     * @tableName     [string]  - Name of table to get data for
     * @project_id    [numeric] - Project ID
     */
    public query function getTableData(required string tableName="projects_users_association_tbl", required numeric project_id) output="false" returnformat="json" {
            //https://projects.archinet.net/net/archinet/DataTables.cfc?method=getTableData&project_id=15338&tableName=projects_users_association_tbl&returnFormat=json
        var sql = "SELECT
                u.id AS user_id,
                c.client_name,
                u.user_first_name,
                u.user_last_name,
                u.id AS download_required,
                u.id AS response_required,
                u.user_email,
                u.client_id,
                u.avatar_url             
                FROM #arguments.tableName# pu
                INNER JOIN project_users_tbl u ON pu.user_id = u.id
                INNER JOIN clients_tbl c ON u.client_id = c.id
                INNER JOIN project_users_tbl cu ON u.user_created_by_user_id = cu.id
                INNER JOIN clients_tbl cc ON cu.client_id = cc.id              
                WHERE pu.project_id = :project_id";
        var qparams = {};
        qparams.project_id = { "value"=arguments.project_id, "cfsqltype"="cf_sql_integer" };
        sql = sql & " ORDER BY client_name, client_id, user_last_name, user_first_name, user_id;";
        
        var options = { "datasource"=APPLICATION.DSN };
        try {
            //Try to execute query
            var qData = queryExecute(sql, qparams, options);
        }
        catch (any e) {
            writeLog(text = e.message, type = "error", file = "ArchinetUploadFilesAPI");
            var errorResponse = {
                'status': "error",
                'error' = {
                    'code' = 500,
                    'message' = e.message
                }
            };
                return errorResponse;
        }
            
        return qData;
    } 
    /**
     * Get data for a table
     * 
     * @tableName     [string]  - Name of table to get data for
     * @project_id    [numeric] - Project ID
     */
    public any function getDocumentsData(required string tableName="test_documents_tbl", required numeric project_id) output="false" returnformat="json" {
     //test_documents_tbl
        //https://projects.archinet.net/net/archinet/DataTables.cfc?method=getTableData&project_id=15338&tableName=projects_users_association_tbl&returnFormat=json
    var sql = "SELECT 
            pu.*
            /* u.id AS user_id,
            c.client_name,
            u.user_first_name,
            u.user_last_name,
            u.id AS download_required,
            u.id AS response_required,
            u.user_email,
            u.client_id,
            u.avatar_url   */           
            FROM #arguments.tableName# pu
            /* INNER JOIN project_users_tbl u ON pu.user_id = u.id
            INNER JOIN clients_tbl c ON u.client_id = c.id
            INNER JOIN project_users_tbl cu ON u.user_created_by_user_id = cu.id
            INNER JOIN clients_tbl cc ON cu.client_id = cc.id    */           
            WHERE pu.project_id = :project_id";
    var qparams = {};
    qparams.project_id = { "value"=arguments.project_id, "cfsqltype"="cf_sql_integer" };
    sql = sql & " ORDER BY project_id;";
    
    var options = { "datasource"=APPLICATION.DSN };
    try {
        //Try to execute query
        var qData = queryExecute(sql, qparams, options);
    }
    catch (any e) {
        writeLog(text = e.message, type = "error", file = "ArchinetUploadFilesAPI");
        var errorResponse = {
            'status': "error",
            'error' = {
                'code' = 500,
                'message' = e.message
            }
        };
            return errorResponse;
    }
        
    return qData;
} 
}