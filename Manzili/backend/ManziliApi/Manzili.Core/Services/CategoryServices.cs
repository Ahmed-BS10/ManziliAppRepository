using Manzili.Core.Dto.CatagoryDto;
using Manzili.Core.Dto.StoreDtp;
using Manzili.Core.Entities;
using Manzili.Core.Repositories;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.IO.IsolatedStorage;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Formats.Asn1.AsnWriter;

namespace Manzili.Core.Services
{
    public class CategoryServices
    {

        #region Fields
        readonly IRepository<Category> _categoryRepository;
        readonly FileService _fileService;
        #endregion

        #region Constructor
        public CategoryServices(IRepository<Category> categoryRepository, FileService fileService)
        {
            _categoryRepository = categoryRepository;
            _fileService = fileService;
        }
        #endregion

        #region Methods

        public async Task<OperationResult<CatagoryCreateDto>> Create(CatagoryCreateDto catagoryCreateDto)
        {
            if (catagoryCreateDto == null)
                return OperationResult<CatagoryCreateDto>.Failure(message: "Category cannot be null.");


            if (catagoryCreateDto.Image != null)
            {
                if (!ImageValidator.IsValidImage(catagoryCreateDto.Image, out string errorMessage))
                    return OperationResult<CatagoryCreateDto>.Failure(message: errorMessage);

                string imagePath = await _fileService.UploadImageAsync("Category", catagoryCreateDto.Image);
                if (imagePath == "FailedToUploadImage")
                    return OperationResult<CatagoryCreateDto>.Failure("Failed to upload image");


                var category = new Category
                {
                    Name = catagoryCreateDto.Name,
                    Image = imagePath
                };


                await _categoryRepository.AddAsync(category);

                return OperationResult<CatagoryCreateDto>.Success(catagoryCreateDto);


            }

            return OperationResult<CatagoryCreateDto>.Failure(message : "Image cannt be null");




        }

        #endregion


    }
}
