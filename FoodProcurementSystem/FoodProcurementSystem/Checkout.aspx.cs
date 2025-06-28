using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace FoodProcurementSystem
{
    public partial class Checkout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadOrderSummary();
            }
        }

        private void LoadOrderSummary()
        {
            // 从Session获取购物车数据
            List<CartItem> cartItems = Session["ShoppingCart"] as List<CartItem>;
            
            if (cartItems != null && cartItems.Count > 0)
            {
                gvOrderSummary.DataSource = cartItems;
                gvOrderSummary.DataBind();
                
                // 计算总金额
                decimal total = 0;
                foreach (CartItem item in cartItems)
                {
                    total += item.Price * item.Quantity;
                }
                lblTotal.Text = total.ToString("C");
            }
            else
            {
                // 购物车为空，重定向到购物车页面
                Response.Redirect("ShoppingCart.aspx");
            }
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            try
            {
                // 验证输入
                if (string.IsNullOrEmpty(txtName.Text.Trim()) ||
                    string.IsNullOrEmpty(txtPhone.Text.Trim()) ||
                    string.IsNullOrEmpty(txtAddress.Text.Trim()))
                {
                    // 显示错误消息
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", 
                        "alert('请填写完整的收货信息！');", true);
                    return;
                }

                // 获取购物车数据
                List<CartItem> cartItems = Session["ShoppingCart"] as List<CartItem>;
                if (cartItems == null || cartItems.Count == 0)
                {
                    Response.Redirect("ShoppingCart.aspx");
                    return;
                }

                // 计算总金额
                decimal total = 0;
                foreach (CartItem item in cartItems)
                {
                    total += item.Price * item.Quantity;
                }

                // 检查库存是否充足
                DatabaseHelper db = new DatabaseHelper();
                foreach (CartItem item in cartItems)
                {
                    string checkSql = "SELECT Stock FROM Foods WHERE Id = @Id";
                    object stockObj = db.ExecuteScalar(checkSql, new System.Data.SqlClient.SqlParameter("@Id", item.FoodId));
                    int stock = stockObj != null ? Convert.ToInt32(stockObj) : 0;
                    if (stock < item.Quantity)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", 
                            string.Format("alert('商品【{0}】库存不足，无法完成结账！');", item.Name), true);
                        return;
                    }
                }

                // 写入订单表（假设有Orders和OrderItems表）
                // 生成订单号
                string orderNo = Guid.NewGuid().ToString();
                string insertOrderSql = "INSERT INTO Orders (OrderNo, CustomerName, Phone, Address, TotalAmount, OrderDate) VALUES (@OrderNo, @CustomerName, @Phone, @Address, @TotalAmount, @OrderDate)";
                db.ExecuteNonQuery(insertOrderSql,
                    new System.Data.SqlClient.SqlParameter("@OrderNo", orderNo),
                    new System.Data.SqlClient.SqlParameter("@CustomerName", txtName.Text.Trim()),
                    new System.Data.SqlClient.SqlParameter("@Phone", txtPhone.Text.Trim()),
                    new System.Data.SqlClient.SqlParameter("@Address", txtAddress.Text.Trim()),
                    new System.Data.SqlClient.SqlParameter("@TotalAmount", total),
                    new System.Data.SqlClient.SqlParameter("@OrderDate", DateTime.Now));

                foreach (CartItem item in cartItems)
                {
                    string insertItemSql = "INSERT INTO OrderItems (OrderNo, FoodId, FoodName, Price, Quantity, Subtotal) VALUES (@OrderNo, @FoodId, @FoodName, @Price, @Quantity, @Subtotal)";
                    db.ExecuteNonQuery(insertItemSql,
                        new System.Data.SqlClient.SqlParameter("@OrderNo", orderNo),
                        new System.Data.SqlClient.SqlParameter("@FoodId", item.FoodId),
                        new System.Data.SqlClient.SqlParameter("@FoodName", item.Name),
                        new System.Data.SqlClient.SqlParameter("@Price", item.Price),
                        new System.Data.SqlClient.SqlParameter("@Quantity", item.Quantity),
                        new System.Data.SqlClient.SqlParameter("@Subtotal", item.Subtotal));
                    // 扣减库存
                    string updateSql = "UPDATE Foods SET Stock = Stock - @Quantity WHERE Id = @Id";
                    db.ExecuteNonQuery(updateSql,
                        new System.Data.SqlClient.SqlParameter("@Quantity", item.Quantity),
                        new System.Data.SqlClient.SqlParameter("@Id", item.FoodId));
                }
                Session["ShoppingCart"] = null;
                
                // 显示成功消息并重定向
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", 
                    "alert('订单提交成功！'); window.location='Default.aspx';", true);
            }
            catch (Exception ex)
            {
                // 显示错误消息
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", 
                    "alert('提交订单时发生错误：" + ex.Message + "');", true);
            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            // 获取当前食材ID
            int foodId = int.Parse(Request.QueryString["id"]);

            // 重新从数据库加载食材信息，确保数据完整
            DatabaseHelper db = new DatabaseHelper();
            DataTable dtFood = db.ExecuteQuery(
                "SELECT f.FoodName, f.Price, f.Unit, f.ImageUrl FROM Foods f WHERE f.Id = @Id",
                new System.Data.SqlClient.SqlParameter("@Id", foodId));

            if (dtFood.Rows.Count == 0)
            {
                Response.Write("<script>alert('商品不存在！'); window.location.href='Default.aspx';</script>");
                return;
            }

            DataRow row = dtFood.Rows[0];
            string foodName = row["FoodName"].ToString();
            decimal foodPrice = decimal.Parse(row["Price"].ToString());
            string unit = row["Unit"].ToString();
            string imageUrl = row["ImageUrl"].ToString();

            // 获取购物车
            List<CartItem> cart = GetCart();

            // 检查商品是否已在购物车中
            CartItem existingItem = cart.Find(item => item.FoodId == foodId);
            if (existingItem != null)
            {
                existingItem.Quantity++;
            }
            else
            {
                cart.Add(new CartItem
                {
                    FoodId = foodId,
                    Name = foodName,
                    Price = foodPrice,
                    Unit = unit,
                    Quantity = 1,
                    ImageUrl = imageUrl
                });
            }

            // 保存购物车到Session
            Session["ShoppingCart"] = cart;

            // 显示提示并跳转到购物车页面
            Response.Write("<script>alert('已加入购物清单！'); window.location.href='ShoppingCart.aspx';</script>");
        }

        /// <summary>
        /// 获取购物车
        /// </summary>
        private List<CartItem> GetCart()
        {
            if (Session["ShoppingCart"] == null)
            {
                Session["ShoppingCart"] = new List<CartItem>();
            }
            return (List<CartItem>)Session["ShoppingCart"];
        }
    }
}