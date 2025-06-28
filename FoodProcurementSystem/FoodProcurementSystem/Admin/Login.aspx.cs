using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoodProcurementSystem.Admin
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 检查用户是否已登录
            if (Session["AdminLoggedIn"] != null && (bool)Session["AdminLoggedIn"])
            {
                // 显示成功弹窗并跳转到首页
                ClientScript.RegisterStartupScript(this.GetType(), "loginSuccess", "alert('登录成功！'); window.location.href='~/Default.aspx';", true);
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                lblError.Text = "用户名和密码不能为空！";
                lblError.Visible = true;
                return;
            }

            // 验证管理员凭据
            DatabaseHelper db = new DatabaseHelper();
            DataTable dt = db.ExecuteQuery(
                "SELECT * FROM Users WHERE Username = @Username AND Password = @Password AND Role = 'Admin'",
                new System.Data.SqlClient.SqlParameter("@Username", username),
                new System.Data.SqlClient.SqlParameter("@Password", password));

            if (dt.Rows.Count > 0)
            {
                // 登录成功
                Session["AdminLoggedIn"] = true;
                Session["AdminUsername"] = username;
                // 使用ResolveUrl确保路径正确解析
                ClientScript.RegisterStartupScript(this.GetType(), "loginSuccess", "alert('登录成功！'); window.location.href='" + ResolveUrl("~/Default.aspx") + "';", true);
            }
            else
            {
                // 登录失败
                lblError.Text = "用户名或密码不正确！";
                lblError.Visible = true;
            }
        }
    }
}