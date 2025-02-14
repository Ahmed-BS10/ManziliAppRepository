using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Manzili.EF.Migrations
{
    /// <inheritdoc />
    public partial class edit12 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_StoreCategoryStore_AspNetUsers_StoreId",
                table: "StoreCategoryStore");

            migrationBuilder.DropForeignKey(
                name: "FK_StoreCategoryStore_StoreCategory_StoreCategoryId",
                table: "StoreCategoryStore");

            migrationBuilder.DropPrimaryKey(
                name: "PK_StoreCategoryStore",
                table: "StoreCategoryStore");

            migrationBuilder.DropPrimaryKey(
                name: "PK_StoreCategory",
                table: "StoreCategory");

            migrationBuilder.RenameTable(
                name: "StoreCategoryStore",
                newName: "StoreCategoryStores");

            migrationBuilder.RenameTable(
                name: "StoreCategory",
                newName: "StoreCategories");

            migrationBuilder.RenameIndex(
                name: "IX_StoreCategoryStore_StoreId",
                table: "StoreCategoryStores",
                newName: "IX_StoreCategoryStores_StoreId");

            migrationBuilder.RenameIndex(
                name: "IX_StoreCategoryStore_StoreCategoryId",
                table: "StoreCategoryStores",
                newName: "IX_StoreCategoryStores_StoreCategoryId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_StoreCategoryStores",
                table: "StoreCategoryStores",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_StoreCategories",
                table: "StoreCategories",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_StoreCategoryStores_AspNetUsers_StoreId",
                table: "StoreCategoryStores",
                column: "StoreId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_StoreCategoryStores_StoreCategories_StoreCategoryId",
                table: "StoreCategoryStores",
                column: "StoreCategoryId",
                principalTable: "StoreCategories",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_StoreCategoryStores_AspNetUsers_StoreId",
                table: "StoreCategoryStores");

            migrationBuilder.DropForeignKey(
                name: "FK_StoreCategoryStores_StoreCategories_StoreCategoryId",
                table: "StoreCategoryStores");

            migrationBuilder.DropPrimaryKey(
                name: "PK_StoreCategoryStores",
                table: "StoreCategoryStores");

            migrationBuilder.DropPrimaryKey(
                name: "PK_StoreCategories",
                table: "StoreCategories");

            migrationBuilder.RenameTable(
                name: "StoreCategoryStores",
                newName: "StoreCategoryStore");

            migrationBuilder.RenameTable(
                name: "StoreCategories",
                newName: "StoreCategory");

            migrationBuilder.RenameIndex(
                name: "IX_StoreCategoryStores_StoreId",
                table: "StoreCategoryStore",
                newName: "IX_StoreCategoryStore_StoreId");

            migrationBuilder.RenameIndex(
                name: "IX_StoreCategoryStores_StoreCategoryId",
                table: "StoreCategoryStore",
                newName: "IX_StoreCategoryStore_StoreCategoryId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_StoreCategoryStore",
                table: "StoreCategoryStore",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_StoreCategory",
                table: "StoreCategory",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_StoreCategoryStore_AspNetUsers_StoreId",
                table: "StoreCategoryStore",
                column: "StoreId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_StoreCategoryStore_StoreCategory_StoreCategoryId",
                table: "StoreCategoryStore",
                column: "StoreCategoryId",
                principalTable: "StoreCategory",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
