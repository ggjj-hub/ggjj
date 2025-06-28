using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using FoodProcurementSystem;

namespace FoodProcurementSystem
{
    public partial class FoodDetails : System.Web.UI.Page
    {
        public string FoodName { get; set; }
        public string CategoryName { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public string Unit { get; set; }
        public int Stock { get; set; }
        public string Supplier { get; set; }
        public DateTime UpdateDate { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                int foodId = int.Parse(Request.QueryString["id"]);
                LoadFoodDetails(foodId);
            }
            else
            {
                // 如果没有提供食材ID，重定向到主页
                Response.Redirect("Default.aspx");
            }
        }
            

        private void LoadFoodDetails(int foodId)
        {
            DatabaseHelper db = new DatabaseHelper();

            // 获取食材详情
            DataTable dtFood = db.ExecuteQuery(
                  "SELECT f.FoodName, f.Price, f.Unit, f.Description, f.Stock, c.Name AS CategoryName, f.ImageUrl, '默认供应商' AS Supplier, GETDATE() AS UpdateDate " +
                  "FROM Foods f INNER JOIN Categories c ON f.CategoryId = c.Id " +
                  "WHERE f.Id = @Id",
                  new System.Data.SqlClient.SqlParameter("@Id", foodId));

            if (dtFood.Rows.Count > 0)
            {
                DataRow row = dtFood.Rows[0];
                // 输出所有列名和值用于调试
                foreach (System.Data.DataColumn col in dtFood.Columns)
                {
                    System.Diagnostics.Debug.WriteLine(string.Format("Column: {0}, Value: {1}", col.ColumnName, row[col]));
                }
                // 尝试使用可能的字段名
                FoodName = row["FoodName"].ToString();
                CategoryName = row["CategoryName"].ToString();
                Description = row["Description"].ToString();
                Price = decimal.Parse(row["Price"].ToString());
                Unit = row["Unit"].ToString();
                Stock = int.Parse(row["Stock"].ToString());
                Supplier = row["Supplier"].ToString();
                UpdateDate = DateTime.Parse(row["UpdateDate"].ToString());
                string imageUrl = row["ImageUrl"].ToString();
                if (string.IsNullOrEmpty(imageUrl))
                {
                    imageUrl = "/Images/default.jpg";
                }
                imgFood.ImageUrl = imageUrl;
            }
            else
            {
                // 如果食材不存在，重定向到主页
                Response.Redirect("Default.aspx");
            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            // 获取当前食材信息
            int foodId = int.Parse(Request.QueryString["id"]);
            string foodName = this.FoodName;
            decimal foodPrice = this.Price;
            string unit = this.Unit;
            string imageUrl = imgFood.ImageUrl;
            // 调试日志
            System.Diagnostics.Debug.WriteLine(string.Format("添加商品到购物车: ID={0}, 名称={1}, 价格={2}", foodId, foodName, foodPrice));

            // 获取购物车
            List<CartItem> cart = GetCart();

            // 检查商品是否已在购物车中
            CartItem existingItem = cart.Find(item => item.FoodId == foodId);
            if (existingItem != null)
            {
                // 如果已存在，增加数量
                existingItem.Quantity++;
            }
            else
            {
                // 如果不存在，添加新商品
                cart.Add(new CartItem
                    {
                        FoodId = foodId,
                        Name = foodName,
                        Price = foodPrice,
                        Unit = unit,
                        Quantity = 1,
                        ImageUrl = imageUrl
                    });
                // 保存购物车到Session
                Session["ShoppingCart"] = cart;
            }

            // 保存购物车回Session
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