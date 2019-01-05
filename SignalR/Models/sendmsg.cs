﻿using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace SignalR.Models
{
    public static class UserHandler //this static class is to store the number of users conected at the same time
    {
        public static HashSet<string> ConnectedIds = new HashSet<string>();
    }
    [HubName("SendMessage")]   //this is for use a name to use in the client
    public class SendMessageHub : Hub
    {
        public void SendMessage(string usrname ,string msg) // this method will be called from the client, when the user drag/move the shape
        {
            Clients.Others.messageSended(usrname,msg); // this method will send the coord x, y to the other users but the user draging the shape
        }

        public override Task OnConnected() //override OnConnect, OnReconnected and OnDisconnected to know if a user is connected or disconnected
        {
            UserHandler.ConnectedIds.Add(Context.ConnectionId); //add a connection id to the list
            Clients.All.usersConnected(UserHandler.ConnectedIds.Count()); //this will send to ALL the clients the number of users connected
            return base.OnConnected();
        }

        public override Task OnReconnected()
        {
            UserHandler.ConnectedIds.Add(Context.ConnectionId);
            Clients.All.usersConnected(UserHandler.ConnectedIds.Count());
            return base.OnConnected();
        }

        public override Task OnDisconnected(bool stopCalled)
        {
            UserHandler.ConnectedIds.Remove(Context.ConnectionId);
            Clients.All.usersConnected(UserHandler.ConnectedIds.Count());
            return base.OnDisconnected(stopCalled);
        }
    }
}