<%@ Page Title="食材详情" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeBehind="FoodDetails.aspx.cs" Inherits="FoodProcurementSystem.FoodDetails" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div class="food-details">
        <h1><%= FoodName %></h1>
        
        <div class="food-info">
            <p><span class="label">分类：</span><%= CategoryName %></p>
            <p><span class="label">描述：</span><div class="food-image-container">
    <asp:Image ID="imgFood" runat="server" CssClass="food-image" />
</div>
<asp:Label ID="lblDescription" runat="server"></asp:Label></p>
            <p><span class="label">价格：</span><%= Price.ToString("C") %>/<%= Unit %></p>
            <p><span class="label">库存：</span><%= Stock %> <%= Unit %></p>
            <p><span class="label">供应商：</span><%= Supplier %></p>
            <p><span class="label">更新时间：</span><%= UpdateDate.ToString("yyyy-MM-dd HH:mm") %></p>
        </div>
        
        <div style="text-align: center; margin-top: 30px;">
            <asp:Button ID="btnAddToCart" runat="server" Text="加入采购清单" 
                CssClass="btn-add-to-cart" OnClick="btnAddToCart_Click" />
        </div>
    </div>
</asp:Content>