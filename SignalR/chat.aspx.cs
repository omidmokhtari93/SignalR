using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SignalR
{
    public partial class chat : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_OnServerClick(object sender, EventArgs e)
        {
            if (txtUsername.Value == "user" && txtPassword.Value == "123321")
            {
                pnlAuthentication.Visible = false;
                pnlChat.Visible = true;
            }
        }
    }
}