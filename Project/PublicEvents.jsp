<!DOCTYPE html>
<html class="hide-sidebar ls-bottom-footer" lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<title>The Network</title>
<link href="css/vendor/all.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.6.3/css/font-awesome.min.css">
<link href="css/app/app.css" rel="stylesheet">
<link href="css/stylesheet.css" rel="stylesheet">
<script type="text/javascript" src="javascript.js"></script>
</head>
<body onload="init()">
<%@ page import= "com.User, com.AutoComplete, com.MySqlDataStoreUtilities, com.Events, java.io.*, javax.servlet.*,
javax.servlet.http.*, java.util.*"%>

<%
        User user = null;
        User friendRequestBy = null;
        String searchedUserEmail = request.getParameter("searchedUser");
        User searchedUser = null;
        ArrayList<User> friendList = null;
        HashMap<String,String> friendRequestsList = null;

        if(request.getSession(false)!=null)
        {
          String email = session.getAttribute("user").toString();
          user = MySqlDataStoreUtilities.getUserInfo(email);
          searchedUser = MySqlDataStoreUtilities.getUserInfo(searchedUserEmail);
			    friendList = MySqlDataStoreUtilities.getFriends(email);
          friendRequestsList = MySqlDataStoreUtilities.getFriendRequests(email);
        }
%>
<!-- Wrapper required for sidebar transitions -->
<div class='st-container'>
<!-- Fixed navbar -->
<div class='navbar navbar-main navbar-primary navbar-fixed-top' role='navigation'>
<div class='container'>
<div class='navbar-header'>
<button type='button' class='navbar-toggle collapsed' data-toggle='collapse' data-target='#main-nav'>
    <span class='sr-only'>Toggle navigation</span>
    <span class='icon-bar'></span>
    <span class='icon-bar'></span>
    <span class='icon-bar'></span>
</button>
  <a href='#sidebar-chat' data-toggle='sidebar-menu' class='toggle pull-right visible-xs'><i class='fa fa-comments'></i></a>
<strong><a class='navbar-brand' href='index.html'>The Network</a></strong>
</div>
<!-- Collect the nav links, forms, and other content for toggling -->
<div class='collapse navbar-collapse' id='collapse'>
  <form class="navbar-form navbar-left hidden-xs">
    <div class="search-2">
      <div class="input-group">
      <span class="input-group-btn">
    <button class="btn btn-primary" type="button"><i class="fa fa-search"></i></button>
    </span>
    <form name="autofillform" action="autocomplete">
        <input class="form-control form-control-w-150" id='searchId' name='searchId' placeholder='Search people' type='text' onkeyup='doCompletion()' />
        <div id="auto-row" colspan="2">
            <table style="position:absolute;top:36px;left:32px;width:315px;" id='complete-table' class="popupBox"></table>
       </div>
    </form>
      </div>
    </div>
  </form>
  <ul class='nav navbar-nav  navbar-right'>
    <!-- notifications -->
            <li class="dropdown notifications updates hidden-xs hidden-sm">
              <a href="NotificationsPage.jsp" class="dropdown-toggle" data-toggle="dropdown">
                <i class="fa fa-eye"></i>
                <span class="badge badge-primary"><%= friendRequestsList.size() %></span>
              </a>
              <ul class="dropdown-menu" role="notification">
                <li class="dropdown-header">Notifications</li>
<%
  if(friendRequestsList.size()!=0)
  {
    for(Map.Entry<String, String> entry : friendRequestsList.entrySet())
    {
      friendRequestBy = MySqlDataStoreUtilities.getUserInfo(entry.getKey());
%>
                  <li class="media">
                  <div class="media-left">
                    <img src="images/<%= friendRequestBy.profilepic %>" alt="people" class="img-circle" width="30">
                  </div>
                  <div class="media-body">
                    <a href="#"><%= friendRequestBy.name %></a> sent you a friend request.
                    <form id='updateFriend' action='UpdateFriend.jsp' method='post' accept-charset='UTF-8'>
                    <button class="btn btn-default btn-circle"><i class="fa fa-check"></i></button>
                    <input type='hidden' name='hiddenUserName' value='<%= friendRequestBy.email %>'>
                    <input type='hidden' name='hiddenFriendName' value='<%= user.email %>'>
                    </form>
                    <form id='deleteFriendRequest' action='RemoveFriendRequest.jsp' method='post' accept-charset='UTF-8'>
                    <button class="btn btn-default btn-circle"><i class="fa fa-remove"></i></button>
                    <input type='hidden' name='hiddenUserName' value='<%= friendRequestBy.email %>'>
                    <input type='hidden' name='hiddenFriendName' value='<%= user.email %>'>
                    </form>
                  </div>
                  </li>
<%
    }
  }
%>
  </ul>
  </li>
<!-- // END notifications -->
    <li class='hidden-xs'>
      <a href='Inbox.jsp'>
        <i class='fa fa-download'></i>
      </a>
    </li>
    <!-- User -->
    <li class='dropdown'>
      <a href='index.html' class='dropdown-toggle user' data-toggle='dropdown'>
        <img src='images/<%= user.profilepic %>' class='img-circle' width='40' /><%= user.name %>&nbsp&nbsp<i class="fa fa-sign-out"></i>
      </a>
    </li>
  </ul>
</div>
</div>
</div>
        <!-- content push wrapper -->
        <div class='st-pusher' id='content'>
        <!-- this is the wrapper for the content -->
        <div class='st-content'>
        <!-- extra div for emulating position:fixed of the menu -->
        <div class='st-content-inner'>
          <div class='container'>
		  <div class='cover profile'>
                <div class='image'>
                  <img src='images/<%= searchedUser.coverpic %>' style="width:1138px;height:300px;" />
                </div>
              <div class='cover-info'>
                <div class='avatar'>
               <img src='images/<%= searchedUser.profilepic %>' />
                </div>
                <div class='name'><a href='#'><%= searchedUser.name %></a></div>
                <ul class='cover-nav'>
                  <li><a href='PublicAbout.jsp?searchedUser=<%= searchedUser.email %>'><i class=''></i> My Profile</a></li>
                  <li><a href='PublicTimeline.jsp?searchedUser=<%= searchedUser.email %>'><i class=''></i> Feed</a></li>
                  <li><a href='PublicFriends.jsp?searchedUser=<%= searchedUser.email %>'><i class=''></i> Friends</a></li>
                  <li class='active'><a href='PublicEvents.jsp?searchedUser=<%= searchedUser.email %>'><i class=''></i> Posts</a></li>
        		     
				</ul>
              </div>
            </div>
		  <!--Loop through each event in the database and display them-->
		  <%
					ArrayList<Events> eList = new ArrayList<Events>();
					eList=MySqlDataStoreUtilities.getEvents(searchedUser.name);
					ArrayList<String> userList = new ArrayList<String>();
					%>
		  <div>
				<div class="timeline-block">
                  <div class="panel panel-default event">
                    <div class="panel-heading title">
                     <center> <b>Posts Created:</b> </center>
                    </div>
					</div>
					</div>

				<br>
				<table style="background-color:transparent">
				<%
				int i =0;
				for(i=0;i<eList.size();i++)
				{
					Events e = eList.get(i);
					if(i%2==0)
					{
						System.out.println("in if condition");%>
					<tr>
					<%}%>
					<td>

				<div class="timeline-block" style="width:500px">
                  <div class="panel panel-default event">
                    <div class="panel-heading title">
                      <b><%=e.getEventName()%></b>
                    </div>

					<ul class="icon-list icon-list-block">
                      <li><i class="fa fa-globe"></i><%=e.getEventLocation()%></li>
                      <li><i class="fa fa-calendar-o"></i><%=e.getEventDate()%></li>
                      <li><i class="fa fa-clock-o"></i><%=e.getEventTime()%></li>
					  <li>Add person: <select onChange="window.location.href=this.value">
					  <option selected></option>
					  <%
					  for(int j=0;j<friendList.size();j++){
					  User u=friendList.get(j);
					  %>
					  <option value="AddUserEvent.jsp?value1=<%=u.getFullName()%>&value2=<%=e.getEventName()%>"><%=u.getFullName()%></option>
					  <%}%>
					  </select>
				<!--	  <a href="AddUserEvent.jsp?value=<%=e.getEventName()%>" class="btn btn-primary btn-stroke btn-xs pull-right">Add User</a> -->
					  </li>
					  <%
					  userList=MySqlDataStoreUtilities.getUsersEvents(e.getEventName(),user.name);
					  %>
                      <li><i class="fa fa-users"></i> <%=userList.size()%> Attendees <a href="DeleteEvent.jsp?value=<%=e.getEventName()%>" class="btn btn-primary btn-stroke btn-xs pull-right">Delete Event</a></li>
                    </ul>
					<%
					for(int k=0;k<userList.size();k++) {
					%>

					<ul class="img-grid">
                      <li>
                        <a href="#">
						<%User u = MySqlDataStoreUtilities.getUserInfo2(userList.get(k));%>
                          <img src="images/<%=u.getProfilePic()%>" alt='<%=u.getFullName()%>' style="height:100px" />
                        </a>
                      </li>
					<%}%>

                    </ul>
                    <div class="clearfix"></div>
                  </div>
                </div>
              				</td>
				<%
				if(i%2!=0)
				{%>
				</tr>
				<%}
				%>

				<%}
				%>
				</table>


				<!--This is for the events that the user is not an admin for-->

				<%
				ArrayList<Events> uList = new ArrayList<Events>();
				uList=MySqlDataStoreUtilities.getEventsAttended(searchedUser.name);
				%>

				<div class="timeline-block">
                  <div class="panel panel-default event">
                    <div class="panel-heading title">
                     <center> <b> Attending:</b> </center>
                    </div>
					</div>
					</div>
				<br>

				<table style="background-color:transparent">
				<%
				//int i =0;
				for(i=0;i<uList.size();i++)
				{
					Events e = uList.get(i);
					if(i%2==0)
					{
						%>
					<tr>
					<%}%>
					<td>
				<%System.out.println("Event number "+(i+1));
						System.out.println("Eventname is "+e.getEventName()+" and the admin is "+e.getEventAdmin());%>

				<div class="timeline-block" style="width:500px">
                  <div class="panel panel-default event">
                    <div class="panel-heading title">
                      <b><%=e.getEventName()%></b>
                    </div>

					<ul class="icon-list icon-list-block">
                      <li><i class="fa fa-globe"></i><%=e.getEventLocation()%></li>
                      <li><i class="fa fa-calendar-o"></i><%=e.getEventDate()%></li>
                      <li><i class="fa fa-clock-o"></i><%=e.getEventTime()%></li>
					  <li>Add person: <select onChange="window.location.href=this.value">
					  <option selected></option>
					  <%
					  for(int j=0;j<friendList.size();j++){
					  User u=friendList.get(j);
					  %>
					  <option value='AddUserEvent.jsp?value1=<%=u.getFullName()%>&value2=<%=e.getEventName()%>'><%=u.getFullName()%></option>
					  <%}%>
					  </select>
				<!--	  <a href="AddUserEvent.jsp?value=<%=e.getEventName()%>" class="btn btn-primary btn-stroke btn-xs pull-right">Add User</a> -->
					  </li>
					  <%
					  userList=MySqlDataStoreUtilities.getUsersEvents(e.getEventName(),searchedUser.name);
					  %>
                      <li><i class="fa fa-users"></i> <%=userList.size()%> Attendees <a href="DropEvent.jsp?value1=<%=e.getEventName()%>&value2=<%=e.getEventAdmin()%>" class="btn btn-primary btn-stroke btn-xs pull-right">Drop Event</a></li>
                    </ul>
					<%
					for(int k=0;k<userList.size();k++) {
					%>

					<ul class="img-grid">
                      <li>
                        <a href="#">
						<%User u = MySqlDataStoreUtilities.getUserInfo2(userList.get(k));%>
                          <img src="images/<%=u.getProfilePic()%>" alt='<%=u.getFullName()%>' style="height:100px" />
                        </a>
                      </li>
					<%}%>

                    </ul>
                    <div class="clearfix"></div>
                  </div>
                </div>
              				</td>
				<%
				if(i%2!=0)
				{%>
				</tr>
				<%}
				%>

				<%}
				%>
				</table>


				</div>

			  <!--<button class="btn btn-success" style="background-color:#26a69a; border-color:transparent">
					<div class="panel-heading title">
						  <a href="CreateEvent.jsp" style="color:white;"><b>Create Event</b> <i class="fa fa fa-plus-circle"></i></a>
						</div>
				</button>-->
			  </div>
		   </div>
		  </div>
		</div>
		  <!-- Footer -->

        <footer class="footer">
        <strong>The Network</strong> &copy; Copyright 2019
        </footer>
        <!--  Footer -->
        </body>
        </html>
