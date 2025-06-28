using System;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoodProcurementSystem.Account
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            RegisterHyperLink.NavigateUrl = "Register.aspx?ReturnUrl=" + HttpUtility.UrlEncode(Request.QueryString["ReturnUrl"]);
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = UserName.Text.Trim();
            string password = Password.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                lblErrorMessage.Text = "请输入用户名和密码";
                return;
            }

            DatabaseHelper db = new DatabaseHelper();
            string sql = "SELECT Id FROM Users WHERE Username = @Username AND Password = @Password";
            object userId = db.ExecuteScalar(sql,
                new SqlParameter("@Username", username),
                new SqlParameter("@Password", password));

            if (userId != null)
            {
                // 存储用户ID到Session
                
Session["UserId"] = userId.ToString();
                // 重定向到首页或原始请求页面
                // 设置登录成功消息并跳转到添加食品页面
                // 登录成功后显示弹窗并跳转到首页
                // 使用ResolveUrl确保路径正确解析
                ClientScript.RegisterStartupScript(this.GetType(), "loginSuccess", "alert('登录成功！'); window.location.href='" + ResolveUrl("~/Default.aspx") + "';", true);
            }
            else
            {
                lblErrorMessage.Text = "用户名或密码错误";
            }
        }
    }
}
