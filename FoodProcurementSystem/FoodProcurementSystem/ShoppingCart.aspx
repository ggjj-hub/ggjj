<%@ Page Title="购物清单" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="ShoppingCart.aspx.cs" Inherits="FoodProcurementSystem.ShoppingCart" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style>
        .cart-container { max-width: 1000px; margin: 0 auto; padding: 20px; }
        .cart-item { display: flex; justify-content: space-between; padding: 15px; border-bottom: 1px solid #eee; }
        .cart-item-details { flex: 1; }
        .cart-item-name { font-weight: bold; margin-bottom: 5px; }
        .cart-item-price { color: #e63946; }
        .cart-item-quantity { width: 60px; text-align: center; }
        .cart-total { margin-top: 20px; text-align: right; font-size: 18px; font-weight: bold; }
        .btn-remove { background-color: #ff4d4d; color: white; border: none; padding: 5px 10px; cursor: pointer; }
        .btn-clear { background-color: #ff9800; color: white; border: none; padding: 8px 16px; cursor: pointer; margin-top: 10px; }
        .empty-cart { text-align: center; padding: 50px; color: #666; }
    </style>
    <script>
        function updateQuantity(foodId, quantityInput) {
            console.log('Updating quantity for foodId: ' + foodId);
            var quantity = parseInt(quantityInput.value);
            if (isNaN(quantity) || quantity < 1) {
                alert('请输入有效的数量');
                quantityInput.value = 1;
                return;
            }

            PageMethods.UpdateQuantity(foodId, quantity, function(result) {
                console.log('Update result:', result);
                // 更新小计
                var subtotalLabel = document.getElementById('subtotal_' + foodId);
                if (subtotalLabel) {
                    subtotalLabel.textContent = '¥' + result.Subtotal.toFixed(2);
                }
                // 更新总计
                var totalLabel = document.getElementById('lblTotal');
                if (totalLabel) {
                    totalLabel.textContent = '¥' + result.Total.toFixed(2);
                }
            }, function(error) {
                console.error('PageMethods error:', error);
                alert('更新数量时发生错误，请重试');
            });
        }
    </script>

</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div class="cart-container">
        <h1>我的购物清单</h1>
        <asp:GridView ID="gvCart" runat="server" AutoGenerateColumns="false" 
            OnRowDeleting="gvCart_RowDeleting" OnRowDataBound="gvCart_RowDataBound" 
            DataKeyNames="FoodId" Height="174px" 
            Width="711px">
            <Columns>
                <asp:TemplateField HeaderText="图片">
                    <ItemTemplate>
                        <img src='<%# Eval("ImageUrl") %>' alt="图片" style="width:60px;height:60px;" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Name" HeaderText="商品名称" ReadOnly="true" />
                <asp:BoundField DataField="Price" HeaderText="单价" DataFormatString="{0:C}" />
                <asp:TemplateField HeaderText="数量">
                    <ItemTemplate>
                        <asp:TextBox ID="txtQuantity" runat="server" Text='<%# Eval("Quantity") %>' CssClass="cart-item-quantity" AutoPostBack="true" OnTextChanged="txtQuantity_TextChanged"></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="小计">
                    <ItemTemplate>
                        <asp:Label ID="lblSubtotal" runat="server" Text='<%# Eval("Subtotal", "{0:C}") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:CommandField ShowDeleteButton="true" ButtonType="Link" DeleteText="更新" />
            </Columns>
        </asp:GridView>
        <div id="emptyCartMessage" runat="server" class="empty-cart" visible="false">
            您的购物车是空的
        </div>
        <div class="cart-total">
            总计: <asp:Label ID="lblTotal" runat="server" Text="¥0.00"></asp:Label>
        </div>
        <div style="text-align: right; margin-top: 10px;">
            <asp:Button ID="btnClearCart" runat="server" Text="清空购物车" CssClass="btn-clear" OnClick="btnClearCart_Click" />
            <asp:Button ID="btnCheckout" runat="server" Text="结账" CssClass="btn-checkout" OnClick="btnCheckout_Click" Style="margin-left: 10px; background-color: #27ae60; color: white; border: none; padding: 8px 16px; cursor: pointer; border-radius: 5px;" />
        </div>
    </div>
</asp:Content>