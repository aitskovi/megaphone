Megaphone
=========

Megaphone provides a simple way to inform your current customers about app launches and updates inside your own application.

Installation
------------
1. Download Source Code
2. Edit the URL from where the JSON is fetched
3. Compile the project
4. In build/iphoneos-release/ find the megaphone folder and add it to your project
5. Add -ObjC and -all_load as linker flags for compilation
6. Allocate and initialize a MPNotification object when you want an add to be fetched
		- (void) viewWillAppear {
			MPNotification *aNotification = [[MPNotification alloc] init];
		}
7. Call showNotification on the MPNotification object whenever you want an alert to be shown if available
		- (void)viewDidAppear {
			[aNotification showNotification];
		}
	

Credit:
This project uses a copy of the excellent JSON library from http://code.google.com/p/json-framework/
