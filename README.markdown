Megaphone
=========

Megaphone provides a simple way to inform your current customers about app launches and updates inside your own application.

Installation
------------

###Server Side

Place a id.json file and notification.json on your webserver in the same folder.

The id.json file should contain:
	[id]
id is an integer identifier for your notification that you will keep increasing with each succesive message.

The notification.json file should contain
	{ "title":"",
	  "body":"",
	  "link":"",
	  "buttonTitle":"",
	  "cancelTitle":"",
	}
title - title of the message
body - body text of the message
link - Link which user is sent to when they click the non-cancel button
buttonTitle - The text of the button which sends users to the link
cancelTitle - The text of the cancel button

	
###Client Side

1. Download Source Code
2. Compile the project
3. In build/iphoneos-release/ find the megaphone folder and add it to your project
4. Add -ObjC and -all_load as linker flags for compilation
5. Allocate and initialize a MPNotification object when you want an message to be fetched
		- (void) viewWillAppear {
			MPNotification *aNotification = [[MPNotification alloc] initWithAddress:@"http://www.bloqsoftware.com"];
		}
7. Call showNotification on the MPNotification object whenever you want an alert to be shown if available
		- (void)viewDidAppear {
			[aNotification showNotification];
		}
	

Credit:
This project uses a copy of the excellent JSON library from http://code.google.com/p/json-framework/
