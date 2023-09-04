using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace IndianCuisine.Html
{
    public partial class Gallery : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindMedia("Image"); // Default: Show images
            }
        }

        protected void btnShowImages_Click(object sender, EventArgs e)
        {
            BindMedia("Image");
        }

        protected void btnShowVideos_Click(object sender, EventArgs e)
        {
            BindMedia("Video");
        }

        private void BindMedia(string mediaType)
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "SELECT Image_Video_Name, Image_Video_Thumbnail FROM image_videogallerytbl WHERE Image_Video_Type = @MediaType";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@MediaType", mediaType);
                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    rptMedia.DataSource = dataTable;
                    rptMedia.DataBind();
                }
            }
        }
    }
}