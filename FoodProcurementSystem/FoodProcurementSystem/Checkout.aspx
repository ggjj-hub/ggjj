<%@ Page Title="结账页面" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="FoodProcurementSystem.Checkout" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style>
        .checkout-container { max-width: 800px; margin: 0 auto; padding: 20px; }
        .checkout-section { margin-bottom: 30px; padding: 20px; border: 1px solid #eee; border-radius: 8px; }
        .section-title { font-size: 18px; margin-bottom: 15px; padding-bottom: 5px; border-bottom: 2px solid #3498db; }
        .form-group { margin-bottom: 15px; }
        .form-label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-control { width: 100%; padding: 8px; box-sizing: border-box; }
        .order-summary { width: 100%; border-collapse: collapse; margin-top: 15px; }
        .order-summary th, .order-summary td { padding: 10px; text-align: left; border-bottom: 1px solid #eee; }
        .order-summary th { background-color: #f8f9fa; }
        .total-amount { font-size: 18px; font-weight: bold; text-align: right; margin-top: 15px; }
        .btn-place-order { background-color: #27ae60; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; font-size: 16px; }
        .btn-place-order:hover { background-color: #219653; }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div class="checkout-container">
        <h1>订单结账</h1>

        <div class="checkout-section">
            <h2 class="section-title">收货信息</h2>
            <div class="form-group">
                <label class="form-label" for="txtName">姓名:</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" required></asp:TextBox>
            </div>
            <div class="form-group">
                <label class="form-label" for="txtPhone">电话:</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" required></asp:TextBox>
            </div>
            <div class="form-group">
                <label class="form-label" for="txtAddress">地址:</label>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" required></asp:TextBox>
            </div>
        </div>

        <div class="checkout-section">
            <h2 class="section-title">订单摘要</h2>
            <asp:GridView ID="gvOrderSummary" runat="server" AutoGenerateColumns="false" CssClass="order-summary">
                <Columns>
                    <asp:BoundField DataField="Name" HeaderText="商品名称" />
                    <asp:BoundField DataField="Price" HeaderText="单价" DataFormatString="{0:C}" />
                    <asp:BoundField DataField="Quantity" HeaderText="数量" />
                    <asp:BoundField DataField="Subtotal" HeaderText="小计" DataFormatString="{0:C}" />
                </Columns>
            </asp:GridView>
            <div class="total-amount">
                总计: <asp:Label ID="lblTotal" runat="server" Text="¥0.00"></asp:Label>
            </div>
        </div>

        <div style="text-align: right;">
            <asp:Button ID="btnPlaceOrder" runat="server" Text="提交订单" CssClass="btn-place-order" OnClick="btnPlaceOrder_Click" />
        </div>
    </div>
</asp:Content>