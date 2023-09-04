<%@ Page Title="Manage Menu Category" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageProduct.aspx.cs" Inherits="IndianCuisine.Html.ManageProduct" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1 style="color: white; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); margin: 0;">Manage Products</h1>
    <div class="container-fluid position-relative px-0">
            <!-- Add Product Category section -->
            <div class="row justify-content-center mt-4 m-0">
                <div class="col-md-10">
                    <div class="rounded-square" style="padding: 20px; border-radius: 10px;">
                        <h2 class="text-center">Add Product Category</h2>
                        <div class="form-group mb-3">
                            <label for="ddlCategory" class="label-bold">Menu Category</label>
                            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control"></asp:DropDownList>
                        </div>
                        <div class="form-group mb-3">
                            <label for="txtProductName" class="label-bold">Product Name</label>
                            <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvProductName" runat="server" ErrorMessage="Product Name is required" ControlToValidate="txtProductName" ForeColor="Red" ValidationGroup="AddProductValidation"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group mb-3">
                            <label for="txtProductPrice" class="label-bold">Product Price</label>
                            <asp:TextBox ID="txtProductPrice" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvProductPrice" runat="server" ErrorMessage="Product Price is required" ControlToValidate="txtProductPrice" ForeColor="Red" ValidationGroup="AddProductValidation"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revProductPrice" runat="server" ErrorMessage="Invalid Product Price" ControlToValidate="txtProductPrice" ForeColor="Red" ValidationExpression="^\d+(\.\d{1,2})?$" ValidationGroup="AddProductValidation"></asp:RegularExpressionValidator>
                        </div>
                        <div class="form-group mb-3">
                            <label for="txtProductDescription" class="label-bold">Product Description</label>
                            <asp:TextBox ID="txtProductDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvProductDescription" runat="server" ErrorMessage="Product Description is required" ControlToValidate="txtProductDescription" ForeColor="Red" ValidationGroup="AddProductValidation"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group mb-3">
                            <label for="fuProductImage" class="label-bold">Upload Product Image</label>
                            <asp:FileUpload ID="fuProductImage" runat="server" CssClass="form-control" />
                            <asp:RequiredFieldValidator ID="rfvProductImage" runat="server" ErrorMessage="Product Image is required" ControlToValidate="fuProductImage" ForeColor="Red" ValidationGroup="AddProductValidation"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group mb-3">
                            <label for="ddlProductStatus" class="label-bold">Product Status</label>
                            <asp:DropDownList ID="ddlProductStatus" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Active" Value="Active"></asp:ListItem>
                                <asp:ListItem Text="Inactive" Value="Inactive"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <asp:Button ID="btnAddProduct" runat="server" Text="Add Product" OnClientClick="enableAddProductValidation(); return true;" OnClick="btnAddProduct_Click" CssClass="btn-transparent" ValidationGroup="AddProductValidation" />
                    </div>
                </div>
            </div>

            <!-- Popup for no file uploaded -->
            <div id="popup" class="popup" runat="server" style="display: none;">
                <div class="modal-overlay" onclick="closePopup()"></div>
                <div class="popup-content">
                    <p>Oops! No image uploaded.</p>
                    <asp:Button ID="btnClosePopup" runat="server" Text="OK" OnClick="btnClosePopup_Click" CssClass="btn-transparent" />
                </div>
            </div>

            <!-- View Products section -->
            <div class="row m-0 mt-4">
                <div class="col-md-10 mx-auto">
                    <h2 class="text-center">View Products</h2>
                    <!-- Search Bar -->
                    <div class="row">
                        <!-- Search Bar -->
                        <div class="input-group mb-3">
                            <span class="p-1">Search: </span> <!-- Add text "Search:" -->
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control " placeholder="Search by Type/Name"></asp:TextBox>
                            <div style="padding-left:5px;"> </div>
                            <div class="input-group-append">
                                <asp:Button ID="btnSearch" runat="server" CssClass="btn-transparent" Text="Search" OnClientClick="enableSearchValidation(); return true;" OnClick="btnSearch_Click"  style="width: 200px;"  ValidationGroup="SearchCategoryValidation"/>
                                <asp:Button ID="btnClearSearch" runat="server" CssClass="btn-transparent" Text="Clear" OnClick="btnClearSearch_Click" style="width: 200px;" />
                            </div>
                        </div>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" class="text-left" ErrorMessage="Search cannot be blank" ControlToValidate="txtSearch" ForeColor="Red" ValidationGroup="SearchValidation"></asp:RequiredFieldValidator>  
                    </div>

                <style>
                    body {
                        background-color: #F0F0F0;
                    }
                    .custom-width {
                        width: 20%;
                    }
                    .popup {
                        display: none;
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        z-index: 9999;
                    }

                    .modal-overlay {
                        position: absolute;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background-color: rgba(0, 0, 0, 0.5);
                        z-index: -1; /* Behind popup content */
                    }

                    .popup-content {
                        position: absolute;
                        top: 50%;
                        left: 50%;
                        transform: translate(-50%, -50%);
                        background-color: white;
                        padding: 20px;
                        border-radius: 5px;
                        text-align: center;
                        z-index: 1; /* Above modal overlay */
                    }
                                        /* Style for the GridView */
                    .gridview {
                        background-color: #E31C55;
                        color: white;
                    }

                    /* Style for the LinkButtons */
                    .link-button {
                        color: #E31C55;
                    }

                    .btn-transparent {
                        background-color: transparent;
                        color: #E31C55;
                        border: 1px solid #E31C55;
                        transition: background-color 0.3s, color 0.3s;
                    }

                    .btn-transparent:hover {
                        background-color: #E31C55;
                        color: white;
                    }
                </style>

                    <!-- GridView to display products -->
                    <div class="justify-content-center">
                        <asp:GridView ID="gvProducts" runat="server" Width="100%" AutoGenerateColumns="False" DataKeyNames="ID" OnRowEditing="gvProducts_RowEditing" OnRowDeleting="gvProducts_RowDeleting" OnRowCancelingEdit="gvProducts_RowCancelingEdit" OnRowUpdating="gvProducts_RowUpdating" CellPadding="4" ForeColor="#333333" GridLines="None">
                            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                            <Columns>
                                <asp:TemplateField HeaderText="ID">
                                    <ItemTemplate>
                                        <asp:Label ID="lblID" runat="server" Text='<%# Eval("ID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Category">
                                    <ItemTemplate>
                                        <asp:Label ID="lblCategory" runat="server" Text='<%# Eval("CategoryID") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlEditCategory" runat="server" CssClass="form-control">
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Product Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lblProductName" runat="server" Text='<%# Eval("ProductName") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditProductName" runat="server" Text='<%# Eval("ProductName") %>' CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvEditProductName" runat="server" ErrorMessage="Product Name is required" ControlToValidate="txtEditProductName" ForeColor="Red" ValidationGroup="EditProductValidation"></asp:RequiredFieldValidator>
                                    </EditItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Product Price">
                                    <ItemTemplate>
                                        <asp:Label ID="lblProductPrice" runat="server" Text='<%# Eval("ProductPrice", "{0:C2}") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditProductPrice" runat="server" Text='<%# Eval("ProductPrice") %>' CssClass="form-control"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvEditProductPrice" runat="server" ErrorMessage="Product Price is required" ControlToValidate="txtEditProductPrice" ForeColor="Red" ValidationGroup="EditProductValidation"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="revEditProductPrice" runat="server" ErrorMessage="Invalid Product Price" ControlToValidate="txtEditProductPrice" ForeColor="Red" ValidationExpression="^\d+(\.\d{1,2})?$" ValidationGroup="EditProductValidation"></asp:RegularExpressionValidator>
                                    </EditItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Product Description">
                                    <ItemTemplate>
                                        <asp:Label ID="lblProductDescription" runat="server" Text='<%# Eval("ProductDescription") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditProductDescription" runat="server" Text='<%# Eval("ProductDescription") %>' CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvEditProductDescription" runat="server" ErrorMessage="Product Description is required" ControlToValidate="txtEditProductDescription" ForeColor="Red" ValidationGroup="EditProductValidation"></asp:RequiredFieldValidator>
                                    </EditItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Product Image">
                                    <ItemTemplate>
                                        <asp:Image ID="imgProduct" runat="server" ImageUrl='<%# Eval("ImageDisplay") %>' Height="80px" Width="100px" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:Image ID="imgEditProduct" runat="server" ImageUrl='<%# Eval("ImageDisplay") %>' Height="80px" Width="100px" />
                                        <br />
                                        <asp:FileUpload ID="fuEditProductImage" runat="server" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="rfvEditProductImage" runat="server" ErrorMessage="Product Image is required" ControlToValidate="fuEditProductImage" ForeColor="Red" ValidationGroup="EditProductValidation"></asp:RequiredFieldValidator>
                                    </EditItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <asp:Label ID="lblProductStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlEditProductStatus" runat="server" CssClass="form-control">
                                            <asp:ListItem Text="Active" Value="Active"></asp:ListItem>
                                            <asp:ListItem Text="Inactive" Value="Inactive"></asp:ListItem>
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Edit">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEdit" runat="server" CssClass="link-button" CommandName="Edit" Text="Edit" CommandArgument="<%# ((GridViewRow)Container).RowIndex %>"></asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="link-button" CommandName="Delete" Text="Delete" CommandArgument="<%# ((GridViewRow)Container).RowIndex %>"></asp:LinkButton>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:LinkButton ID="btnUpdate" runat="server" CssClass="link-button" CommandName="Update" Text="Update" CommandArgument="<%# ((GridViewRow)Container).RowIndex %>"></asp:LinkButton>
                                        <asp:LinkButton ID="btnCancel" runat="server" CssClass="link-button" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EditRowStyle BackColor="#999999" />
                            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#000000" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                            <SortedAscendingCellStyle BackColor="#E9E7E2" />
                            <SortedAscendingHeaderStyle BackColor="#506C8C" />
                            <SortedDescendingCellStyle BackColor="#FFFDF8" />
                            <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                        </asp:GridView>
                    </div>
                </div>
            </div>
    </div>
</asp:Content>