namespace Manzili.Core.Dto.CatagoryDto
{
    public class GetProductCatagoryDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string ? Image { get; set; }
        public int StoreCategoryId { get; set; }
    }
}
