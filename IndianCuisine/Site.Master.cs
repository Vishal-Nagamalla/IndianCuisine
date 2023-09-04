using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace IndianCuisine
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateMenuDropdown();
            }
        }

        private void PopulateMenuDropdown()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["indiandb"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT Category_Name FROM MenuCategory";
                SqlCommand cmd = new SqlCommand(query, connection);

                connection.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    string categoryName = reader["Category_Name"].ToString();
                    ListItem item = new ListItem(categoryName, categoryName);
                    menuDropdown.Items.Add(item);
                }

                reader.Close();
            }
        }
    }
}
