using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;

public partial class FoodDetails : System.Web.UI.Page
{
    public string Supplier { get; set; }
    public DateTime UpdateDate { get; set; }
    public string ImageUrl { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int foodId = Convert.ToInt32(Request.QueryString["id"]);
            LoadFoodDetails(foodId);
        }
    }

    private void LoadFoodDetails(int foodId)
    {
        DatabaseHelper db = new DatabaseHelper();
        DataTable dtFood = db.GetFoodDetails(foodId);
        if (dtFood.Rows.Count > 0)
        {
            DataRow row = dtFood.Rows[0];
            // ... existing code ...
            UpdateDate = DateTime.Parse(row["UpdateDate"].ToString());
            imgFood.ImageUrl = row["ImageUrl"].ToString();
            ImageUrl = row["ImageUrl"].ToString();
        }
    }

    protected void btnAddToCart_Click(object sender, EventArgs e)
    {
        int foodId = int.Parse(Request.QueryString["id"]);

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
        decimal foodPrice = 0;
        decimal.TryParse(row["Price"].ToString(), out foodPrice);
        string unit = row["Unit"].ToString();
        string imageUrl = row["ImageUrl"].ToString();

        System.Diagnostics.Debug.WriteLine($"添加商品到购物车: ID={foodId}, 名称={foodName}, 价格={foodPrice}");

        List<CartItem> cart = GetCart();

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

        Session["ShoppingCart"] = cart;

        Response.Write("<script>alert('已加入购物清单！'); window.location.href='ShoppingCart.aspx';</script>");
    }
}