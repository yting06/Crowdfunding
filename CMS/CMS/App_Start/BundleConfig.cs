using System.Web;
using System.Web.Optimization;

namespace CrowdfundingWebsites
{
    public class BundleConfig
    {
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-3.4.1.js"));

            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new Bundle("~/bundles/bootstrap").Include(
                "~/Scripts/bootstrap.bundle.js"));

            bundles.Add(new StyleBundle("~/font/css").Include(
                      "~/Content/fontawesome-free-6.4.2-web/css/all.min.css",
                      "~/Content/bootstrap-icons-1.10.5/font/bootstrap-icons.min.css"));

            /* library js */
            bundles.Add(new Bundle("~/lib/javascript").Include(
                "~/Scripts/lib/ckeditor5/ckeditor.js",
                "~/Scripts/lib/DataTable/datatables.min.js",
                      "~/Scripts/lib/easing/easing.min.js",
                      "~/Scripts/lib/waypoints/waypoints.min.js",
                      "~/Scripts/lib/owlcarousel/owl.carousel.min.js",
                      "~/Scripts/lib/tempusdominus/js/moment.min.js",
                      "~/Scripts/lib/tempusdominus/js/moment-timezone.min.js",
                      "~/Scripts/lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                "~/Scripts/lib/DataTable/datatables.min.css",
                      "~/Content/floating-labels.css",
                      "~/Content/bootstrap/bootstrap.min.css",
                      "~/Content/style.css"));

            bundles.Add(new Bundle("~/javascript/init").Include(
                      "~/js/globalfunc.js",
                      "~/js/Components/TableHelper.js",
                      "~/js/Components/UploadFileHelper.js",
                      "~/js/Components/Modal.js",
                      "~/js/_Layout.js"));

        }
    }
}
