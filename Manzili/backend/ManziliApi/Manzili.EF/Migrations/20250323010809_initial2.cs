using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Manzili.EF.Migrations
{
    /// <inheritdoc />
    public partial class initial2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "StoreCategories",
                columns: new[] { "Id", "Image", "Name" },
                values: new object[,]
                {
                    { 1, null, "الإلكترونيات" },
                    { 2, null, "الملابس" },
                    { 3, null, "الأثاث المنزلي" }
                });

            migrationBuilder.InsertData(
                table: "ProductCategories",
                columns: new[] { "Id", "Image", "Name", "StoreCategoryId" },
                values: new object[,]
                {
                    { 1, "smartphones.jpg", "هواتف ذكية", 1 },
                    { 2, "laptops.jpg", "لابتوبات", 1 },
                    { 3, "mens-clothing.jpg", "ملابس رجالية", 2 },
                    { 4, "womens-clothing.jpg", "ملابس نسائية", 2 },
                    { 5, "sofas.jpg", "أرائك", 3 },
                    { 6, "tables.jpg", "طاولات", 3 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "ProductCategories",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "ProductCategories",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "ProductCategories",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "ProductCategories",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "ProductCategories",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "ProductCategories",
                keyColumn: "Id",
                keyValue: 6);

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
