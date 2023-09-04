using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;

namespace IndianCuisine.Html
{
    public partial class ManageMenuCategory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadMenuCategories();
            }
        }

        protected void LoadMenuCategories()
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "SELECT ID, Category_Name, Category_URl, Category_Status FROM MenuCategory";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    gvMenuCategories.DataSource = dataTable;
                    gvMenuCategories.DataKeyNames = new string[] { "ID" }; // Add this line
                    gvMenuCategories.RowCommand += new GridViewCommandEventHandler(gvMenuCategories_RowCommand); // Add this line
                    gvMenuCategories.RowDeleting += new GridViewDeleteEventHandler(gvMenuCategories_RowDeleting);
                    gvMenuCategories.DataBind();
                }
            }
        }

        protected void btnAddMenuCategory_Click(object sender, EventArgs e)
        {
            if (fuMenuCategory.HasFile)
            {
                string fileName = txtMenuCategoryName.Text.Trim();
                string status = ddlMenuCategoryStatus.SelectedValue;

                // Save the file to the SavedContent folder
                string uploadPath = Server.MapPath("~/SavedContent/");
                string extension = Path.GetExtension(fuMenuCategory.FileName);
                string uniqueFileName = Guid.NewGuid().ToString() + extension;
                string fileUrl = "~/SavedContent/" + uniqueFileName;
                fuMenuCategory.SaveAs(Path.Combine(uploadPath, uniqueFileName));

                using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
                {
                    string query = "INSERT INTO MenuCategory (Category_Name, Category_Url, Category_Status) VALUES (@Name, @Url, @Status); SELECT SCOPE_IDENTITY();";
                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@Name", fileName);
                        command.Parameters.AddWithValue("@Url", fileUrl);
                        command.Parameters.AddWithValue("@Status", status);

                        connection.Open();
                        int categoryId = Convert.ToInt32(command.ExecuteScalar()); // Get the inserted category's ID

                        LoadMenuCategories();
                    }
                }
            }

            else
            {
                // Display a popup if no image uploaded
                popup.Style["display"] = "block";
            }
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearchCategory.Text.Trim();
            SearchMedia(searchTerm);
        }

        private void SearchMedia(string searchTerm)
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "SELECT ID, Category_Name, Category_Url, Category_Status FROM MenuCategory WHERE Category_Name LIKE @SearchTerm";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    gvMenuCategories.DataSource = dataTable;
                    gvMenuCategories.DataBind();
                }
            }
        }


        protected void btnClearSearchCategory_Click(object sender, EventArgs e)
        {
            txtSearchCategory.Text = "";
            LoadMenuCategories();
        }

        protected void gvMenuCategories_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvMenuCategories.EditIndex = e.NewEditIndex;
            LoadMenuCategories();
        }

        protected void gvMenuCategories_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvMenuCategories.EditIndex = -1;
            LoadMenuCategories();
        }

        protected void gvMenuCategories_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int rowIndex = e.RowIndex;

            // Access the edited controls within the row
            TextBox txtEditMediaName = (TextBox)gvMenuCategories.Rows[rowIndex].FindControl("txtEditCategoryName");
            FileUpload fuEditFile = (FileUpload)gvMenuCategories.Rows[rowIndex].FindControl("fuEditCategory");
            DropDownList ddlEditStatus = (DropDownList)gvMenuCategories.Rows[rowIndex].FindControl("ddlEditCategoryStatus");

            // Update database here using the updated values
            int id = Convert.ToInt32(gvMenuCategories.DataKeys[rowIndex].Value);
            string mediaName = txtEditMediaName.Text;
            string status = ddlEditStatus.SelectedValue;

            // Update the media item in the database
            UpdateMediaItem(id, mediaName, status);

            // Upload new file if provided
            if (fuEditFile.HasFile)
            {
                UploadNewFile(id, fuEditFile);
            }

            gvMenuCategories.EditIndex = -1;
            LoadMenuCategories();
        }


        protected void btnEdit_Click(object sender, EventArgs e)
        {
            // Get the ID of the selected row
            Button btnEdit = (Button)sender;
            int selectedID = Convert.ToInt32(btnEdit.CommandArgument);

            // Find the row in the grid view and hide the edit button
            foreach (GridViewRow row in gvMenuCategories.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    int rowID = Convert.ToInt32(gvMenuCategories.DataKeys[row.RowIndex].Value);
                    if (rowID == selectedID)
                    {
                        row.FindControl("btnEdit").Visible = false;
                        row.FindControl("btnUpdate").Visible = true;
                        row.FindControl("btnCancel").Visible = true;

                        TextBox txtEditFileName = (TextBox)row.FindControl("txtEditCategoryName");
                        DropDownList ddlEditStatus = (DropDownList)row.FindControl("ddlEditCategoryStatus");
                        // Populate other controls as needed

                        txtEditFileName.Text = ((Label)row.FindControl("lblCategoryName")).Text;
                        ddlEditStatus.SelectedValue = ((Label)row.FindControl("lblCategoryStatus")).Text;
                    }
                }
            }
        }

        private void UpdateMediaItem(int id, string fileName, string status)
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "UPDATE MenuCategory SET Category_Name = @Name, Category_Status = @Status WHERE ID = @ID";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@ID", id);
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
                string query = "UPDATE image_videogallerytbl SET Category_Url = @Url WHERE ID = @ID";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@ID", id);
                    command.Parameters.AddWithValue("@Url", fileUrl);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }


        protected void btnClosePopup_Click(object sender, EventArgs e)
        {
            popup.Style.Add("display", "none");
        }

        private void DeleteMediaItem(int id)
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "DELETE FROM MenuCategory WHERE ID = @ID";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@ID", id);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        protected void gvMenuCategories_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int rowIndex = e.RowIndex;
            int id = Convert.ToInt32(gvMenuCategories.DataKeys[rowIndex].Value);

            // Delete the media item from the database
            DeleteMediaItem(id);

            // Rebind the GridView to refresh the data
            LoadMenuCategories();
        }

        protected void gvMenuCategories_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Delete")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int id = Convert.ToInt32(gvMenuCategories.DataKeys[rowIndex].Value);

                // Delete the media item from the database
                DeleteMediaItem(id);

                // Rebind the GridView to refresh the data
                LoadMenuCategories();
            }
        }
    }
}