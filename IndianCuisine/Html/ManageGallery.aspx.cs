using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace IndianCuisine.Html
{
    public partial class ManageGallery : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGridView();
            }
        }

        protected void btnAddFile_Click(object sender, EventArgs e)
        {
            if (fuFile.HasFile)
            {
                string fileType = ddlFileType.SelectedValue;
                string fileName = txtFileName.Text.Trim();
                string status = ddlStatus.SelectedValue;

                // Save the file to the SavedContent folder
                string uploadPath = Server.MapPath("~/SavedContent/");
                string extension = Path.GetExtension(fuFile.FileName);
                string uniqueFileName = Guid.NewGuid().ToString() + extension;
                string fileUrl = "~/SavedContent/" + uniqueFileName;
                fuFile.SaveAs(Path.Combine(uploadPath, uniqueFileName));

                // Upload thumbnail image if provided
                string thumbnailUrl = ""; // Initialize
                if (fuThumbnailImage.HasFile)
                {
                    UploadThumbnailImage(uniqueFileName, fuThumbnailImage);
                    thumbnailUrl = "~/SavedContent/Thumbnails/" + "thumb_" + uniqueFileName;
                }

                // Insert data into the database
                using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
                {
                    string query = "INSERT INTO image_videogallerytbl (Image_Video_Type, Image_Video_Name, Image_Video_Url, Image_Video_Thumbnail, Status) VALUES (@Type, @Name, @Url, @Thumbnail, @Status)";
                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@Type", fileType);
                        command.Parameters.AddWithValue("@Name", fileName);
                        command.Parameters.AddWithValue("@Url", fileUrl);
                        command.Parameters.AddWithValue("@Thumbnail", thumbnailUrl);
                        command.Parameters.AddWithValue("@Status", status);

                        connection.Open();
                        command.ExecuteNonQuery();
                    }
                }

                BindGridView();
            }
            else
            {
                popup.Style.Add("display", "block");
            }
        }

        private void UploadThumbnailImage(string uniqueFileName, FileUpload fuThumbnailImage)
        {
            string thumbnailUploadPath = Server.MapPath("~/SavedContent/Thumbnails/");
            string thumbnailDirectory = Path.GetDirectoryName(thumbnailUploadPath); // Get the directory path

            // Check if the directory exists, and create it if not
            if (!Directory.Exists(thumbnailDirectory))
            {
                Directory.CreateDirectory(thumbnailDirectory);
            }

            string extension = Path.GetExtension(fuThumbnailImage.FileName);
            string uniqueThumbnailFileName = "thumb_" + uniqueFileName;
            string thumbnailFileUrl = "~/SavedContent/Thumbnails/" + uniqueThumbnailFileName;
            fuThumbnailImage.SaveAs(Path.Combine(thumbnailUploadPath, uniqueThumbnailFileName));
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            // Get the ID of the selected row
            Button btnEdit = (Button)sender;
            int selectedID = Convert.ToInt32(btnEdit.CommandArgument);

            // Find the row in the grid view and hide the edit button
            foreach (GridViewRow row in gvMedia.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    int rowID = Convert.ToInt32(gvMedia.DataKeys[row.RowIndex].Value);
                    if (rowID == selectedID)
                    {
                        row.FindControl("btnEdit").Visible = false;
                        row.FindControl("btnUpdate").Visible = true;
                        row.FindControl("btnCancel").Visible = true;

                        // Populate the edit controls with data from the row
                        DropDownList ddlEditFileType = (DropDownList)row.FindControl("ddlEditFileType");
                        TextBox txtEditFileName = (TextBox)row.FindControl("txtEditFileName");
                        DropDownList ddlEditStatus = (DropDownList)row.FindControl("ddlEditStatus");
                        // Populate other controls as needed

                        ddlEditFileType.SelectedValue = ((Label)row.FindControl("lblMediaType")).Text;
                        txtEditFileName.Text = ((Label)row.FindControl("lblMediaName")).Text;
                        ddlEditStatus.SelectedValue = ((Label)row.FindControl("lblStatus")).Text;
                    }
                }
            }
        }

        protected void gvMedia_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvMedia.EditIndex = e.NewEditIndex;
            BindGridView();
        }

        protected void gvMedia_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int rowIndex = e.RowIndex;

            // Access the edited controls within the row
            DropDownList ddlEditMediaType = (DropDownList)gvMedia.Rows[rowIndex].FindControl("ddlEditMediaType");
            TextBox txtEditMediaName = (TextBox)gvMedia.Rows[rowIndex].FindControl("txt_Name");
            FileUpload fuEditFile = (FileUpload)gvMedia.Rows[rowIndex].FindControl("FileUpload1");
            FileUpload fuEditThumb = (FileUpload)gvMedia.Rows[rowIndex].FindControl("FileUpload2");
            DropDownList ddlEditStatus = (DropDownList)gvMedia.Rows[rowIndex].FindControl("ddlEditStatus");

            // Update database here using the updated values
            int id = Convert.ToInt32(gvMedia.DataKeys[rowIndex].Value);
            string mediaType = ddlEditMediaType.SelectedValue;
            string mediaName = txtEditMediaName.Text;
            string status = ddlEditStatus.SelectedValue;

            // Update the media item in the database
            UpdateMediaItem(id, mediaType, mediaName, status);

            // Upload new file if provided
            if (fuEditFile.HasFile && fuEditThumb.HasFile)
            {
                UploadNewFile(id, fuEditFile);
                UploadNewThumb(id, fuEditThumb);
            }

            // Exit edit mode
            gvMedia.EditIndex = -1;
            BindGridView();
        }

        protected void gvMedia_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Delete")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int id = Convert.ToInt32(gvMedia.DataKeys[rowIndex].Value);

                // Delete the media item from the database
                DeleteMediaItem(id);

                // Rebind the GridView to refresh the data
                BindGridView();
            }
        }

        protected void gvMedia_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int rowIndex = e.RowIndex;
            int id = Convert.ToInt32(gvMedia.DataKeys[rowIndex].Value);

            // Delete the media item from the database
            DeleteMediaItem(id);

            // Rebind the GridView to refresh the data
            BindGridView();
        }


        private void DeleteMediaItem(int id)
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "DELETE FROM image_videogallerytbl WHERE ID = @ID";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@ID", id);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }


        protected void gvMedia_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvMedia.EditIndex = -1;
            BindGridView();
        }

        private void BindGridView()
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "SELECT ID, Image_Video_Type, Image_Video_Name, Image_Video_Url, Image_Video_Thumbnail, Status FROM image_videogallerytbl"; // Include Image_Video_Thumbnail
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);

                    gvMedia.DataSource = dataTable;
                    gvMedia.DataKeyNames = new string[] { "ID" };
                    gvMedia.RowCommand += new GridViewCommandEventHandler(gvMedia_RowCommand);
                    gvMedia.RowDeleting += new GridViewDeleteEventHandler(gvMedia_RowDeleting);
                    gvMedia.DataBind();
                }
            }
        }

        // Update the media item in the database
        private void UpdateMediaItem(int id, string fileType, string fileName, string status)
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "UPDATE image_videogallerytbl SET Image_Video_Type = @Type, Image_Video_Name = @Name, Status = @Status WHERE ID = @ID";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@ID", id);
                    command.Parameters.AddWithValue("@Type", fileType);
                    command.Parameters.AddWithValue("@Name", fileName);
                    command.Parameters.AddWithValue("@Status", status);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        private void UploadNewFile(int id, FileUpload fuEditFile)
        {
            // Save the file to the SavedContent folder
            string uploadPath = Server.MapPath("~/SavedContent/");
            string extension = Path.GetExtension(fuEditFile.FileName);
            string uniqueFileName = Guid.NewGuid().ToString() + extension;
            string fileUrl = "~/SavedContent/" + uniqueFileName;
            fuEditFile.SaveAs(Path.Combine(uploadPath, uniqueFileName));

            // Update the file URL in the database
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "UPDATE image_videogallerytbl SET Image_Video_Url = @Url WHERE ID = @ID";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@ID", id);
                    command.Parameters.AddWithValue("@Url", fileUrl);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        private void UploadNewThumb(int id, FileUpload fuEditFile)
        {
            // Save the file to the SavedContent folder
            string uploadPath = Server.MapPath("~/SavedContent/Thumbnails/");
            string extension = Path.GetExtension(fuEditFile.FileName);
            string uniqueFileName = Guid.NewGuid().ToString() + extension;
            string fileUrl = "~/SavedContent/Thumbnails/" + uniqueFileName;
            fuEditFile.SaveAs(Path.Combine(uploadPath, uniqueFileName));

            // Update the file URL in the database
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "UPDATE image_videogallerytbl SET Image_Video_Thumbnail = @Thumbnail WHERE ID = @ID";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@ID", id);
                    command.Parameters.AddWithValue("@Thumbnail", fileUrl);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();
            SearchMedia(searchTerm);
        }

        protected void btnClearSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            BindGridView();
        }

        private void SearchMedia(string searchTerm)
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "SELECT ID, Image_Video_Type, Image_Video_Name, Image_Video_Url, Status FROM image_videogallerytbl WHERE Image_Video_Type LIKE @SearchTerm OR Image_Video_Name LIKE @SearchTerm";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    gvMedia.DataSource = dataTable;
                    gvMedia.DataBind();
                }
            }
        }

        protected void btnClosePopup_Click(object sender, EventArgs e)
        {
            popup.Style.Add("display", "none");
        }

    }
}
