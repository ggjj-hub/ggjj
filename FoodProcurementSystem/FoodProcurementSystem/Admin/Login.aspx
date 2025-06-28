<%@ Page Title="管理员登录" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style>
        .login-page { min-height: 100vh; display: flex; align-items: center; justify-content: center; background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); padding: 20px; }
        .login-container { width: 100%; max-width: 420px; background: white; padding: 35px; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.12); }
        .login-title { text-align: center; color: #2c3e50; margin-bottom: 30px; font-size: 24px; font-weight: 600; }
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; margin-bottom: 8px; color: #34495e; font-weight: 500; }
        .form-control { width: 100%; padding: 12px 15px; border: 1px solid #ddd; border-radius: 6px; font-size: 15px; transition: all 0.3s ease; }
        .form-control:focus { border-color: #3498db; box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2); outline: none; }
        .btn-login { width: 100%; padding: 13px; background: linear-gradient(135deg, #3498db 0%, #2980b9 100%); color: white; border: none; border-radius: 6px; font-size: 16px; font-weight: 500; cursor: pointer; transition: all 0.3s ease; }
        .btn-login:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3); }
        .btn-login:active { transform: translateY(0); }
        .error-message { color: #e74c3c; margin-top: 15px; text-align: center; padding: 10px; border: 1px solid #fadbd8; border-radius: 4px; background-color: #fef2f2; }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <script runat="server" type="text/C#">
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // 这里添加管理员登录验证逻辑
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            // 假设管理员账号为admin，密码为admin123（实际应用中应从数据库验证）
            if (username == "admin" && password == "admin123")
            {
                Session["AdminLoggedIn"] = true;
                Response.Redirect("ManageFoods.aspx");
            }
            else
            {
                lblError.Visible = true;
                lblError.Text = "用户名或密码错误，请重试。";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }
</script>
    <div class="login-page">
    <div class="login-container">
        <h2 class="login-title">管理员登录</h2>
        <div class="form-group">
            <label for="txtUsername" class="form-label">用户名:</label>
            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="请输入用户名"></asp:TextBox>
            </div>
        <div class="form-group">
            <label for="txtPassword" class="form-label">密码:</label>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="请输入密码"></asp:TextBox>
        </div>
        <asp:Button ID="btnLogin" runat="server" Text="登录" CssClass="btn-login" OnClick="btnLogin_Click" />
        <asp:Label ID="lblError" runat="server" CssClass="error-message" Visible="false"></asp:Label>
    </div>
</div>
</asp:Content>