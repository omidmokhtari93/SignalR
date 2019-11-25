<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="chat.aspx.cs" Inherits="SignalR.chat" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/styles.css">
    <script src="js/jquery-3.3.1.min.js"></script>
    <script src="js/jquery.signalR-2.4.0.js"></script>
    <script src="signalr/hubs"></script>
    <title>Online Chat</title>
</head>
<body>
    <form runat="server">
        <asp:panel CssClass="text-center pt-3 login" style="margin-top: 200px" runat="server" ID="pnlAuthentication" DefaultButton="btnLogin">
            <div class="row sans">
                <div class="col-lg-2 offset-lg-5 col-md-6 offset-md-3 col-sm-10 offset-sm-1">
                    <div class="card rtl">
                        <div class="card-body">
                            <input class="form-control mb-2" runat="server" id="txtUsername" placeholder="نام کاربری..." />
                            <input class="form-control mb-2" placeholder="رمز عبور..." id="txtPassword" runat="server" />
                            <asp:Button runat="server" ID="btnLogin" OnClick="btnLogin_OnServerClick" CssClass="btn btn-primary btn-block" Text="ورود" />
                        </div>
                    </div>
                </div>
            </div>
        </asp:panel>
    </form>

    <div runat="server" id="pnlChat" visible="False" class="sans">
        <div class="chat-popup sans text-right rtl m-auto" id="myForm">
            <div class="form-container">
                <div class="sans">
                    تعداد افراد آنلاین : <span class="badge badge-info align-middle"></span>
                </div>
                <input class="form-control mb-2 sans" autocomplete="off" name="uname" placeholder="نام خود را وارد کنید ..." />
                <div class="list-group">
                    <div class="list-group-item sans" id="msgArea">
                    </div>
                </div>
                <input placeholder="پیام ..." name="msg" class="form-control my-2 sans" rows="1" required autocomplete="off" />
                <button type="button" id="btnSend" class="btn-lg btn-primary btn-block mb-0 pt-4 pb-4 sans">ارسال</button>
            </div>
        </div>

        <script>
            $(function () {
                const setMessageWidth = () => {
                    $('.alert-info , .alert-secondary').css('max-width', $('#msgArea').width() - 10)
                }
                $('.form-container .list-group .list-group-item').height($(document).height() - 450);
                var hub = $.connection.SendMessage;
                hub.client.usersConnected =
                    function (numUsers) {
                        $(".badge.badge-info").text(numUsers);
                    };
                hub.client.messageSended = function (usrname, msg, t) {
                    $("#msgArea").append('<div class="text-left"><div class="alert alert-secondary d-inline-block text-right">' + msg +
                        '<em class="d-block text-left">' + usrname + (usrname === '' ? '' : ' - ') + t + '</em></div></div>');
                    setTimeout($('#msgArea').animate({ scrollTop: 10000 }, 500), 700)
                    setMessageWidth();
                };

                $.connection.hub.start().done(function (x, y) {
                    $(document).on('keypress',
                        function (e) {
                            if (e.keyCode === 13 && $("input[name=msg]").val() !== '') {
                                send();
                            }
                        });
                    $('#btnSend').on('click',
                        function () {
                            if ($("input[name=msg]").val() !== '') {
                                send();
                            }
                        });

                    function send() {
                        $.ajax({
                            url: 'datetime.asmx/GetTime',
                            type: "post",
                            dataType: "json",
                            contentType: "application/json; charset=utf-8",
                            success: function (tme) {
                                const time = $("input[name=uname]").val() + ($("input[name=uname]").val() == '' ? '' : ' - ') + tme.d;
                                $("#msgArea").append('<div class="text-right"><div class="alert alert-info d-inline-block">' + $("input[name=msg]").val() +
                                    '<em class="d-block text-left">' + time + '</em>' +
                                    '</div></div>');
                                hub.server.sendMessage($("input[name=uname]").val(), $("input[name=msg]").val());
                                $("input[name=msg]").val('');
                                setTimeout($('#msgArea').animate({ scrollTop: 10000 }, 500), 700)
                                setMessageWidth()
                            }
                        });
                    }
                });
            });
        </script>
    </div>
</body>
</html>
