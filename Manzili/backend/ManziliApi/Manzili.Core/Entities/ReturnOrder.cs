public class ReturnOrder
{
    public int Id {  get; set; }
    public string UserName {  get; set; }
    public string StoreName { get; set; }
    public DateTime CreateAt {  get; set; } = DateTime.UtcNow;
    public string pdfUrl { get; set; }

}