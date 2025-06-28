using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoodProcurementSystem
{
    public partial class ShoppingCart : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCartItems();
            }
        }
        
        // 获取当前购物车
        private List<CartItem> GetCart()
        {
            if (Session["ShoppingCart"] == null)
            {
                Session["ShoppingCart"] = new List<CartItem>();
            }
            return (List<CartItem>)Session["ShoppingCart"];
        }
        
        // 绑定购物车项目到GridView
        private void BindCartItems()
        {
            List<CartItem> cart = GetCart();
            // 调试购物车内容
            System.Diagnostics.Debug.WriteLine("购物车项目数量: " + cart.Count);
            foreach (var item in cart)
            {
                System.Diagnostics.Debug.WriteLine(string.Format("商品ID: {0}, 名称: {1}, 价格: {2}, 数量: {3}", item.FoodId, item.Name, item.Price, item.Quantity));
            }
            if (gvCart != null)
            {
                gvCart.DataSource = cart;
                gvCart.DataBind();
            }
            else
            {
                // 处理GridView控件未找到的情况
                Page.ClientScript.RegisterStartupScript(this.GetType(), "GridViewError", "alert('购物车列表控件未找到，请检查页面设计');", true);
            }
            
            // 更新总金额显示
            decimal total = 0;
            foreach (CartItem item in cart)
            {
                total += item.Subtotal;
            }
            lblTotal.Text = total.ToString("C");
        }
        
        // 移除购物车项目
        protected void gvCart_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int foodId = Convert.ToInt32(e.Keys["FoodId"]);
            List<CartItem> cart = GetCart();
            CartItem itemToRemove = cart.Find(item => item.FoodId == foodId);
            
            if (itemToRemove != null)
            {
                cart.Remove(itemToRemove);
                Session["ShoppingCart"] = cart;
                //BindCartItems();
                //Page.ClientScript.RegisterStartupScript(this.GetType(), "DeleteSuccess", "alert('商品已从购物车中移除');", true);
                Response.Redirect(Request.RawUrl); // 强制刷新页面，确保界面和数据同步
            }
        }
        
        protected void gvCart_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // 为删除按钮添加确认对话框
                LinkButton lnkDelete = (LinkButton)e.Row.FindControl("lnkDelete");
                if (lnkDelete != null)
                {
                    lnkDelete.OnClientClick = "return confirmDelete();";
                }
                
                // 为数量输入框添加事件
                TextBox txtQuantity = (TextBox)e.Row.FindControl("txtQuantity");
                if (txtQuantity != null)
                {
                    CartItem item = (CartItem)e.Row.DataItem;
                    txtQuantity.ID = "quantity_" + item.FoodId;
                    txtQuantity.Attributes["onchange"] = "return updateQuantity(" + item.FoodId + ", this);";
                    txtQuantity.Attributes["onkeydown"] = "var e = event || window.event; if ((e.keyCode === 13 || e.which === 13)) { e.preventDefault(); updateQuantity(" + item.FoodId + ", this); return false; }";
                }

                // 设置小计标签ID
                Label lblSubtotal = (Label)e.Row.FindControl("lblSubtotal");
                if (lblSubtotal != null)
                {
                    CartItem item = (CartItem)e.Row.DataItem;
                    lblSubtotal.ID = "subtotal_" + item.FoodId;
                }
            }
        }
        
        // 清空购物车
        protected void btnClearCart_Click(object sender, EventArgs e)
    {
        // 清空购物车逻辑
        Session["ShoppingCart"] = null;
        Response.Redirect("ShoppingCart.aspx");
    }




        
        public class UpdateResult
        {
            public decimal Subtotal { get; set; }
            public decimal Total { get; set; }
        }

        // 更新商品数量（AJAX调用）
        [WebMethod(EnableSession = true)]
          [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static UpdateResult UpdateQuantity(int foodId, int quantity)
        {
            // 确保数量不为负数
            if (quantity < 1)
                quantity = 1;
                
            List<CartItem> cart = GetStaticCart();
            CartItem item = cart.Find(i => i.FoodId == foodId);
            
            if (item != null)
            {
                item.Quantity = quantity;
                HttpContext.Current.Session["ShoppingCart"] = cart;
            }

            // 计算返回结果
            decimal subtotal = item != null ? item.Price * item.Quantity : 0;
            decimal total = 0;
            foreach (var cartItem in cart)
            {
                total += cartItem.Price * cartItem.Quantity;
            }

            return new UpdateResult { Subtotal = subtotal, Total = total };
        }
        
        // 静态方法需要单独实现GetCart
        private static List<CartItem> GetStaticCart()
        {
            if (HttpContext.Current.Session["ShoppingCart"] == null)
            {
                HttpContext.Current.Session["ShoppingCart"] = new List<CartItem>();
            }
            return (List<CartItem>)HttpContext.Current.Session["ShoppingCart"];
        }
        
        // 结账按钮点击事件
        // 受保护的控件声明
        protected GridView gvCart;
        protected Label lblTotal;

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            // 跳转到结账页面
            Response.Redirect("Checkout.aspx");
        }
        
        protected void txtQuantity_TextChanged(object sender, EventArgs e)
        {
            TextBox txtQuantity = (TextBox)sender;
            GridViewRow row = (GridViewRow)txtQuantity.NamingContainer;
            int foodId = Convert.ToInt32(gvCart.DataKeys[row.RowIndex].Value);
            int quantity = 1;
            int.TryParse(txtQuantity.Text, out quantity);
            if (quantity < 1) quantity = 1;

            List<CartItem> cart = GetCart();
            CartItem item = cart.Find(i => i.FoodId == foodId);
            if (item != null)
            {
                item.Quantity = quantity;
                Session["ShoppingCart"] = cart;
            }
            BindCartItems();
        }
    }
}