using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Entities
{
    public class Nofiy
    {

        public int Id { get; set; }

        [Required]
        public int SenderId { get; set; }    // معرف الـ User أو الـ Store الذي أرسل الإشعار

        [Required]
        public int ReceiverId { get; set; }  // معرف المتلقي (Store أو User)

        public string? Payload { get; set; }   // نص الـ JSON لبيانات الطلب أو بيانات المتجر


        public string? Type { get; set; }      // "OrderRequest" أو "OrderAccepted"

        public bool IsRead { get; set; } = false;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    }
}
