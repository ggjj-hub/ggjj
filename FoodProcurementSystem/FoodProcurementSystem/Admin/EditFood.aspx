<%@ Page Title="编辑食材" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="FoodProcurementSystem" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style>
        .form-container { max-width: 600px; margin: 20px auto; padding: 20px; box-shadow: 0 0 10px #ccc; }
        .form-group { margin-bottom: 15px; }
        .form-label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-control { width: 100%; padding: 8px; box-sizing: border-box; }
        .btn-save { background-color: #28a745; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; }
        .btn-cancel { background-color: #6c757d; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; margin-left: 10px; }
        .message { margin: 15px 0; padding: 10px; border-radius: 4px; }
        .error { background-color: #f8d7da; color: #721c24; }
        .success { background-color: #d4edda; color: #155724; }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <script runat="server" type="text/C#">
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 加载分类数据
                LoadCategories();
                
                // 获取食材ID
                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int foodId = Convert.ToInt32(Request.QueryString["id"]);
                    LoadFoodData(foodId);
                }
                else
                {
                    lblMessage.Text = "无效的食材ID";
                    lblMessage.CssClass = "message error";
                    btnSave.Enabled = false;
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

        private void LoadFoodData(int foodId)
        {
            DatabaseHelper dbHelper = new DatabaseHelper();
            string sql = "SELECT Id, FoodName, Price, Unit, Description, CategoryId, Stock, ImageUrl FROM Foods WHERE Id = @Id";
            DataTable dt = dbHelper.ExecuteQuery(sql, new SqlParameter("@Id", foodId));
            
            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                txtName.Text = row["FoodName"].ToString();
                txtDescription.Text = row["Description"].ToString();
                txtPrice.Text = row["Price"].ToString();
                txtUnit.Text = row["Unit"].ToString();
                txtStock.Text = row["Stock"].ToString();
                ddlCategory.SelectedValue = row["CategoryId"].ToString();
                imgFood.ImageUrl = row["ImageUrl"].ToString();
            }
            else
            {
                lblMessage.Text = "未找到食材信息";
                lblMessage.CssClass = "message error";
                btnSave.Enabled = false;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                int foodId = Convert.ToInt32(Request.QueryString["id"]);
                string name = txtName.Text.Trim();
                string description = txtDescription.Text.Trim();
                decimal price = Convert.ToDecimal(txtPrice.Text.Trim());
                string unit = txtUnit.Text.Trim();
                int stock = Convert.ToInt32(txtStock.Text.Trim());
                int categoryId = Convert.ToInt32(ddlCategory.SelectedValue);

                // 先获取原有图片路径
                DatabaseHelper dbHelper = new DatabaseHelper();
                string oldImageUrl = "";
                string getImgSql = "SELECT ImageUrl FROM Foods WHERE Id = @Id";
                DataTable dt = dbHelper.ExecuteQuery(getImgSql, new SqlParameter("@Id", foodId));
                if (dt.Rows.Count > 0)
                {
                    oldImageUrl = dt.Rows[0]["ImageUrl"].ToString();
                }
                else
                {
                    oldImageUrl = "/Images/default.jpg";
                }

                string imageUrl = oldImageUrl;
                if (fileImage != null && fileImage.HasFile)
                {
                    if (!IsValidImage(fileImage.FileName))
                        throw new Exception("只支持JPG/PNG格式");
                    string fileName = Guid.NewGuid().ToString() + System.IO.Path.GetExtension(fileImage.FileName);
                    string savePath = Server.MapPath("~/Images/" + fileName);
                    fileImage.SaveAs(savePath);
                    imageUrl = "/Images/" + fileName;
                }

                string sql = "UPDATE Foods SET FoodName = @Name, Description = @Description, Price = @Price, Unit = @Unit, Stock = @Stock, CategoryId = @CategoryId, ImageUrl = @ImageUrl WHERE Id = @Id";

                dbHelper.ExecuteNonQuery(sql,
                    new SqlParameter("@Id", foodId),
                    new SqlParameter("@Name", name),
                    new SqlParameter("@Description", description),
                    new SqlParameter("@Price", price),
                    new SqlParameter("@Unit", unit),
                    new SqlParameter("@Stock", stock),
                    new SqlParameter("@CategoryId", categoryId),
                    new SqlParameter("@ImageUrl", imageUrl));

                // 更新页面图片显示
                imgFood.ImageUrl = imageUrl;

                lblMessage.Text = "食材信息更新成功！";
                lblMessage.CssClass = "message success";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "更新失败：" + ex.Message;
                lblMessage.CssClass = "message error";
            }
        }

        // 新增图片格式校验方法
        private bool IsValidImage(string fileName)
        {
            string ext = System.IO.Path.GetExtension(fileName).ToLower();
            return ext == ".jpg" || ext == ".jpeg" || ext == ".png";
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageFoods.aspx");
        }
    </script>

    <div class="form-container">
        <h2>编辑食材</h2>
        <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>
        
        <div class="form-group">
            <label class="form-label">食材名称:</label>
            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" required></asp:TextBox>
        </div>
        
        <div class="form-group">
            <label class="form-label">分类:</label>
            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control"></asp:DropDownList>
        </div>
        
        <div class="form-group">
            <label class="form-label">价格(元):</label>
            <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" type="number" Step="0.01" required></asp:TextBox>
        </div>
        
        <div class="form-group">
            <label class="form-label">食材图片:</label>
            <asp:Image ID="imgFood" runat="server" Width="120px" Height="120px" style="margin-bottom:10px;" />
            <asp:FileUpload ID="fileImage" runat="server" CssClass="form-control" />
        </div>
        
        <div class="form-group">
            <label class="form-label">单位:</label>
            <asp:TextBox ID="txtUnit" runat="server" CssClass="form-control" required></asp:TextBox>
        </div>
        
        <div class="form-group">
            <label class="form-label">库存数量:</label>
            <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" type="number" required></asp:TextBox>
        </div>
        
        <div class="form-group">
            <label class="form-label">描述:</label>
            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
        </div>
        
        <div class="form-actions">
            <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn-save" OnClick="btnSave_Click" />
            <asp:Button ID="btnCancel" runat="server" Text="取消" CssClass="btn-cancel" OnClick="btnCancel_Click" />
        </div>
    </div>
</asp:Content>