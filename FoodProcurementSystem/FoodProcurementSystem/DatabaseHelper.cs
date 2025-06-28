using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace FoodProcurementSystem
{
    public class DatabaseHelper
    {
        private string connectionString;

        public DatabaseHelper()
        {
            // 从Web.config获取连接字符串
            connectionString = WebConfigurationManager.ConnectionStrings["FoodProcurementConnectionString"].ConnectionString;
        }

        // 执行查询并返回DataTable
        public DataTable ExecuteQuery(string sql, params SqlParameter[] parameters)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    command.Parameters.AddRange(parameters);
                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        DataTable dataTable = new DataTable();
                        adapter.Fill(dataTable);
                        return dataTable;
                    }
                }
            }
        }

        // 执行非查询命令(INSERT, UPDATE, DELETE)
        public int ExecuteNonQuery(string sql, params SqlParameter[] parameters)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    command.Parameters.AddRange(parameters);
                    return command.ExecuteNonQuery();
                }
            }
        }

        // 执行查询并返回第一行第一列的值
        public object ExecuteScalar(string sql, params SqlParameter[] parameters)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    command.Parameters.AddRange(parameters);
                    return command.ExecuteScalar();
                }
            }
        }

        // 获取所有分类
        public DataTable GetAllCategories()
        {
            string sql = "SELECT Id, Name FROM Categories ORDER BY Name";
            return ExecuteQuery(sql);
        }

        // 获取热门食材
        public DataTable GetPopularFoods(int topCount = 4)
        {
            string sql = "SELECT TOP (@TopCount) f.Id, f.FoodName, f.Description, f.Price, f.Unit, f.Stock, c.Name AS CategoryName " +
                         "FROM Foods f INNER JOIN Categories c ON f.CategoryId = c.Id " +
                         "ORDER BY f.Stock DESC";
            return ExecuteQuery(sql, new SqlParameter("@TopCount", topCount));
        }
    }
}