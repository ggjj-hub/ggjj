<%@ Page Title="删除食材" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="FoodProcurementSystem" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style>
        .form-container { max-width: 600px; margin: 20px auto; padding: 20px; box-shadow: 0 0 10px #ccc; }
        .form-group { margin-bottom: 15px; }
        .form-label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-control { width: 100%; padding: 8px; box-sizing: border-box; background-color: #f8f9fa; }
        .btn-delete { background-color: #dc3545; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; }
        .btn-cancel { background-color: #6c757d; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; margin-left: 10px; }
        .message { margin: 15px 0; padding: 10px; border-radius: 4px; }
        .error { background-color: #f8d7da; color: #721c24; }
        .warning { background-color: #fff3cd; color: #856404; }
        .confirm-section { margin: 20px 0; padding: 15px; background-color: #fff3cd; border-radius: 4px; }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <script runat="server" type="text/C#">
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
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
                    btnDelete.Enabled = false;
                }
            }
        }

        private void LoadFoodData(int foodId)
        {
            DatabaseHelper dbHelper = new DatabaseHelper();
            string sql = "SELECT f.Id, f.FoodName, f.Price, f.Unit, f.Description, f.Stock, c.Name AS CategoryName FROM Foods f INNER JOIN Categories c ON f.CategoryId = c.Id WHERE f.Id = @Id";
            DataTable dt = dbHelper.ExecuteQuery(sql, new SqlParameter("@Id", foodId));
            
            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                lblId.Text = row["Id"].ToString();
                lblName.Text = row["FoodName"].ToString();
                lblCategory.Text = row["CategoryName"].ToString();
                lblPrice.Text = row["Price"].ToString();
                lblUnit.Text = row["Unit"].ToString();
                lblStock.Text = row["Stock"].ToString();
                lblDescription.Text = row["Description"].ToString() ?? "无描述";
            }
            else
            {
                lblMessage.Text = "未找到食材信息";
                lblMessage.CssClass = "message error";
                btnDelete.Enabled = false;
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            try
            {
                int foodId = Convert.ToInt32(Request.QueryString["id"]);
                DatabaseHelper dbHelper = new DatabaseHelper();
                string sql = "DELETE FROM Foods WHERE Id = @Id";
                dbHelper.ExecuteNonQuery(sql, new SqlParameter("@Id", foodId));
                
                // 删除成功后重定向到食材管理页面
                Response.Redirect("ManageFoods.aspx");
            }
            catch (Exception ex)
            {
                lblMessage.Text = "删除失败：" + ex.Message;
                lblMessage.CssClass = "message error";
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageFoods.aspx");
        }
    </script>

    <div class="form-container">
        <h2>删除食材</h2>
        <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>
        
        <div class="confirm-section">
            <h4>确认删除以下食材？</h4>
            <p>此操作不可撤销，删除后食材数据将永久丢失。</p>
        </div>
        
        <div class="form-group">
            <label class="form-label">食材ID:</label>
            <asp:Label ID="lblId" runat="server" CssClass="form-control"></asp:Label>
        </div>
        
        <div class="form-group">
            <label class="form-label">食材名称:</label>
            <asp:Label ID="lblName" runat="server" CssClass="form-control"></asp:Label>
        </div>
        
        <div class="form-group">
            <label class="form-label">分类:</label>
            <asp:Label ID="lblCategory" runat="server" CssClass="form-control"></asp:Label>
        </div>
        
        <div class="form-group">
            <label class="form-label">价格(元):</label>
            <asp:Label ID="lblPrice" runat="server" CssClass="form-control"></asp:Label>
        </div>
        
        <div class="form-group">
            <label class="form-label">单位:</label>
            <asp:Label ID="lblUnit" runat="server" CssClass="form-control"></asp:Label>
        </div>
        
        <div class="form-group">
            <label class="form-label">库存数量:</label>
            <asp:Label ID="lblStock" runat="server" CssClass="form-control"></asp:Label>
        </div>
        
        <div class="form-group">
            <label class="form-label">描述:</label>
            <asp:Label ID="lblDescription" runat="server" CssClass="form-control"></asp:Label>
        </div>
        
        <div class="form-actions">
            <asp:Button ID="btnDelete" runat="server" Text="确认删除" CssClass="btn-delete" OnClick="btnDelete_Click" />
            <asp:Button ID="btnCancel" runat="server" Text="取消" CssClass="btn-cancel" OnClick="btnCancel_Click" />
        </div>
    </div>
</asp:Content>