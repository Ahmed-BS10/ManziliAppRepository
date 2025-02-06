using Manzili.Core.Dto.CatagoryDto;
using Manzili.Core.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using static Manzili.Core.Routes.Route;

namespace ManziliApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CategoryController : ControllerBase
    {
        #region Fields

        readonly CategoryServices _categoryServices;
        #endregion

        #region Constructor

        public CategoryController(CategoryServices categoryServices)
        {
            _categoryServices = categoryServices;
        }
        #endregion

        #region Endpoint


        [HttpGet(CategoryRouting.List)]
        public async Task<IActionResult> GetAll()
        {
            var result = await _categoryServices.GetList();
            if (!result.IsSuccess)
                return NotFound(result);

            return Ok(result);
        }

        [HttpPost(CategoryRouting.Create)]
        public async Task<IActionResult> Create(CatagoryCreateDto catagoryCreate)
        {
            var result = await _categoryServices.Create(catagoryCreate);
            if(result.IsSuccess)
                return Ok(result);

            return BadRequest(result);
        }

        [HttpPut(CategoryRouting.Update)]
        public async Task<IActionResult> Update(int id, [FromForm] CatagoryUpdateDto catagoryUpdateDto)
        {
            var result = await _categoryServices.Update(id, catagoryUpdateDto);
            if (!result.IsSuccess)
                return BadRequest(result);

            return Ok(result);
        }





        [HttpDelete("DeleteImage")]
        public async Task<IActionResult> DeleteImage(string imageName = "6acff1a84961473398a33f7877adbafc.jpg")
        {
            if (string.IsNullOrWhiteSpace(imageName))
                return BadRequest("Invalid image name.");

            // المسار إلى wwwroot/Profile
            var wwwRootPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Profile");
            var imagePath = Path.Combine(wwwRootPath, imageName);

            if (!System.IO.File.Exists(imagePath))
                return NotFound("Image not found.");

            try
            {
                System.IO.File.Delete(imagePath);
                return Ok("Image deleted successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Failed to delete image: {ex.Message}");
            }
        }





        //[HttpDelete(CategoryRouting.Delete)]
        //public async Task<IActionResult> Delete(int id)
        //{
        //    var result = await _categoryServices.De(id);

        //    if (!result.IsSuccess)
        //        return NotFound(new { message = result.Message });

        //    return Ok(new { message = "Category deleted successfully" });
        //}

        #endregion
    }
}
