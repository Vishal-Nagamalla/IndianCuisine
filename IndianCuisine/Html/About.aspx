<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="IndianCuisine.Html.About" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1 style="color: white; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); margin: 0;">About</h1>
    <style>
        body {
            overflow-x: hidden; /* Prevent horizontal scrolling */
        }

        .quote-container {
            position: relative;
        }

        .quote:before,
        .quote:after {
            content: '"';
            font-size: 40px;
            color: #E31C55; /* Quotation mark color */
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
        }

        .quote:before {
            left: 0;
        }

        .quote:after {
            right: 0;
        }

        .paragraph-container {
            max-width: 1300px; /* Adjust the value as needed */
            margin: 0 auto; /* Center the container horizontally */
        }
    </style>
    <div class="container-fluid position-relative px-0">
        <div class="row text-center mt-4 m-4 quote-container">
            <div class="quote">
                <p><strong>Welcome to our website! We are passionate about serving delicious Indian cuisine that tantalizes your taste buds and brings the flavors of India to your plate.</strong></p>
            </div>
        </div>
            
        <div class="row">
            <div class="paragraph-container">
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam mattis vehicula dolor, quis volutpat purus malesuada at. Proin id diam vel dui finibus vehicula in id magna. Sed accumsan congue tellus vel vehicula. In vehicula, eros eget dictum rhoncus, orci libero cursus est, at volutpat lectus tellus id lorem.</p>
                <p>Vestibulum id felis sed neque suscipit sodales ac eget lectus. Cras at ante sed ligula cursus dictum. Fusce nec sodales urna. Ut iaculis cursus eros, eu consectetur neque commodo vitae. Pellentesque ultrices varius augue in convallis.</p>
                <p>Suspendisse potenti. Duis auctor, erat nec placerat tempor, dui ante finibus tortor, a convallis turpis risus et metus. Integer semper justo in orci laoreet, eu facilisis elit luctus. Quisque congue justo at urna cursus, vel volutpat ligula aliquet.</p>
            </div>
        </div>
    </div>
</asp:Content>
