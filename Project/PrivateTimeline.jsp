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

  <%@ page
  import= "com.User, com.Status, com.Comment, com.AutoComplete, com.MySqlDataStoreUtilities, com.MongoDBDataStoreUtilities, java.io.*, javax.servlet.*,
  javax.servlet.http.*, java.util.*"%>
<%
      User user = null;
      ArrayList<Status> statusList = new ArrayList<Status>();
      List<Comment> commentList = new ArrayList<Comment>();
      HashMap<String,String> friendList = null;
      User friendRequestBy = null;
      User friend = null;
      if(session!=null)
      {
          String email = session.getAttribute("user").toString();
          user = MySqlDataStoreUtilities.getUserInfo(email);
          statusList = MySqlDataStoreUtilities.getUserStatus(email);
          friendList = MySqlDataStoreUtilities.getFriendRequests(email);
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
<strong><a class='navbar-brand' href='PrivateAbout.jsp'>The Network</a></strong>
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
                <span class="badge badge-primary"><%= friendList.size() %></span>
              </a>
              <ul class="dropdown-menu" role="notification">
                <li class="dropdown-header">Notifications</li>
<%
  if(friendList.size()!=0)
  {
    for(Map.Entry<String, String> entry : friendList.entrySet())
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
                    <button class="btn btn-default btn-circle"><i class="fa fa-remove"></i></button>
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
                  <img src='images/<%= user.coverpic %>' style="width:1138px;height:300px;" />
                </div>
              <div class='cover-info'>
                <div class='avatar'>
               <img src='images/<%= user.profilepic %>' />
                </div>
                <div class='name'><a href='#'><%= user.name %></a></div>
                <ul class='cover-nav'>
                  <li><a href='PrivateAbout.jsp'><i class=''></i> My Profile</a></li>
                  <li class='active'><a href='PrivateTimeline.jsp'><i class=''></i> Feed</a></li>
                  <li><a href='PrivateFriends.jsp'><i class=''></i> Friends</a></li>
                  <li><a href='PrivateEvents.jsp'><i class=''></i> Posts</a></li>
                 
                </ul>
              </div>
            </div>
            <div class="col-xs-12 col-md-6 col-lg-4 item">
              <table style="width:1115px; background-color:transparent;">
      <%
      int i =0;
      for(i=0;i<statusList.size();i++)
      {
        commentList = MongoDBDataStoreUtilities.getComments(user.email, statusList.get(i).status);
        if(i%2==0)
        {
      %>
        <tr>
      <%}%>
      <td>
                <div class="timeline-block">
                  <div class="panel panel-default">

                    <div class="panel-heading">
                      <div class="media">
                        <div class="media-left">
                          <a href="">
                            <img src="images/<%= user.profilepic %>" height="50" width="50" class="media-object">
                          </a>
                        </div>
                        <div class="media-body">

                          <a href=""><%= user.name %></a>

                          <span>on <%= statusList.get(i).date %></span>
                        </div>
                      </div>
                    </div>

                    <div class="panel-body">
                      <p><%= statusList.get(i).status %></p>
                    </div>
                    <div class="view-all-comments">

                      <a href="#">
                        <i class="fa fa-comments-o"></i>
                      </a>
                     <span> <%=commentList.size()%> comments</span>
                    </div>
            <form id='upload' action="InsertCommentServlet?searchedUser=<%= user.email %>" method="post">

            <ul class="comments">
              <li class="comment-form">
                <div class="input-group">

                <span class="input-group-btn">
                  <a href="" class="btn btn-default"><i class="fa fa-comment"></i></a>
                </span>

                <input name="comment" type="text" style="height:36px;width:447px"/><button type='submit'  href='#' class='btn btn-primary btn-xs pull-right display-none' style="display:block;height:35px;">Post</button>
                <input type="hidden" name="status" value="<%=statusList.get(i).status%>" />
                <input type="hidden" name="email"value="<%=user.email%>" />

              </div>
            </li>
          </ul>
          </form>
          <ul class="comments">
            <% for (Comment comment : commentList) { %>
              <li class="comment-form">
            <% User commentedUser = MySqlDataStoreUtilities.getUserInfo(comment.getEmail()); %>
            <div class="media">
              <div class="media-left">
                <a href=""> <img class='img-circle'src="images/<%=commentedUser.profilepic%>" height="50" width="50" class="media-object">
                </a>
              </div>
              <div class="media-body" >
                <a href=""><%=commentedUser.name%></a>
                <div class="media-body">
                  <span><%=comment.getComment()%> </span>
                </div>
              </div>
            </div>
                      </li>
              <%}%>
            </ul>

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
            </div>
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
