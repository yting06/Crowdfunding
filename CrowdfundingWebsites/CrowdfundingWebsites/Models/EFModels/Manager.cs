namespace CrowdfundingWebsites.Models.EFModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Manager
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Manager()
        {
            ManagerRoleRels = new HashSet<ManagerRoleRel>();
        }

        public int Id { get; set; }

        [Required]
        [StringLength(250)]
        public string Account { get; set; }

        [Required]
        [StringLength(250)]
        public string Password { get; set; }

        [Required]
        [StringLength(250)]
        public string Email { get; set; }

        [Required]
        [StringLength(550)]
        public string FirstName { get; set; }

        [Required]
        [StringLength(550)]
        public string LastName { get; set; }

        public DateTime? Birthday { get; set; }

        public bool Enabled { get; set; }

        public DateTime CreatedTime { get; set; }

        public DateTime UpdateTime { get; set; }

        [StringLength(150)]
        public string ConfirmCode { get; set; }

        public bool? IsConfirmed { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ManagerRoleRel> ManagerRoleRels { get; set; }
    }
}
