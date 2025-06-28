using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Web.UI.HtmlControls;

namespace FoodProcurementSystem
{
    public partial class _Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 检查用户是否已登录
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // 从数据库获取分类数据
                DatabaseHelper db = new DatabaseHelper();
                DataTable dtCategories = db.GetAllCategories();
                rptCategories.DataSource = dtCategories;
                rptCategories.DataBind();

                // 初始加载热门食材
                BindFoodData(null);
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();
            BindFoodData(searchTerm);
        }

        private void BindFoodData(string searchTerm)
        {
            DatabaseHelper db = new DatabaseHelper();
            DataTable dtFoods;

            if (string.IsNullOrEmpty(searchTerm))
            {
                // 如果没有搜索词，显示热门食材
                dtFoods = db.GetPopularFoods();
            }
            else
            {
                // 执行搜索查询，补全Stock字段，避免Eval("Stock")报错
                string sql = "SELECT Id, FoodName, Price, Unit, Description, Stock FROM Foods WHERE FoodName LIKE @SearchTerm OR Description LIKE @SearchTerm";
                dtFoods = db.ExecuteQuery(sql,
                    new SqlParameter("@SearchTerm", "%" + searchTerm + "%"));
            }

            rptPopularFoods.DataSource = dtFoods;
            rptPopularFoods.DataBind();

            // 更新标题显示
            if (h2PopularFoods != null)
            {
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    h2PopularFoods.InnerText = "搜索结果: '" + searchTerm + "'";
                }
                else
                  {
                      h2PopularFoods.InnerText = "热门食材";
                  }
              }
          }

        protected void rptCategories_ItemCommand(object source, RepeaterCommandEventArgs e)
        {

        }
      }
  }
