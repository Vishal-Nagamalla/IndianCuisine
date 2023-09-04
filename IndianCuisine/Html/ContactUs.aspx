<%@ Page Title="ContactUs" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ContactUs.aspx.cs" Inherits="IndianCuisine.Html.ContactUs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1 style="color: white; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); margin: 0;">Contact Us</h1>
    <div class="py-3"></div> <!-- Adding space on top -->
        <div class="col-md-8 offset-md-2 mb-4">
            <iframe
                width="100%"
                height="400"
                frameborder="0"
                scrolling="no"
                marginheight="0"
                marginwidth="0"
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3016.7359190067978!2d-74.30537932407296!3d40.877669264196335!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c3c5721bd6dc67%3A0x411bc82f5e083ba9!2sTEAM%20TRANQUIL%20INC!5e0!3m2!1sen!2sus!4v1693028877296!5m2!1sen!2sus" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"
            ></iframe>
        </div>
    <div class="row px-5"> <!-- Adding horizontal padding -->
        <div class="col-md-6">
    <!-- Contact Form -->
            <div class="pl-4 pr-4">
                <div class="form-group">
                    <input type="text" class="form-control" placeholder="Enter Your Name" style="margin-left: 50px;" />
                    <small class="text-danger" style="margin-left: 50px;">Please Enter Name</small>
                </div>
                <div class="form-group">
                    <input type="email" class="form-control" placeholder="Enter Your Email" style="margin-left: 50px;" />
                    <small class="text-danger" style="margin-left: 50px;">Please Enter Email</small>
                </div>
                <div class="form-group">
                    <input type="tel" class="form-control" placeholder="Enter Your Phone Number" style="margin-left: 50px;" />
                    <small class="text-danger" style="margin-left: 50px;">Please Enter Phone Number</small>
                </div>
                <div class="form-group">
                    <input type="text" class="form-control" placeholder="Enter Subject" style="margin-left: 50px;" />
                    <small class="text-danger" style="margin-left: 50px;">Please Enter Subject</small>
                </div>
                <div class="form-group">
                    <textarea class="form-control" placeholder="Enter Message Here" rows="5" style="margin-left: 50px;"></textarea>
                    <small class="text-danger" style="margin-left: 50px;">Please Enter Phone Number</small>
                </div>
                <div class="py-2"></div> <!-- Adding space on bottom -->
                <div class="d-flex justify-content-center">
                    <button type="submit" class="btn-transparent">Send Message</button>
                </div>
            </div>
        </div>

        <style>
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

        <!-- Right side: Location and Contact Info -->
        <div class="col-md-6 pr-4"> <!-- Adding right padding -->
            <div class="p-4"> <!-- Adding padding -->
                <h4><strong>Location</strong></h4>
                <p class="small">Indian Cuisine<br />Address 1, Address 2</p>
                
                <h4><strong>Contact Info</strong></h4>
                <p class="small">Phone: +1234-567-8900</p>
                
                <h4><strong>Mail Info</strong></h4>
                <p class="small">Email: supports@indiancuisine.com</p>
            </div>
        </div>
    </div>
    <div class="py-3"></div> <!-- Adding space on bottom -->
</asp:Content>