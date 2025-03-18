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
        public Dictionary<int, int> RatingsBreakdown { get; set; } = new();  
    }
}
