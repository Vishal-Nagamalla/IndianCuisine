<%@ Page Title="Manage Image/Video Gallery" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageGallery.aspx.cs" Inherits="IndianCuisine.Html.ManageGallery" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1 style="color: white; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); margin: 0;">Manage Image/Video Gallery</h1>
    <div class="container-fluid position-relative px-0">
            <!-- Add File section -->
            <div class="row justify-content-center mt-4 m-0">
                <div class="col-md-10">
                    <div class="rounded-square" padding: 20px; border-radius: 10px;">
                        <h2 class="text-center">Add File</h2>
                        <div class="form-group mb-3">
                            <label for="ddlFileType" class="label-bold">File Type</label>
                            <asp:DropDownList ID="ddlFileType" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Image" Value="Image"></asp:ListItem>
                                <asp:ListItem Text="Video" Value="Video"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="form-group mb-3">
                            <label for="txtFileName" class="label-bold">File Name</label>
                            <asp:TextBox ID="txtFileName" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Name cannot be blank" ControlToValidate="txtFileName" ForeColor="Red" ValidationGroup="AddFileValidation"></asp:RequiredFieldValidator>  
                        </div>
                        <div class="form-group mb-3">
                            <label for="fuFile" class="label-bold">Upload File</label>
                            <asp:FileUpload ID="fuFile" runat="server" CssClass="form-control" />
                        </div>
                        <div class="form-group mb-3">
                            <label for="fuThumbnailImage" class="label-bold">Upload Thumbnail Image</label>
                            <asp:FileUpload ID="fuThumbnailImage" runat="server" CssClass="form-control" />
                        </div>
                        <div class="form-group mb-3">
                            <label for="ddlStatus" class="label-bold">Status</label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Active" Value="Active"></asp:ListItem>
                                <asp:ListItem Text="Inactive" Value="Inactive"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <asp:Button ID="btnAddFile" runat="server" Text="Add File" CssClass="btn-transparent" OnClientClick="enableAddFileValidation(); return true;" OnClick="btnAddFile_Click" ValidationGroup="AddFileValidation"/>
                    </div>
                </div>
            </div>

        <!-- Popup for no file uploaded -->
        <div id="popup" class="popup" runat="server" style="display: none;">
            <div class="modal-overlay" onclick="closePopup()"></div>
            <div class="popup-content">
                <p>Oops! No image uploaded.</p>
                <asp:Button ID="btnClosePopup" runat="server" CssClass="btn-transparent" Text="OK" OnClick="btnClosePopup_Click" />
            </div>
        </div>


        <div class="row m-0 mt-4">
            <div class="col-md-10 mx-auto">
                <h2 class="text-center">View Media</h2>
                <!-- Search Bar -->
                <div class="row">
                    <!-- Search Bar -->
                    <div class="input-group mb-3">
                        <span class="p-1">Search: </span> <!-- Add text "Search:" -->
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control " placeholder="Search by Type/Name"></asp:TextBox>
                        <div style="padding-left:5px;"> </div>
                        <div class="input-group-append">
                            <asp:Button ID="btnSearch" runat="server" CssClass="btn-transparent" Text="Search" OnClientClick="enableSearchValidation(); return true;" OnClick="btnSearch_Click"  style="width: 200px;"  ValidationGroup="SearchValidation"/>
                            <asp:Button ID="btnClearSearch" runat="server" CssClass="btn-transparent" Text="Clear" OnClick="btnClearSearch_Click" style="width: 200px;" />
                        </div>
                    </div>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" class="text-left" ErrorMessage="Search cannot be blank" ControlToValidate="txtSearch" ForeColor="Red" ValidationGroup="SearchValidation"></asp:RequiredFieldValidator>  
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

                <script>
                    window.onload = function () {
                        // Disable the Add File validator on page load
                        var addFileValidator = document.getElementById('<%= RequiredFieldValidator1.ClientID %>');
                        addFileValidator.enabled = false;
        
                        // Disable the Search validator on page load
                        var searchValidator = document.getElementById('<%= RequiredFieldValidator2.ClientID %>');
                        searchValidator.enabled = false;
                    };

                    function enableAddFileValidation() {
                        var addFileValidator = document.getElementById('<%= RequiredFieldValidator1.ClientID %>');
                        addFileValidator.enabled = true;
                    }

                    function enableSearchValidation() {
                        var searchValidator = document.getElementById('<%= RequiredFieldValidator2.ClientID %>');
                        searchValidator.enabled = true;
                    }
                </script>


                <!-- Add your View Media section HTML here -->
                <div class="justify-content-center">
                    <asp:GridView ID="gvMedia" runat="server" CssClass="gridview" Width ="100%" AutoGenerateColumns="False" DataKeyNames="id" OnRowEditing ="gvMedia_RowEditing" OnRowDeleting="gvMedia_RowDeleting" OnRowCancelingEdit ="gvMedia_RowCancelingEdit" OnRowUpdating ="gvMedia_RowUpdating" CellPadding="4" ForeColor="#333333" GridLines="None">
                        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                        <Columns>
                            <asp:TemplateField HeaderText="ID">
                                <ItemTemplate>
                                    <asp:Label ID="lblID" runat="server" Text='<%# Eval("ID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Type">
                                <ItemTemplate>
                                    <asp:Label ID="lblMediaType" runat="server" Text='<%# Eval("Image_Video_Type") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditMediaType" runat="server" CssClass="form-control">
                                        <asp:ListItem Text="Image" Value="Image"></asp:ListItem>
                                        <asp:ListItem Text="Video" Value="Video"></asp:ListItem>
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblMediaName" runat="server" Text='<%# Eval("Image_Video_Name") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txt_Name" runat="server" Text='<%# Eval("Image_Video_Name") %>'></asp:TextBox>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Image">
                                <ItemTemplate>
                                    <asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("Image_Video_Url") %>' Height="80px" Width="100px" />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:Image ID="img_user" runat="server" ImageUrl='<%# Eval("Image_Video_Url") %>' Height="80px" Width="100px" />
                                    <br />
                                    <asp:FileUpload ID="FileUpload1" runat="server" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Thumbnail">
                                <ItemTemplate>
                                    <asp:Image ID="imgThumbnail" runat="server" ImageUrl='<%# Eval("Image_Video_Thumbnail") %>' Height="80px" Width="100px" />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:Image ID="imgThumbnail" runat="server" ImageUrl='<%# Eval("Image_Video_Thumbnail") %>' Height="80px" Width="100px" />
                                    <br />
                                    <asp:FileUpload ID="FileUpload2" runat="server" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="ddlEditStatus" runat="server" CssClass="form-control">
                                        <asp:ListItem Text="Active" Value="Active"></asp:ListItem>
                                        <asp:ListItem Text="Inactive" Value="Inactive"></asp:ListItem>
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Edit">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" Text="Edit" CssClass="link-button" CommandArgument="<%# ((GridViewRow)Container).RowIndex %>"></asp:LinkButton>
                                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete"  CssClass="link-button" Text="Delete" CommandArgument="<%# ((GridViewRow)Container).RowIndex %>"></asp:LinkButton>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update"  CssClass="link-button" Text="Update" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>
                                    <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel"  CssClass="link-button" Text="Cancel" CommandArgument='<%# Container.DataItemIndex %>'></asp:LinkButton>
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