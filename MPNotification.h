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
}

- (id)init;
- (void)showNotification;
- (void)fetchNotification;
- (void)createAlertFromData:(NSData *)data;

// UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// NSURLConnectionDelegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
