using System;

namespace FoodProcurementSystem
{
    /// <summary>
    /// 购物清单项目类，用于存储购物车中的食材信息
    /// </summary>
    public class CartItem
    {
        /// <summary>
        /// 食材ID
        /// </summary>
        public int FoodId { get; set; }

        /// <summary>
        /// 食材名称
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// 单价
        /// </summary>
        public decimal Price { get; set; }
        public string ImageUrl { get; set; }

        public string Unit { get; set; }

        /// <summary>
        /// 数量
        /// </summary>
        public int Quantity { get; set; }

        /// <summary>
        /// 小计金额
        /// </summary>
        public decimal Subtotal
        {
            get { return Price * Quantity; }
        }
    }
}