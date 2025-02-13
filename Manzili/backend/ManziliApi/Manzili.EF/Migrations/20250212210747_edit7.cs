using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Manzili.EF.Migrations
{
    /// <inheritdoc />
    public partial class edit7 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_StoreCategoryStore_Categories_StoreCategoryId",
                table: "StoreCategoryStore");

            migrationBuilder.CreateTable(
                name: "StoreCategory",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Image = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StoreCategory", x => x.Id);
                });

            migrationBuilder.AddForeignKey(
                name: "FK_StoreCategoryStore_StoreCategory_StoreCategoryId",
                table: "StoreCategoryStore",
                column: "StoreCategoryId",
                principalTable: "StoreCategory",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_StoreCategoryStore_StoreCategory_StoreCategoryId",
                table: "StoreCategoryStore");

            migrationBuilder.DropTable(
                name: "StoreCategory");

            migrationBuilder.AddForeignKey(
                name: "FK_StoreCategoryStore_Categories_StoreCategoryId",
                table: "StoreCategoryStore",
                column: "StoreCategoryId",
                principalTable: "Categories",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
