<%@ Page Title="Manage Menu Category" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageMenuCategory.aspx.cs" Inherits="IndianCuisine.Html.ManageMenuCategory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1 style="color: white; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); margin: 0;">Manage Menu Category</h1>
    <div class="container-fluid position-relative px-0">
            <!-- Add Menu Category section -->
            <div class="row justify-content-center mt-4 m-0">
                <div class="col-md-10">
                    <div class="rounded-square" style="padding: 20px; border-radius: 10px;">
                        <h2 class="text-center">Add Menu Category</h2>
                        <div class="form-group mb-3">
                            <label for="txtMenuCategoryName" class="label-bold">Menu Category Name</label>
                            <asp:TextBox ID="txtMenuCategoryName" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Category name cannot be blank" ControlToValidate="txtMenuCategoryName" ForeColor="Red" ValidationGroup="AddCategoryValidation"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group mb-3">
                            <label for="fuMenuCategory" class="label-bold">Upload Menu Category</label>
                            <asp:FileUpload ID="fuMenuCategory" runat="server" CssClass="form-control" />
                        </div>
                        <div class="form-group mb-3">
                            <label for="ddlMenuCategoryStatus" class="label-bold">Menu Category Status</label>
                            <asp:DropDownList ID="ddlMenuCategoryStatus" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Active" Value="Active"></asp:ListItem>
                                <asp:ListItem Text="Inactive" Value="Inactive"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <asp:Button ID="btnAddMenuCategory" runat="server" Text="Add Menu Category" OnClientClick="enableAddCategoryValidation(); return true;" OnClick="btnAddMenuCategory_Click" CssClass="btn-transparent" ValidationGroup="AddCategoryValidation" />
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

            <!-- View Menu Categories section -->
            <div class="row m-0 mt-4">
                <div class="col-md-10 mx-auto">
                    <h2 class="text-center">View Menu Categories</h2>
                    <!-- Search Bar -->
                    <div class="row">
                        <!-- Search Bar -->
                        <div class="input-group mb-3">
                            <span class="p-1">Search: </span> <!-- Add text "Search:" -->
                            <asp:TextBox ID="txtSearchCategory" runat="server" CssClass="form-control " placeholder="Search by Type/Name"></asp:TextBox>
                            <div style="padding-left:5px;"> </div>
                            <div class="input-group-append">
                                <asp:Button ID="btnSearchCategory" runat="server" CssClass="btn-transparent" Text="Search" OnClientClick="enableSearchCategoryValidation(); return true;" OnClick="btnSearch_Click"  style="width: 200px;"  ValidationGroup="SearchCategoryValidation"/>
                                <asp:Button ID="btnClearSearchCategory" runat="server" CssClass="btn-transparent" Text="Clear" OnClick="btnClearSearchCategory_Click" style="width: 200px;" />
                            </div>
                        </div>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" class="text-left" ErrorMessage="Search cannot be blank" ControlToValidate="txtSearchCategory" ForeColor="Red" ValidationGroup="SearchValidation"></asp:RequiredFieldValidator>  
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

                    <!-- Add your View Menu Categories section HTML here -->
                    <div class="justify-content-center">
                        <asp:GridView ID="gvMenuCategories" runat="server" Width="100%" AutoGenerateColumns="False" DataKeyNames="ID" OnRowEditing="gvMenuCategories_RowEditing" OnRowDeleting="gvMenuCategories_RowDeleting" OnRowCancelingEdit="gvMenuCategories_RowCancelingEdit" OnRowUpdating="gvMenuCategories_RowUpdating" CellPadding="4" ForeColor="#333333" GridLines="None">
                            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                            <Columns>
                                <asp:TemplateField HeaderText="ID">
                                    <ItemTemplate>
                                        <asp:Label ID="lblCategoryID" runat="server" Text='<%# Eval("ID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lblCategoryName" runat="server" Text='<%# Eval("Category_Name") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditCategoryName" runat="server" Text='<%# Eval("Category_Name") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Image">
                                    <ItemTemplate>
                                        <asp:Image ID="imgCategory" runat="server" ImageUrl='<%# Eval("Category_Url") %>' Height="80px" Width="100px" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:Image ID="imgEditCategory" runat="server" ImageUrl='<%# Eval("Category_Url") %>' Height="80px" Width="100px" />
                                        <br />
                                        <asp:FileUpload ID="fuEditCategory" runat="server" />
                                    </EditItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <asp:Label ID="lblCategoryStatus" runat="server" Text='<%# Eval("Category_Status") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlEditCategoryStatus" runat="server">
                                            <asp:ListItem Text="Active" Value="Active"></asp:ListItem>
                                            <asp:ListItem Text="Inactive" Value="Inactive"></asp:ListItem>
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEdit" runat="server" CssClass="link-button" CommandName="Edit" Text="Edit"></asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="link-button" CommandName="Delete" Text="Delete" CommandArgument="<%# ((GridViewRow)Container).RowIndex %>"></asp:LinkButton>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:LinkButton ID="btnUpdate" runat="server" CssClass="link-button" CommandName="Update" Text="Update"></asp:LinkButton>
                                        <asp:LinkButton ID="btnCancel" runat="server" CssClass="link-button" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EditRowStyle BackColor="#999999" />
                            <FooterStyle BackColor="#5D7B9D" ForeColor="White" Font-Bold="True" />
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
