<%@ Page Title="请求管理" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style>
        .manage-container { padding: 20px; }
        .grid-view { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .grid-view th { background-color: #f2f2f2; padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        .grid-view td { padding: 10px; border-bottom: 1px solid #ddd; }
        .status-pending { color: #ffc107; }
        .status-approved { color: #28a745; }
        .status-rejected { color: #dc3545; }
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
        <h2>采购需求管理</h2>
        
        <asp:GridView ID="gvRequests" runat="server" CssClass="grid-view" AutoGenerateColumns="false"
            OnRowCommand="gvRequests_RowCommand" DataKeyNames="Id">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="需求ID" ReadOnly="true" />
                <asp:BoundField DataField="FoodName" HeaderText="食材名称" ReadOnly="true" />
                <asp:BoundField DataField="Quantity" HeaderText="数量" ReadOnly="true" />
                <asp:BoundField DataField="Unit" HeaderText="单位" ReadOnly="true" />
                <asp:BoundField DataField="RequestDate" HeaderText="申请日期" DataFormatString="{0:yyyy-MM-dd}" ReadOnly="true" />
                <asp:TemplateField HeaderText="状态">
                    <ItemTemplate>
                        <span class='<%# GetStatusClass(Eval("Status").ToString()) %>'><%# Eval("Status") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:ButtonField Text="批准" CommandName="Approve" ButtonType="Button" />
                <asp:ButtonField Text="拒绝" CommandName="Reject" ButtonType="Button" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>