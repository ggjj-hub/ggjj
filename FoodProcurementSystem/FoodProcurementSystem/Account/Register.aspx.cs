using System;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoodProcurementSystem.Account
{
    public partial class Register : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            RegisterUser.ContinueDestinationPageUrl = Request.QueryString["ReturnUrl"];
        }

        protected void RegisterUser_CreatedUser(object sender, EventArgs e)
        {
            string username = RegisterUser.UserName;
            string password = RegisterUser.Password;

            // 将新用户插入数据库
            DatabaseHelper db = new DatabaseHelper();
            string sql = "INSERT INTO Users (Username, Password) VALUES (@Username, @Password); SELECT SCOPE_IDENTITY();";
            object userId = db.ExecuteScalar(sql,
                new SqlParameter("@Username", username),
                new SqlParameter("@Password", password));

            if (userId != null)
            {
                // 设置用户Session
                Session["UserId"] = userId;
                string continueUrl = RegisterUser.ContinueDestinationPageUrl;
                if (String.IsNullOrEmpty(continueUrl))
                {
                    continueUrl = "~/Account/Login.aspx";
                }
                Response.Redirect(continueUrl);
            }
            else
            {
                // 注册失败处理
                Label lblErrorMessage = (Label)RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("lblErrorMessage");
                if (lblErrorMessage != null)
                {
                    lblErrorMessage.Text = "注册失败，请重试。";
                }
            }
        }

        protected void Password_TextChanged(object sender, EventArgs e)
        {

        }

    }
}
