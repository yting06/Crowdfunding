using System.Web;
using System.Web.Optimization;

namespace CrowdfundingWebsites
{
    public class BundleConfig
    {
        // For more information on bundling, visit https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at https://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            //include js
            bundles.Add(new Bundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.bundle.js"));


            bundles.Add(new Bundle("~/lib/javascript").Include(
                      "~/Scripts/lib/easing/easing.min.js",
                      "~/Scripts/lib/waypoints/waypoints.min.js",
                      "~/Scripts/lib/owlcarousel/owl.carousel.min.js",
                      "~/Scripts/lib/tempusdominus/js/moment.min.js",
                      "~/Scripts/lib/tempusdominus/js/moment-timezone.min.js",
                      "~/Scripts/lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"));

            bundles.Add(new Bundle("~/javascript/init").Include(
                      "~/js/main.js"));
            bundles.Add(new Bundle("~/javascript/init").Include(
                      "~/js/main.js"));

            //include CSS
            bundles.Add(new StyleBundle("~/font/css").Include(
                      "~/Content/fontawesome-free-6.4.2-web/css/all.min.css",
                      "~/Content/bootstrap-icons-1.10.5/font/bootstrap-icons.min.css"));

            bundles.Add(new StyleBundle("~/lib/css").Include(
                     "~/Scripts/lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css",
                     "~/Scripts/lib/owlcarousel/assets/owl.carousel.min.css"));



            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap/bootstrap.min.css",
                      "~/Content/style.css"));



        }
    }
}
