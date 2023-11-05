namespace CrowdfundingWebsites.Models.EFModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Company
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Company()
        {
            Projects = new HashSet<Project>();
        }

        public int Id { get; set; }

        [Required]
        [StringLength(100)]
        public string Account { get; set; }

        [Required]
        [StringLength(256)]
        public string Email { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; }

        [Required]
        [StringLength(50)]
        public string Phone { get; set; }

        [Required]
        [StringLength(50)]
        public string UnifiedBusinessNo { get; set; }

        [Required]
        [StringLength(100)]
        public string ResponsiblePerson { get; set; }

        [Required]
        [StringLength(250)]
        public string Password { get; set; }

        public bool Status { get; set; }

        [StringLength(1000)]
        public string Introduce { get; set; }

        [StringLength(350)]
        public string Image { get; set; }

        public DateTime CreatedTime { get; set; }

        public DateTime? ApplyTime { get; set; }

        public DateTime UpdateTime { get; set; }

        [StringLength(250)]
        public string ConfirmCode { get; set; }

        public bool? IsConfirmed { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Project> Projects { get; set; }
    }
}
