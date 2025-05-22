using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Manzili.EF.Migrations
{
    /// <inheritdoc />
    public partial class chnagePdf : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PdfFile",
                table: "Orders");

            migrationBuilder.AddColumn<string>(
                name: "pathPdfFile",
                table: "Orders",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "pathPdfFile",
                table: "Orders");

            migrationBuilder.AddColumn<byte[]>(
                name: "PdfFile",
                table: "Orders",
                type: "varbinary(max)",
                nullable: true);
        }
    }
}
