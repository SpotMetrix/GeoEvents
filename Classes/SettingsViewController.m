//
//  SettingsViewController.m
//  GeoEvents_final
//
//  Created by Martin Roedvand on 11/12/2009.
//  Copyright 2009 Redwater software. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
	}
	self.title = @"Settings";
	return self;
}
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    self.title = @"Settings";
    return self;
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return sNUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch(section) {
		case sAccountSettings:
			return sNUM_ACCOUNT_ROWS;
		case sSearchSettings:
			return sNUM_SEARCH_ROWS;
		case sAboutSection:
			return sNUM_ABOUT_ROWS;
	}
	
	return 1;
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"General";
	
	// For our account cells
	if(indexPath.section == sAccountSettings) {
		UITableViewCell *accountCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		//Code for our different account cells
		if(accountCell == nil) {
			accountCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		}
		NSString * imgPath;
		UIImage * image;
		switch(indexPath.row) {
			case sLastfmRow:
				imgPath = [[NSBundle mainBundle] pathForResource:@"lastfm" ofType:@"png"];
				image = [UIImage imageWithContentsOfFile:imgPath];
				if(image == nil) {
					NSLog(@"Image == nil");
				}
				accountCell.imageView.image = image;
				[accountCell.textLabel setText:@"Last.fm"];
				break;
			case sFacebookRow:
				[accountCell.textLabel setText:@"Facebook"];
				break;
			case sTwitterRow:
				[accountCell.textLabel setText:@"Twitter"];
				break;
		}
		
		return accountCell;
	}
	
	// For our search setting cell
	if(indexPath.section == sSearchSettings) {
		UITableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if(searchCell == nil) {
			// We define our cell to use Value1 style. This is black text on the left, blue text on the right
			searchCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		}
		
		searchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		switch(indexPath.row) {
			case sKilometersRangeRow:
				[searchCell.textLabel setText:@"Search radius"];
				[searchCell.detailTextLabel setText:@"50 km"];
				break;
			case sNumberOfResultsRow:
				[searchCell.textLabel setText:@"Max events shown"];
				[searchCell.detailTextLabel setText:@"100"];
				break;
		}
		
		return searchCell;
	}
	
	// For our about cells
	if(indexPath.section == sAboutSection) {
		UITableViewCell *aboutCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if(aboutCell == nil) {
				aboutCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		aboutCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[aboutCell.textLabel setText:@"About"];
		return aboutCell;
		
	}
	
	

	
	return nil;
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch(section) {
		case sAccountSettings:
			return @"Account Settings";
		case sSearchSettings:
			return @"General Search Settings";
		case sAboutSection:
			return @"About this app";
	}
	return nil;
}

- (void)dealloc {
    [super dealloc];
}


@end
