<%@ Page Title="Gallery" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Gallery.aspx.cs" Inherits="IndianCuisine.Html.Gallery" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1 style="color: white; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); margin: 0;">Gallery</h1>
    <div class="container-fluid position-relative px-0">
            <div class="d-flex justify-content-center mt-3">
                <asp:Button ID="btnShowImages" runat="server" Text="Show Images" OnClick="btnShowImages_Click" CssClass="btn btn-primary mx-2" />
                <asp:Button ID="btnShowVideos" runat="server" Text="Show Videos" OnClick="btnShowVideos_Click" CssClass="btn btn-primary mx-2" />
            </div>
            <div class="media-container d-flex flex-wrap justify-content-center mt-3">
                <asp:Repeater ID="rptMedia" runat="server">
                    <ItemTemplate>
                        <div class="media-item text-center m-2">
                            <asp:Image ID="imgMedia" runat="server" ImageUrl='<%# Eval("Image_Video_Thumbnail") %>' Height="250px" Width="250px" CssClass="popup-image" />
                            <p class="mt-2"><%# Eval("Image_Video_Name") %></p>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
    </div>
    
    <div id="popup-container" class="popup-container">
        <div class="popup-content">
            <span class="popup-close" onclick="HidePopup()">&times;</span>
            <img id="popup-img" src="" alt="" />
        </div>
    </div>
    
    <style type="text/css">
        /* Your existing styles */

        /* Add this style for the popup container and content */
        .popup-container {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        .popup-content {
            position: relative;
            max-width: 90%;
            max-height: 90%;
            background-color: white;
            overflow: hidden; /* Hide scrollbars if image is larger */
        }

        .popup-close {
            position: absolute;
            top: 0px; /* Adjust top position */
            right: 0px; /* Adjust right position */
            width: 30px; /* Set equal width and height for a circular button */
            height: 30px; /* Set equal width and height for a circular button */
            font-size: 30px; /* Increase font size */
            line-height: 1; /* Ensure the content is vertically centered */
            text-align: center; /* Ensure the content is horizontally centered */
            cursor: pointer;
            background-color: white;
            border-radius: 50%;
        }

    </style>
    
    <script type="text/javascript">
        function ShowPopup(url) {
            var popupContainer = document.getElementById("popup-container");
            var popupImg = document.getElementById("popup-img");

            popupImg.src = url;
            popupContainer.style.display = "flex";
        }

        function HidePopup() {
            var popupContainer = document.getElementById("popup-container");

            popupContainer.style.display = "none";
        }

        window.onload = function () {
            var popupImages = document.getElementsByClassName("popup-image");
            for (var i = 0; i < popupImages.length; i++) {
                popupImages[i].addEventListener("click", function () {
                    ShowPopup(this.src);
                });
            }
        };
    </script>
</asp:Content>