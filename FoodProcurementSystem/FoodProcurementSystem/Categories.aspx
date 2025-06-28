<%@ Page Title="分类食材" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeBehind="Categories.aspx.cs" Inherits="FoodProcurementSystem.Categories" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div class="category-header">
        <h1><%= CategoryName %></h1>
    </div>
    
    <div class="popular-foods">
        <asp:Repeater ID="rptFoodItems" runat="server">
            <ItemTemplate>
                <div class="food-item">
                    <h3><a href="FoodDetails.aspx?id=<%# Eval("Id") %>"><%# Eval("FoodName") %></a></h3>
                    <p class="description"><%# Eval("Description") %></p>
                    <p class="price">价格: <%# Eval("Price", "{0:C}") %>/<%# Eval("Unit") %></p>
                    <p class="stock">库存: <%# Eval("Stock") %> <%# Eval("Unit") %></p>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>