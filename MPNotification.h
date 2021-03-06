//
//  MPNotification.h
//  megaphone
//
//  Created by Avi Itskovich on 10-06-27.
//  Copyright 2010 Bloq Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MPNotification : NSObject <UIAlertViewDelegate>{
	NSMutableData *responseData;
	UIAlertView *alert;
	int notificationId;
	NSURL *link;
	NSString *alertURL;
}

@property (nonatomic, retain) NSString *alertURL;

// API Methods
- (id)init;
- (id)initWithAddress:(NSString	*)address;
- (void)showNotification;

// Private methods
- (void)fetchNotification;
- (void)fetchID;
- (UIAlertView *)createAlertFromDictionary:(NSDictionary *)data;

// UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// NSURLConnectionDelegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
