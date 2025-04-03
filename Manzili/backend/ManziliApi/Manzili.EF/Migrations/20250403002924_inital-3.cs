using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Manzili.EF.Migrations
{
    /// <inheritdoc />
    public partial class inital3 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Products",
                columns: new[] { "Id", "CartId", "Description", "Discount", "Name", "Price", "ProductCategoryId", "Quantity", "Rate", "State", "StoreId" },
                values: new object[,]
                {
                    { 1, null, "قميص قطني عالي الجودة", 10.0, "قميص رجالي", 199.99000000000001, 1, 50, null, "Available", 6 },
                    { 2, null, "أحدث هاتف ذكي بمواصفات عالية", null, "هاتف ذكي", 5999.9899999999998, 3, 20, null, "Available", 7 },
                    { 3, null, "كنبة فخمة من الجلد الطبيعي", 15.0, "كنبة", 3499.9899999999998, 5, 10, null, "Available", 8 },
                    { 4, null, "عسل نحل طبيعي 100%", 5.0, "عسل طبيعي", 149.99000000000001, 5, 30, null, "Available", 10 },
                    { 5, null, "بنطال جينز رجالي مقاوم للتجاعيد", null, "بنطال جينز", 299.99000000000001, 1, 40, null, "Available", 6 },
                    { 6, null, "لابتوب بمواصفات عالية للألعاب", 20.0, "لابتوب", 12999.99, 4, 15, null, "Available", 7 },
                    { 7, null, "طاولة طعام خشبية لـ 6 أشخاص", null, "طاولة طعام", 2499.9899999999998, 5, 8, null, "Available", 8 },
                    { 8, null, "كتاب يحتوي على وصفات من المطبخ العربي", null, "كتاب طبخ", 149.99000000000001, 5, 25, null, "Available", 9 },
                    { 9, null, "تمر مجدول عالي الجودة", null, "تمر", 89.989999999999995, 5, 60, null, "Available", 10 },
                    { 10, null, "أحدث الروايات العربية", null, "رواية", 99.989999999999995, 5, 100, null, "Available", 9 }
                });

            //migrationBuilder.InsertData(
            //    table: "StoreCategories",
            //    columns: new[] { "Id", "Image", "Name" },
            //    values: new object[,]
            //    {
            //        { 1, null, "الإلكترونيات" },
            //        { 2, null, "الملابس" },
            //        { 3, null, "الأثاث المنزلي" }
            //    });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Products",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Products",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Products",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Products",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Products",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Products",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Products",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Products",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Products",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Products",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "StoreCategories",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "StoreCategories",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "StoreCategories",
                keyColumn: "Id",
                keyValue: 3);
        }
    }
}
