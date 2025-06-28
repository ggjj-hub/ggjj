<%@ Page Title="添加新食材" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddFood.aspx.cs" Inherits="FoodProcurementSystem.Admin.AddFood" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="FoodProcurementSystem" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style type="text/css">
        .form-group {
            margin-bottom: 15px;
        }
        .form-label {
            display: block; margin-bottom: 5px;
        }
        .form-control {
            width: 300px; padding: 5px;
        }
        .btn-submit {
            padding: 8px 15px; background-color: #4CAF50; color: white; border: none; cursor: pointer;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <h2>添加新食材</h2>
        <div class="form-group">
            <label class="form-label">食材名称:</label>
            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" required></asp:TextBox>
        </div>
        <div class="form-group">
            <label class="form-label">描述:</label>
            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
        </div>
        <div class="form-group">
            <label class="form-label">价格:</label>
            <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" type="number" Step="0.01" Min="0" required></asp:TextBox>
<div class="form-group">
    <label class="form-label">食材图片：</label>
    <asp:FileUpload ID="fileImage" runat="server" CssClass="form-control" accept=".jpg,.png" />
    <small class="form-text text-muted">支持JPG/PNG格式，最大2MB</small>
</div>
        </div>
        <div class="form-group">
            <label class="form-label">单位:</label>
            <asp:TextBox ID="txtUnit" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
        <div class="form-group">
            <label class="form-label">库存数量:</label>
            <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" Min="0"></asp:TextBox>
        </div>
        <div class="form-group">
            <label class="form-label">分类:</label>
            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control"></asp:DropDownList>
        </div>
        <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn-submit" OnClick="btnSave_Click" />
        <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
</asp:Content>