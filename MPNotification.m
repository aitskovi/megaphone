//
//  MPNotification.m
//  megaphone
//
//  Created by Avi Itskovich on 10-06-27.
//  Copyright 2010 Bloq Software. All rights reserved.
//

#import "MPNotification.h"

@implementation MPNotification

- (id)init {
	if ((self = [super init])) {
		// Send request to server for a notification
		[self fetchNotification];
		// Fetch last notification id
		notificationId = [[NSUserDefaults standardUserDefaults] integerForKey:@"MPNotificationID"];
	}
	return self;
}

- (void)fetchNotification {
	NSLog(@"Fetch Notification");
	responseData = [[NSMutableData data] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.bloqsoftware.com/notification.json"]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)showNotification {
	// If new alert hasn't been found
	if (alert == nil) {
		NSData *storedData = [[NSUserDefaults standardUserDefaults] dataForKey:@"MPNotification"];
		if (storedData == nil) {
			return;
		} else {
			[self createAlertFromData:storedData];
		}
	}
	// Remove pre-cached data and update presented alert id
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MPNotification"];
	[alert show];
}

- (void)createAlertFromData:(NSData *)data {
	NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	// Parse the JSON data
	NSDictionary *notification = [responseString JSONValue];
	
	// Save data to make sure you have it even if application quits
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:@"MPNotification"];
	
	// Create an alert from the object
	buttonLink = [[notification objectForKey:@"link"] retain];
	NSString *title = [notification objectForKey:@"title"];
	NSString *body = [notification objectForKey:@"body"];
	NSString *buttonTitle = [notification objectForKey:@"buttonTitle"];
	NSString *cancelButtonTitle = [notification objectForKey:@"cancelButtonTitle"];
	
	alert = [[UIAlertView alloc] initWithTitle:title message:body delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:buttonTitle,nil];
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		NSLog(@"I MADE IT");
		[[UIApplication sharedApplication] openURL:buttonLink];
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
	NSDictionary *notification = [responseString JSONValue];
	int newNotificationID = [[notification objectForKey:@"NotificationID"] intValue];
	if (newNotificationID > notificationId) {
		[self createAlertFromData:responseData];
		notificationId = newNotificationID;
	}
	[responseData release];
	responseData = nil;
}

- (void)dealloc {
	[super dealloc];
}
@end
