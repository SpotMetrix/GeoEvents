//
//  Event.h
//  GeoEvents_final
//
//  Created by Martin Roedvand on 07/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Event : NSObject {
	NSString * ident;
	NSString * artist;
	NSString * venue;
	NSString * date;
	NSArray * tags;
	NSString * eventUrl;
	NSString * eventStatus;
	NSString * latitude;
	NSString * longitude;
}

@property (nonatomic, retain) NSString * ident;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * eventUrl;
@property (nonatomic, retain) NSString * eventStatus;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSArray * tags;

@end
