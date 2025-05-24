using Manzili.Core.Dto.ReturnOrder;
using Manzili.Core.Services;
using Microsoft.EntityFrameworkCore;
using System.Drawing;

public class ReturnOrderServices : IReturnOrderServices
{
    readonly ManziliDbContext _db;
    readonly IFileService _fileService;

    public ReturnOrderServices(ManziliDbContext db, IFileService fileService)
    {
        _db = db;
        _fileService = fileService;
    }


    public async Task<OperationResult<bool>> CreateReturnOrder(CreateReturnOrder createReturn)
    {


        // 2. Upload PDF file
        string pdfPath = await _fileService.UploadImageAsync("Return-pdfs", createReturn.pdf);
        if (pdfPath == "FailedToUploadImage")
            return OperationResult<bool>.Failure("Failed to upload PDF file");


        var or = new ReturnOrder
        {
            UserName = createReturn.UserName,
            StoreName = createReturn.StoreName,
            pdfUrl = pdfPath

        };


        var create = await _db.ReturnOrders.AddAsync(or);
        await _db.SaveChangesAsync();

        return OperationResult<bool>.Success(true);
    }

    public async Task<OperationResult<IEnumerable<ReturnOrder>>> GetReturnOrder(int pageNumber, int size)
    {

        var returnsOrder = await _db.ReturnOrders
             .Skip((pageNumber - 1) * size)
             .Take(size)
             .ToListAsync();
        return OperationResult<IEnumerable<ReturnOrder>>.Success(returnsOrder);
    }

}