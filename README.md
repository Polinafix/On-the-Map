# On the Map

The On The Map app allows users to share their location and a URL with their fellow students.

Objectives learned:
- Accessing networked data using Apple’s URL loading framework
- Authenticating a user using over a network connection
- Using Facebook SDK to implement Facebook Login
- Creating user interfaces that are responsive, and communicate network activity
- Using Core Location and the MapKit framework for to display annotated pins on a map


The app has three pages of content:
- Login View: Allows the user to log in using their Udacity credentials
- Map and Table Tabbed View: Allows users to see the locations of other students in two formats.  
- Information Posting View: Allows the users specify their own locations and links.


##### Login View

The login view accepts the email address and password that students use to login to the Udacity site.
When the user taps the Login button, the app will attempt to authenticate with Udacity’s servers. Clicking on the Sign Up link will open Safari to the Udacity sign-up page.
If the login does not succeed, the user will be presented with an alert view specifying whether it was a failed network connection, or an incorrect email and password.
Users can also login with their Facebook account.

&nbsp;![img1](https://i.imgur.com/1ur8mNE.gif)

##### Map And Table Tabbed View

If the connection is made and the email and password are good, the app will segue to the Map and Table Tabbed View.
This view has two tabs at the bottom: one specifying a map, and the other a table, both displaying the most recent 100 locations posted by students.

&nbsp;![img1](https://i.imgur.com/flXiHBY.gif)

The user is able to zoom and scroll the map to any location using standard pinch and drag gestures.
When the user taps a pin, it displays the pin annotation popup, with the student’s name and the link associated with the student’s pin.
Tapping anywhere within the annotation will launch Safari and direct it to the link associated with the pin.
In the table view  each row displays the student’s name. Tapping on the row launches Safari and opens the link associated with the student.
Clicking on the reload button will refresh the entire data set by downloading and displaying the most recent 100 posts made by students.



##### Information Posting View
Clicking on the pin button will modally present the Information Posting View.
The Information Posting View allows users to input their data: their location string and their link.
When the user clicks on the “Find on the Map” button, the app will forward geocode the string. 
A new button will be displayed allowing the user to submit their data. 

&nbsp;![img1](https://i.imgur.com/apZ0ahe.gif)


If the submission fails to post the data to the server, then the user should see an alert with an error message describing the failure.

### License
This project is licensed under the MIT License - see the [MIT](https://choosealicense.com/licenses/mit/) for details











