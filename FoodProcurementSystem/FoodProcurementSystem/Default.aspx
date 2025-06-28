<%@ Page Title="主页" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="FoodProcurementSystem._Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style>
        .search-container {
            margin: 20px 0;
            display: flex;
            gap: 10px;
        }
        .search-input {
            flex: 1;
            padding: 8px;
            font-size: 16px;
        }
        .search-button {
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div class="search-container">
        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" 
            placeholder="搜索食材..."></asp:TextBox>
        <asp:Button ID="btnSearch" runat="server" Text="搜索" OnClick="btnSearch_Click" CssClass="search-button" />
    </div>
    <h2>热门食材分类</h2>
    <div class="category-nav">
        <asp:Repeater ID="rptCategories" runat="server" 
            onitemcommand="rptCategories_ItemCommand">
            <ItemTemplate>
                <div class="category-item">
                    <a href="Categories.aspx?id=<%# Eval("Id") %>"><%# Eval("Name") %></a>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <h2 id="h2PopularFoods" runat="server">热门食材</h2>
    <div class="popular-foods">
        <asp:Repeater ID="rptPopularFoods" runat="server">
            <ItemTemplate>
                <div class="food-item">
                    <h3><a href="FoodDetails.aspx?id=<%# Eval("Id") %>"><%# Eval("FoodName") %></a></h3>
                    <p class="description"><%# Eval("Description") %></p>
                    <p class="price">价格: <%# Eval("Price") %> 元/<%# Eval("Unit") %></p>
                    <p class="stock">库存: <%# Eval("Stock") %></p>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
