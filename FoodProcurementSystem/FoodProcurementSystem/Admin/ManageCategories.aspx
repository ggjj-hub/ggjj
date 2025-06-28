<%@ Page Title="分类管理" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style>
        .manage-container { padding: 20px; }
        .grid-view { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .grid-view th { background-color: #f2f2f2; padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        .grid-view td { padding: 10px; border-bottom: 1px solid #ddd; }
        .btn-add { background-color: #28a745; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; margin-bottom: 15px; }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <script runat="server" type="text/C#">
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminLoggedIn"] == null || !(bool)Session["AdminLoggedIn"])
            {
                Response.Write("<script>alert('请以管理员登录后再试'); window.location.href='Login.aspx';</script>");
                Response.End();
            }
        }
    </script>
    <div class="manage-container">
        <h2>分类管理</h2>
        <asp:Button ID="btnAddNew" runat="server" Text="添加新分类" CssClass="btn-add" OnClick="btnAddNew_Click" />
        
        <asp:GridView ID="gvCategories" runat="server" CssClass="grid-view" AutoGenerateColumns="false"
            OnRowEditing="gvCategories_RowEditing" OnRowDeleting="gvCategories_RowDeleting" DataKeyNames="Id">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="分类ID" ReadOnly="true" />
                <asp:BoundField DataField="Name" HeaderText="分类名称" />
                <asp:CommandField ShowEditButton="true" EditText="编辑" CancelText="取消" UpdateText="更新" />
                <asp:CommandField ShowDeleteButton="true" DeleteText="删除" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>