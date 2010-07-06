//
//  MPNotification.m
//  megaphone
//
//  Created by Avi Itskovich on 10-06-27.
//  Copyright 2010 Bloq Software. All rights reserved.
//

#import "MPNotification.h"
#import "JSON.h"

@implementation MPNotification

@synthesize alertURL;

- (id)init {
	return self = [self initWithAddress:@"http://209.222.173.237"];
}

/*
 * Initializer that allows you to specify which server to get alerts from
 */
- (id)initWithAddress:(NSString *)address {
	if ((self = [super init])) {
		//TODO: Make sure this isn't a bad URL
		self.alertURL = address;
		// Send request to server for a notification
		[self fetchID];
		// Fetch last notification id
		notificationId = [[NSUserDefaults standardUserDefaults] integerForKey:@"MPNotificationID"];
	}
	return self;
}

/*
 * Initiate connection to fetch the notification id for the next alert
 */
- (void)fetchID {
	responseData = [[NSMutableData data] retain];
	NSString *urlString = [NSString stringWithFormat:@"%@/megaphone/data/id.json", self.alertURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

/*
 * Initiate connection to fetch the notification data for the next alert
 */
- (void)fetchNotification {
	responseData = [[NSMutableData data] retain];
	NSString *urlString = [NSString stringWithFormat:@"%@/megaphone/data/notification.json", self.alertURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

/*
 * Show the notification as an AlertView (show cached notification if new isn't available)
 */
- (void)showNotification {
	// If new alert hasn't been found
	if (alert == nil) {
		NSData *storedData = [[NSUserDefaults standardUserDefaults] dataForKey:@"MPNotification"];
		if (storedData == nil) {
			return;
		} else {
			alert = [[self createAlertFromData:storedData] retain];
		}
	}
	// Remove pre-cached data and update presented alert id
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MPNotification"];
	[alert show];
}

/*
 * Parse the fetched alert data and create a UIAlertView from it to be shown
 */
- (UIAlertView *)createAlertFromData:(NSData *)data {
	NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	// Parse the JSON data
	NSDictionary *notification = [responseString JSONValue];
	
	// Save data to make sure you have it even if application quits
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:@"MPNotification"];
	
	// Create an alert from the object
	link = [[NSURL URLWithString:[notification objectForKey:@"link"]] retain];
	NSString *title = [notification objectForKey:@"title"];
	NSString *body = [notification objectForKey:@"body"];
	NSString *buttonTitle = [notification objectForKey:@"buttonTitle"];
	NSString *cancelButtonTitle = [notification objectForKey:@"cancelTitle"];
	
	// Check that you can quit the application
	if (cancelButtonTitle == nil) {
		return nil;
	}
	
	UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:title message:body delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:buttonTitle,nil] autorelease];
	return alertView;
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[[UIApplication sharedApplication] openURL:link];
	}
}

#pragma mark -
#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// Zero-out data to prepare to recieve info
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Connection failed with error");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	
	// Make sure its a new Notification and create an alert from it if it is
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	id notification = [responseString JSONValue];
	// Check if you're parsing the notification id or the notification data
	if ([notification isKindOfClass:[NSArray class]]) {
		// If there's a new notification get it and show it)
		int newId = [[notification objectAtIndex:0] intValue];
		if (newId > notificationId) {
			notificationId = newId;
			[responseData release];
			responseData = nil;
			[self fetchNotification];
		} else {
			[responseData release];
			responseData = nil;
		}
	} else {
		alert = [[self createAlertFromData:responseData] retain];
		[[NSUserDefaults standardUserDefaults] setInteger:notificationId forKey:@"MPNotificationID"];
		[responseData release];
		responseData = nil;
	}
}

- (void)dealloc {
	[alertURL release];
	[super dealloc];
}
@end
