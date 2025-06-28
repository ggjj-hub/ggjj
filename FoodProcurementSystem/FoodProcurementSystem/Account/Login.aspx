<%@ Page Title="登录" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeBehind="Login.aspx.cs" Inherits="FoodProcurementSystem.Account.Login" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <h2>登录</h2>
    <p>请输入用户名和密码。</p>
    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <h2>账户登录</h2>
                <p>欢迎回来，请登录您的账户</p>
            </div>
            <div class="login-form">
                <div class="form-group">
                    <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName" CssClass="form-label">用户名</asp:Label>
                    <asp:TextBox ID="UserName" runat="server" CssClass="form-control" placeholder="请输入用户名"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" 
                         CssClass="error-message" ErrorMessage="必须填写用户名" 
                         ValidationGroup="LoginGroup" ToolTip="必须填写用户名">*</asp:RequiredFieldValidator>
                </div>
                <div class="form-group">
                    <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password" CssClass="form-label">密码</asp:Label>
                    <asp:TextBox ID="Password" runat="server" CssClass="form-control" TextMode="Password" placeholder="请输入密码"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" 
                         CssClass="error-message" ErrorMessage="必须填写密码" 
                         ValidationGroup="LoginGroup" ToolTip="必须填写密码">*</asp:RequiredFieldValidator>
                </div>
                <div class="form-check">
                    <asp:CheckBox ID="RememberMe" runat="server" CssClass="form-check-input"/>
                    <asp:Label ID="RememberMeLabel" runat="server" AssociatedControlID="RememberMe" CssClass="form-check-label">保持登录状态</asp:Label>
                </div>
                <asp:Button ID="btnLogin" runat="server" Text="登录" 
                    OnClick="btnLogin_Click" 
                    ValidationGroup="LoginGroup"
                    CssClass="btn btn-primary btn-block mt-3" 
                    UseSubmitBehavior="true"
                    CommandName="Login"/>
                <div class="login-message">
                    <asp:Label ID="lblErrorMessage" runat="server" CssClass="message-text"></asp:Label>
                </div>
                <div class="login-register">
                    <p>还没有账户? <asp:HyperLink ID="RegisterHyperLink" runat="server" EnableViewState="false" CssClass="register-link">立即注册</asp:HyperLink></p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>