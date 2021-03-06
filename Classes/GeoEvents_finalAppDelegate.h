//
//  GeoEvents_finalAppDelegate.h
//  GeoEvents_final
//
//  Created by Martin Roedvand on 07/12/2009.
//  Copyright Redwater Software 2009. All rights reserved.
//
#import "GlobalHeader.h"

#import <CoreLocation/CoreLocation.h>
#import "Event.h"
#import "SettingsViewController.h"

@interface GeoEvents_finalAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIBarButtonItem * settingsButton;
    UINavigationController *navigationController;
	SettingsViewController * settingsViewController;
	NSMutableArray * searchHistory;
	NSNumber * lat;
	NSNumber * lon;
	NSNumber * range;
	NSNumber * numberOfEventsToBeFetched;
	bool isUsingGps;
	NSString * searchString;
	bool lastfmstatus;
	bool searchSuggestions;
	NSArray * events;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) UIBarButtonItem * settingsButton;
@property (nonatomic, retain) SettingsViewController * settingsViewController;
@property (nonatomic, retain) Event * selectedEvent;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSNumber * range;
@property (nonatomic, retain) NSMutableArray * searchHistory;
@property (nonatomic, retain) NSString * searchString;
@property (nonatomic, retain) NSNumber * numberOfEventsToBeFetched;
@property (nonatomic, retain) NSArray * events;
@property bool isUsingGps;
@property bool lastfmstatus;
@property bool searchSuggestions;
@end

