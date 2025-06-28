using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoodProcurementSystem
{
    public partial class Categories : System.Web.UI.Page
    {
        public string CategoryName { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int categoryId = int.Parse(Request.QueryString["id"]);
                    LoadCategoryFoods(categoryId);
                }
                else
                {
                    // 如果没有提供分类ID，重定向到主页
                    Response.Redirect("Default.aspx");
                }
            }
        }

        private void LoadCategoryFoods(int categoryId)
        {
            DatabaseHelper db = new DatabaseHelper();

            // 获取分类名称
            DataTable dtCategory = db.ExecuteQuery("SELECT Name FROM Categories WHERE Id = @Id",
                new System.Data.SqlClient.SqlParameter("@Id", categoryId));
            if (dtCategory.Rows.Count > 0)
            {
                CategoryName = dtCategory.Rows[0]["Name"].ToString();
            }

            // 获取该分类下的食材
            DataTable dtFoods = db.ExecuteQuery(
                "SELECT f.Id, f.FoodName, f.Description, f.Price, f.Unit, f.Stock, c.Name AS CategoryName " +
                "FROM Foods f INNER JOIN Categories c ON f.CategoryId = c.Id " +
                "WHERE f.CategoryId = @CategoryId",
                new System.Data.SqlClient.SqlParameter("@CategoryId", categoryId));

            rptFoodItems.DataSource = dtFoods;
            rptFoodItems.DataBind();
        }
    }
}