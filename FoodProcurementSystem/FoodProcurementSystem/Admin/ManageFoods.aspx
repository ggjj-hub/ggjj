<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="FoodProcurementSystem" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style>
        .manage-container { padding: 20px; }
        .grid-view { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .grid-view th { background-color: #f2f2f2; padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        .grid-view td { padding: 10px; border-bottom: 1px solid #ddd; }
        .btn-add { background-color: #28a745; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; margin-bottom: 15px; }
        .btn-edit { background-color: #007bff; color: white; border: none; padding: 8px 12px; border-radius: 4px; cursor: pointer; margin-right: 8px; display: inline-block; min-width: 60px; text-align: center; }
        .btn-delete { background-color: #dc3545; color: white; border: none; padding: 8px 12px; border-radius: 4px; cursor: pointer; display: inline-block; min-width: 60px; text-align: center; }
        .error-message { color: #dc3545; padding: 10px; margin: 15px 0; border: 1px solid #f5c6cb; background-color: #f8d7da; border-radius: 4px; }
        .status-message { color: #28a745; padding: 10px; margin: 15px 0; border: 1px solid #c3e6cb; background-color: #d4edda; border-radius: 4px; }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <script runat="server" type="text/C#">
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminLoggedIn"] == null || !(bool)Session["AdminLoggedIn"])
            {
                Page.ClientScript.RegisterStartupScript(this.GetType(), "AdminLoginAlert", "alert('请以管理员登录后再试'); window.location.href='Login.aspx';", true);
                Response.End();
            }
            
            if (!IsPostBack)
            {
                BindFoodData();
            }
        }

        protected void btnAddNew_Click(object sender, EventArgs e)
{
    // 跳转到添加新食材页面
    Response.Redirect("AddFood.aspx");
}

protected void BindFoodData()
    {
        try
        {
            // 使用DatabaseHelper获取食材数据
            DatabaseHelper dbHelper = new DatabaseHelper();
            string sql = "SELECT f.Id, f.FoodName, f.Price, f.Unit, f.Description, f.Stock, c.Name AS CategoryName FROM Foods f LEFT JOIN Categories c ON f.CategoryId = c.Id";
            DataTable dt = dbHelper.ExecuteQuery(sql);
            
            if (dt != null)
            {
                lblError.Visible = false;
                gvFoods.DataSource = dt;
                gvFoods.DataBind();
                // 添加调试信息
                System.Diagnostics.Debug.WriteLine("食材数据加载成功，共" + dt.Rows.Count + "条记录");
                lblStatus.Visible = true;
                lblStatus.Text = "已加载 " + dt.Rows.Count + " 条食材数据";
                gvFoods.Visible = true;
            }
            else
            {
                ShowErrorMessage("无法加载食材数据，请稍后重试");
            }
        }
        catch (Exception ex)
        {
            ShowErrorMessage("加载数据时出错: " + ex.Message);
        }
    }
    
    private void ShowErrorMessage(string message)
    {
        lblError.Visible = true;
        lblError.Text = message;
        lblError.CssClass = "error-message";
    }

protected void btnEdit_Click(object sender, EventArgs e)
{
    Button btn = (Button)sender;
    int foodId = Convert.ToInt32(btn.CommandArgument);
    Response.Redirect(String.Format("EditFood.aspx?id={0}", foodId));
}

protected void btnDelete_Click(object sender, EventArgs e)
{
    Button btn = (Button)sender;
    int foodId = Convert.ToInt32(btn.CommandArgument);
    Response.Redirect(String.Format("DeleteFood.aspx?id={0}", foodId));
}
    </script>
    <div class="manage-container">
        <h2>食材管理</h2>
        <asp:Button ID="btnAddNew" runat="server" Text="添加新食材" CssClass="btn-add" OnClick="btnAddNew_Click" />
        
        <asp:Label ID="lblError" runat="server" Visible="false"></asp:Label>
        <asp:Label ID="lblStatus" runat="server" Visible="false" CssClass="status-message"></asp:Label>
        <asp:GridView ID="gvFoods" runat="server" CssClass="grid-view" AutoGenerateColumns="false"
            DataKeyNames="Id" EmptyDataText="暂无食材数据，请点击\"添加新食材\"按钮创建">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="ID" ReadOnly="true" />
                <asp:BoundField DataField="FoodName" HeaderText="食材名称" SortExpression="FoodName" />
                <asp:BoundField DataField="CategoryName" HeaderText="分类" />
                <asp:BoundField DataField="Price" HeaderText="价格(元)" />
                <asp:BoundField DataField="Unit" HeaderText="单位" />
                <asp:BoundField DataField="Stock" HeaderText="库存" />
                <asp:TemplateField HeaderText="操作">
            <ItemTemplate>
                <asp:Button ID="btnEdit" runat="server" Text="编辑" CssClass="btn-edit" OnClick="btnEdit_Click" CommandArgument='<%# Eval("Id") %>' />
                <asp:Button ID="btnDelete" runat="server" Text="删除" CssClass="btn-delete" OnClick="btnDelete_Click" CommandArgument='<%# Eval("Id") %>' />
                <asp:Literal ID="litDebug" runat="server" Text='<%# "调试: ID=" + Eval("Id") %>' Visible="false" />
            </ItemTemplate>
        </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>