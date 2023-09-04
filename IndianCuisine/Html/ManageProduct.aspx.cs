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
    public partial class ManageProduct : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCategoryDropdown(); // Populate the dropdown with menu categories
                BindGridView();
            }
        }

        protected void BindCategoryDropdown()
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "SELECT ID, Category_Name FROM MenuCategory";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable categories = new DataTable();
                    adapter.Fill(categories);
                    ddlCategory.DataSource = categories;
                    ddlCategory.DataTextField = "Category_Name";
                    ddlCategory.DataValueField = "ID";
                    ddlCategory.DataBind();
                }
            }
        }

        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            try
            {
                if (fuProductImage.HasFile)
                {
                    int categoryID = Convert.ToInt32(ddlCategory.SelectedValue); // Get the selected menu category's ID
                    string productName = txtProductName.Text.Trim();
                    decimal productPrice = Convert.ToDecimal(txtProductPrice.Text);
                    string productDescription = txtProductDescription.Text.Trim();
                    string status = ddlProductStatus.SelectedValue;

                    // Save the file to the SavedContent folder
                    string uploadPath = Server.MapPath("~/SavedContent/");
                    string extension = Path.GetExtension(fuProductImage.FileName);
                    string uniqueFileName = Guid.NewGuid().ToString() + extension;
                    string fileUrl = "~/SavedContent/" + uniqueFileName;
                    fuProductImage.SaveAs(Path.Combine(uploadPath, uniqueFileName));

                    // Insert data into the database
                    using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
                    {
                        string query = "INSERT INTO menu_itemtbl (CategoryID, ImageDisplay, ProductName, ProductPrice, ProductDescription, Status) VALUES (@CategoryID, @ImageDisplay, @ProductName, @ProductPrice, @ProductDescription, @Status)";
                        using (SqlCommand command = new SqlCommand(query, connection))
                        {
                            command.Parameters.AddWithValue("@CategoryID", categoryID); // Use the selected menu category's ID
                            command.Parameters.AddWithValue("@ImageDisplay", fileUrl);
                            command.Parameters.AddWithValue("@ProductName", productName);
                            command.Parameters.AddWithValue("@ProductPrice", productPrice);
                            command.Parameters.AddWithValue("@ProductDescription", productDescription);
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
            catch
            {

            }
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            // Get the ID of the selected row
            Button btnEdit = (Button)sender;
            int selectedID = Convert.ToInt32(btnEdit.CommandArgument);

            // Find the row in the grid view and hide the edit button
            foreach (GridViewRow row in gvProducts.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    int rowID = Convert.ToInt32(gvProducts.DataKeys[row.RowIndex].Value);
                    if (rowID == selectedID)
                    {
                        row.FindControl("btnEdit").Visible = false;
                        row.FindControl("btnUpdate").Visible = true;
                        row.FindControl("btnCancel").Visible = true;

                        // Populate the edit controls with data from the row
                        DropDownList ddlEditCategory = (DropDownList)row.FindControl("ddlEditCategory");
                        TextBox txtEditProductName = (TextBox)row.FindControl("txtEditProductName");
                        TextBox txtEditProductPrice = (TextBox)row.FindControl("txtEditProductPrice");
                        TextBox txtEditProductDescription = (TextBox)row.FindControl("txtEditProductDescription");
                        DropDownList ddlEditStatus = (DropDownList)row.FindControl("ddlEditProductStatus");

                        ddlEditCategory.SelectedValue = ((Label)row.FindControl("lblCategory")).Text;
                        txtEditProductName.Text = ((Label)row.FindControl("lblProductName")).Text;
                        txtEditProductPrice.Text = ((Label)row.FindControl("lblProductPrice")).Text;
                        txtEditProductDescription.Text = ((Label)row.FindControl("lblProductDescription")).Text;
                        ddlEditStatus.SelectedValue = ((Label)row.FindControl("lblProductStatus")).Text;
                    }
                }
            }
        }

        protected void gvProducts_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvProducts.EditIndex = e.NewEditIndex;
            BindGridView();
        }

        protected void gvProducts_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int rowIndex = e.RowIndex;

            // Access the edited controls within the row
            DropDownList ddlEditCategory = (DropDownList)gvProducts.Rows[rowIndex].FindControl("ddlEditCategory");
            TextBox txtEditProductName = (TextBox)gvProducts.Rows[rowIndex].FindControl("txtEditProductName");
            TextBox txtEditProductPrice = (TextBox)gvProducts.Rows[rowIndex].FindControl("txtEditProductPrice");
            TextBox txtEditProductDescription = (TextBox)gvProducts.Rows[rowIndex].FindControl("txtEditProductDescription");
            FileUpload fuEditProductImage = (FileUpload)gvProducts.Rows[rowIndex].FindControl("fuEditProductImage");
            DropDownList ddlEditStatus = (DropDownList)gvProducts.Rows[rowIndex].FindControl("ddlEditProductStatus");

            // Update database here using the updated values
            int id = Convert.ToInt32(gvProducts.DataKeys[rowIndex].Value);
            string category = ddlEditCategory.SelectedValue;
            string productName = txtEditProductName.Text;
            decimal productPrice = Convert.ToDecimal(txtEditProductPrice.Text);
            string productDescription = txtEditProductDescription.Text;
            string status = ddlEditStatus.SelectedValue;

            // Update the product in the database
            UpdateProduct(id, category, productName, productPrice, productDescription, status);

            // Upload new image if provided
            if (fuEditProductImage.HasFile)
            {
                UploadNewImage(id, fuEditProductImage);
            }

            // Exit edit mode
            gvProducts.EditIndex = -1;
            BindGridView();
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Delete")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int id = Convert.ToInt32(gvProducts.DataKeys[rowIndex].Value);

                // Delete the product from the database
                DeleteProduct(id);

                // Rebind the GridView to refresh the data
                BindGridView();
            }
        }

        protected void gvProducts_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int rowIndex = e.RowIndex;
            int id = Convert.ToInt32(gvProducts.DataKeys[rowIndex].Value);

            // Delete the product from the database
            DeleteProduct(id);

            // Rebind the GridView to refresh the data
            BindGridView();
        }

        protected void gvProducts_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvProducts.EditIndex = -1;
            BindGridView();
        }

        private void BindGridView()
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "SELECT ID, CategoryID, ImageDisplay, ProductName, ProductPrice, ProductDescription, Status FROM menu_itemtbl";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    gvProducts.DataSource = dataTable;
                    gvProducts.DataKeyNames = new string[] { "ID" };
                    gvProducts.DataBind();
                }
            }
        }

        private void DeleteProduct(int id)
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "DELETE FROM menu_itemtbl WHERE ID = @ID";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@ID", id);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        private void UpdateProduct(int id, string category, string productName, decimal productPrice, string productDescription, string status)
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "UPDATE menu_itemtbl SET CategoryID = @CategoryID, ProductName = @ProductName, ProductPrice = @ProductPrice, ProductDescription = @ProductDescription, Status = @Status WHERE ID = @ID";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@ID", id);
                    command.Parameters.AddWithValue("@CategoryID", category);
                    command.Parameters.AddWithValue("@ProductName", productName);
                    command.Parameters.AddWithValue("@ProductPrice", productPrice);
                    command.Parameters.AddWithValue("@ProductDescription", productDescription);
                    command.Parameters.AddWithValue("@Status", status);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        private void UploadNewImage(int id, FileUpload fuEditProductImage)
        {
            // Save the image to the SavedContent folder
            string uploadPath = Server.MapPath("~/SavedContent/");
            string extension = Path.GetExtension(fuEditProductImage.FileName);
            string uniqueFileName = Guid.NewGuid().ToString() + extension;
            string imageUrl = "~/SavedContent/" + uniqueFileName;
            fuEditProductImage.SaveAs(Path.Combine(uploadPath, uniqueFileName));

            // Update the image URL in the database
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "UPDATE menu_itemtbl SET ImageDisplay = @ImageDisplay WHERE ID = @ID";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@ID", id);
                    command.Parameters.AddWithValue("@ImageDisplay", imageUrl);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();
            SearchProducts(searchTerm);
        }

        protected void btnClearSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            BindGridView();
        }

        private void SearchProducts(string searchTerm)
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString))
            {
                string query = "SELECT ID, CategoryID, ImageDisplay, ProductName, ProductPrice, ProductDescription, Status FROM menu_itemtbl WHERE ProductName LIKE @SearchTerm OR CategoryID LIKE @SearchTerm";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    gvProducts.DataSource = dataTable;
                    gvProducts.DataBind();
                }
            }
        }

        protected void btnClosePopup_Click(object sender, EventArgs e)
        {
            popup.Style.Add("display", "none");
        }
    }
}
