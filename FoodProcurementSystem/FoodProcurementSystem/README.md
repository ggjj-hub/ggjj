# 食品采购系统

## 项目简介
这是一个基于ASP.NET Web Forms的食品采购管理系统，专为Microsoft Visual Studio 2010和SQL Server 2008环境设计。

## 系统要求
- Microsoft Visual Studio 2010
- SQL Server 2008 或更高版本
- .NET Framework 3.5
- IIS 7.0 或更高版本（可选，用于部署）

## 安装步骤

### 1. 数据库设置
1. 打开SQL Server Management Studio
2. 连接到您的SQL Server实例
3. 执行 `App_Data/CreateDatabase.sql` 脚本创建数据库和表
4. 脚本会自动创建：
   - FoodProcurement 数据库
   - Categories（分类表）
   - Foods（食材表）
   - Users（用户表）
   - ProcurementRequests（采购请求表）
   - 示例数据

### 2. 项目配置
1. 在Visual Studio 2010中打开项目
2. 修改 `Web.config` 中的数据库连接字符串：
   ```xml
   <add name="FoodProcurementConnectionString"
        connectionString="data source=您的服务器名称;Integrated Security=SSPI;Initial Catalog=FoodProcurement;MultipleActiveResultSets=true"
        providerName="System.Data.SqlClient" />
   ```
3. 如果使用SQL Server Express，请将 `data source=您的服务器名称` 改为 `data source=.\SQLEXPRESS`

### 3. 编译和运行
1. 在Visual Studio 2010中按F5或点击"开始调试"
2. 系统会自动启动ASP.NET Development Server
3. 浏览器会自动打开项目首页

## 功能特性

### 前台功能
- **首页展示**：显示食材分类和热门食材
- **分类浏览**：按分类查看食材列表
- **食材详情**：查看食材详细信息
- **采购清单**：添加食材到采购清单

### 后台管理
- **管理员登录**：用户名：admin，密码：admin123
- **食材管理**：添加、编辑、删除食材
- **分类管理**：管理食材分类
- **采购请求管理**：处理采购请求

## 数据库结构

### Categories（分类表）
- Id：主键
- Name：分类名称
- Description：分类描述
- CreateDate：创建时间

### Foods（食材表）
- Id：主键
- Name：食材名称
- Description：食材描述
- Price：价格
- Unit：单位
- Stock：库存
- CategoryId：分类ID（外键）
- CreateDate：创建时间
- UpdateDate：更新时间

### Users（用户表）
- Id：主键
- Username：用户名
- Password：密码
- Email：邮箱
- Role：角色（Admin/User）
- CreateDate：创建时间

### ProcurementRequests（采购请求表）
- Id：主键
- FoodId：食材ID（外键）
- Quantity：数量
- RequestDate：请求时间
- Status：状态
- RequestedBy：请求人
- Notes：备注

## 技术架构
- **前端**：ASP.NET Web Forms + CSS3 + JavaScript
- **后端**：C# + .NET Framework 3.5
- **数据库**：SQL Server 2008
- **数据访问**：ADO.NET + 自定义DatabaseHelper类

## 文件结构
```
FoodProcurementSystem/
├── App_Data/
│   └── CreateDatabase.sql    # 数据库创建脚本
├── Admin/
│   ├── Login.aspx            # 管理员登录
│   ├── ManageFoods.aspx      # 食材管理
│   ├── ManageCategories.aspx # 分类管理
│   └── ManageRequests.aspx   # 采购请求管理
├── Account/                  # 用户账户相关页面
├── Styles/
│   └── Site.css             # 样式文件
├── Scripts/                  # JavaScript文件
├── Default.aspx             # 首页
├── Categories.aspx          # 分类页面
├── FoodDetails.aspx         # 食材详情页
├── Site.Master             # 主页面模板
├── DatabaseHelper.cs        # 数据库访问类
└── Web.config              # 配置文件
```

## 常见问题

### 1. 数据库连接失败
- 检查SQL Server服务是否启动
- 确认连接字符串中的服务器名称正确
- 确认数据库已创建

### 2. 编译错误
- 确保使用Visual Studio 2010
- 确保.NET Framework 3.5已安装
- 检查项目引用是否完整

### 3. 页面显示异常
- 检查CSS文件是否正确加载
- 确认JavaScript文件路径正确
- 检查浏览器兼容性

## 开发说明
- 项目使用ASP.NET Web Forms技术
- 采用三层架构：表现层、业务逻辑层、数据访问层
- 使用ADO.NET进行数据库操作
- 支持响应式设计，兼容移动设备

## 联系方式
如有问题，请联系开发团队。

---
© 2024 食品采购系统 