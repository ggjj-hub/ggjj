using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoodProcurementSystem
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 加载分类导航
                LoadCategories();
            }
        }

        private void LoadCategories()
        {
            try
            {
                DatabaseHelper db = new DatabaseHelper();
                DataTable dtCategories = db.GetAllCategories();
                rptCategories.DataSource = dtCategories;
                rptCategories.DataBind();
            }
            catch (Exception ex)
            {
                // 如果数据库连接失败，显示错误信息
                Response.Write("<script>alert('数据库连接失败，请检查数据库配置！');</script>");
            }
        }
    }
}
