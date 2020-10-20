# TheNetwork
A Networking website for both Social and Professional use
---->The Network <----

In this application, a student can connect with their friends using their .edu email id, they can create/delete status, add/remove friends, edit profile, create/remove posts. We have added a functionality for the user where they can mark their post as Social or Professional

We used JSP, Servlets, and the data we are storing in MySQL and MongoDB. Using Python markdown we have fetched data from Twitter.

---->Total Number of Lines of code written<---- 
Total Files: 56
Total Lines of Code:9355


---->Features of our Project<----

-User can signup and login using a .edu only email address
-They can upload profile/cover pictures
-They can add and remove status which will be displayed in their feed
-They can comment on others statuses
-They can add/remove friends, once a friend request is sent, the user who received the request will get a notification on their web profile
-They can create/remove post and specify each post as Professional or Social.
-They can invite their friends to events and it will show up on their profile.
-They can apply for the jobs through tweets that will be displayed on this private page.


---->Assignment Features Implemented in our Project <----

Signup 
Login and Logout
AutoSearch Complete feature
Twitter API



---->How to Deploy and Run<----

-Run MongoDB, MySQL.
-Make the database NetworkDatabase in MongoDB and MySQl
-Create a collection named comments in MongoDB
-The create table commands of each table that are necessary for the project to run are given in the queries.txt file
The tables created are
                
                 - UserEvent
                 - FriendList.  
                 - statuslist.
                 - UserProfile.
-Apart from the jar files already used in the assignments, two additional .jar files named 'commons-file-upload-1.3.2' and 'commons-io-2.6' have been used for implementing file upload functionalities. These jars should be downloaded and compiled and be set in the environment variables.

-The Twitter API key is present in the credentials.txt in the Project folder.

-Run Apache Tomcat
-open the browser : localhost:8080/Project/

