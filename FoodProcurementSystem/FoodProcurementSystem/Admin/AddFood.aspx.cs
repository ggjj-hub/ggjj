using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.IO;
using System.Diagnostics;

namespace FoodProcurementSystem.Admin
{
    public partial class AddFood : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
                // 显示登录成功消息
                if (Session["LoginSuccessMessage"] != null)
                {
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    lblMessage.Text = Session["LoginSuccessMessage"].ToString();
                    Session["LoginSuccessMessage"] = null; // 清除消息
                }
            }
        }

        private void LoadCategories()
        {
            DatabaseHelper dbHelper = new DatabaseHelper();
            DataTable dt = dbHelper.GetAllCategories();
            ddlCategory.DataSource = dt;
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataValueField = "Id";
            ddlCategory.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                string name = txtName.Text.Trim();
                string description = txtDescription.Text.Trim();
                decimal price = decimal.Parse(txtPrice.Text.Trim());
                // 图片处理
                string imageUrl = "/Images/default.jpg";
                if (fileImage != null && fileImage.HasFile)
                {
                    if (!IsValidImage(fileImage.FileName))
                        throw new Exception("只支持JPG/PNG格式");

                    string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fileImage.FileName);
                    string savePath = Server.MapPath("~/Images/" + fileName);
                    fileImage.SaveAs(savePath);
                    imageUrl = "/Images/" + fileName;
                }
                string unit = txtUnit.Text.Trim();
                int stock = int.Parse(txtStock.Text.Trim());
                int categoryId = int.Parse(ddlCategory.SelectedValue);

                string sql = "INSERT INTO Foods (FoodName, Description, Price, Unit, Stock, CategoryId, ImageUrl) VALUES (@Name, @Description, @Price, @Unit, @Stock, @CategoryId, @ImageUrl)";

                DatabaseHelper dbHelper = new DatabaseHelper();
                int rowsAffected = dbHelper.ExecuteNonQuery(sql,
                    new SqlParameter("@Name", name),
                    new SqlParameter("@Description", description),
                    new SqlParameter("@Price", price),
                    new SqlParameter("@Unit", unit),
                    new SqlParameter("@Stock", stock),
                    new SqlParameter("@CategoryId", categoryId),
                    new SqlParameter("@ImageUrl", imageUrl));

                if (rowsAffected > 0)
                {
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    lblMessage.Text = "食材添加成功！";
                    // 清空表单
                    txtName.Text = "";
                    txtDescription.Text = "";
                    txtPrice.Text = "";
                    txtUnit.Text = "";
                    txtStock.Text = "";
                }
                else
                {
                    lblMessage.Text = "食材添加失败，请重试。";
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "错误：" + ex.Message;
            }
        }

        // 新增图片格式校验方法
        private bool IsValidImage(string fileName)
        {
            string ext = Path.GetExtension(fileName).ToLower();
            return ext == ".jpg" || ext == ".jpeg" || ext == ".png";
        }
    }
}