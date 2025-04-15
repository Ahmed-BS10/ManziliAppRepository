using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Dto.StoreRateDto
{
    public class StoreRatingSummaryDto
    {
        public int StoreId { get; set; }
        public double AverageRating { get; set; }
        public int TotalRatings { get; set; }


        public List<CreateUserRateDto> Ratings { get; set; }



    }

}
    public class CreateUserRateDto
    {
        public string UserName { get; set; }
        public string? ImageUser  { get; set; }
        public double valueRate { get; set; }
        public DateTime DateTime { get; set; }
    }
