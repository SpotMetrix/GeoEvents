//
//  IndexViewController.m
//  GeoEvents
//
//  Created by Martin Roedvand on 12/12/2009.
//  Copyright 2009 Redwater software. All rights reserved.
//

#import "IndexViewController.h"
#import "GeoEvents_finalAppDelegate.h"
#import "EditableDetailCell.h"

@implementation IndexViewController

@synthesize searchViewViewController, 
			searchField,
			latitude,
			longitude,
			locationFound,
			run,
			settingsViewController,
			activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"GeoEvents";
	
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	appDelegate.events = nil;
	
	//Add button to navigationBar
	UIBarButtonItem * settingsBtn = [[UIBarButtonItem alloc]initWithTitle:@"Settings" 
																	style:UIBarButtonItemStyleBordered target:self action:@selector(goToSettings:)];
	
	[self.navigationItem setRightBarButtonItem:settingsBtn animated:NO];
	[settingsBtn release];
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	run = 0;
	locationController = [[MyCLController alloc] init];
	locationController.delegate = self;	
	[locationController.locationManager startUpdatingLocation];
	
}

- (void)goToSettings:(id)sender {
	if(settingsViewController == nil) {
		SettingsViewController * settings = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped]; 
		self.settingsViewController = settings;
		[settings release];
	}
	
	[self.navigationController pushViewController:self.settingsViewController animated:YES];
	
}

- (void)dealloc {
    [super dealloc];
}

- (void)locationUpdate:(CLLocation *)location {
	bool simulator = YES;
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	
	latitude = [NSNumber numberWithDouble:[location coordinate].latitude];
	longitude = [NSNumber numberWithDouble:[location coordinate].longitude];
	
	appDelegate.lat = latitude;
	appDelegate.lon = longitude;

	if(run == 5 || simulator && !locationFound) {
		locationFound = YES;
		NSArray * indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]];
		[self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationBottom];
	}
	/*
	NSLog(@"Location: %f", [location coordinate].latitude);
	NSLog(@"Location: %f", [longitude doubleValue]);
	 */
	[locationController.locationManager stopUpdatingLocation];
}

- (void)locationError:(NSError *)error {
    
}

- (void)search:(NSString *)searchText addToSearchHistory:(bool)addToSearch {
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	NSMutableArray * theSearchHistory = appDelegate.searchHistory;
	//We now have a search history
	appDelegate.searchSuggestions = NO;
	
	if(addToSearch && searchText != nil) {
		[theSearchHistory addObject:searchText];
	}
	appDelegate.searchString = searchText;
	[self loadSearchView:NO];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[activityIndicator stopAnimating];
	[self.tableView reloadData];
}

- (void)searchByGps {
	[self loadSearchView:YES];
}

-(void)loadSearchView:(bool)isUsingGps {
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	appDelegate.isUsingGps = isUsingGps;
	
	SearchViewController * searchView = [[SearchViewController alloc] initWithStyle:UITableViewStylePlain];
	self.searchViewViewController = searchView;
	[self.navigationController pushViewController:searchViewViewController animated:YES];
	[searchView release];
	
	
}

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
	return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	NSMutableArray * theSearchHistory = appDelegate.searchHistory;

	switch(section) {
		case searchSection:
			 if(locationFound) {
				return NUM_HEADER_SECTION_ROWS;
			} else {
				return 1;
			}
		case historySection:
			if(theSearchHistory != nil) {
				if([theSearchHistory count] > 3) {
					return 3;
				} else {
					return [theSearchHistory count];
				}
			}
		//case settingSection:
		//	return 1;
		default:
			return 1;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	static NSString *CellSearch = @"searchHistory";
	static NSString *CellGPS = @"GPS";
	//static NSString *CellSetting = @"Settings";

	
	if(indexPath.section == searchSection) {
		switch(indexPath.row) {
			// Our cell where we fill in text and search
			case searchSectionSearchRow:
				;
				EditableDetailCell *sectionSearchCell = [[[EditableDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				
				searchField = [sectionSearchCell textField];
				[searchField setClearButtonMode:UITextFieldViewModeNever];
				[searchField setReturnKeyType:UIReturnKeySearch];
				[searchField setAutocorrectionType:UITextAutocorrectionTypeNo];
				[searchField setPlaceholder:@"City, country"];
				searchField.delegate = self;
				return sectionSearchCell; 
				
			// Our cell where we search using the GPS information
			case searchSectionSearchByGpsRow:
				;
				UITableViewCell *gpsSearchCell = [tableView dequeueReusableCellWithIdentifier:CellGPS];
				
				if (gpsSearchCell == nil) {
					gpsSearchCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellGPS] autorelease];
				}
				
				if(locationFound) {
					gpsSearchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					[gpsSearchCell.textLabel setText:@"Search using GPS"];
				} else {
					[gpsSearchCell.textLabel setText:@"Aquiring GPS data"];
				}
				
				return gpsSearchCell;
			default:
				NSAssert(NO, @"Unhandled value in searchSection cellForRowAtIndexPath");
		}
	}
	
	if(indexPath.section == historySection) {
		// Get appDelegate and the array where we keep our search history
		GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
		NSMutableArray * theSearchHistory = appDelegate.searchHistory;
		
		UITableViewCell * searchHistoryCell = [tableView dequeueReusableCellWithIdentifier:CellSearch];
		
		if (searchHistoryCell == nil) {
			searchHistoryCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
		searchHistoryCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[searchHistoryCell.textLabel setText:[[theSearchHistory objectAtIndex:[theSearchHistory count] - indexPath.row - 1]capitalizedString]];
		
		return searchHistoryCell;
	}
	/*
	if (indexPath.section == settingSection) {
		
		 Get the AppDelegate and get our global setting for range.
		 
		GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
		NSNumber * rangeSettings = appDelegate.range;
		
		UITableViewCell * rangeSettingCell = [tableView dequeueReusableCellWithIdentifier:CellSetting];
		
		if(rangeSettingCell == nil) {
			rangeSettingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellSetting];
		}
		
		rangeSettingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		

		[rangeSettingCell.textLabel setText:@"Search range"];
		

		NSMutableString * rangeText;
		
		if(rangeSettings == nil) {
			rangeText = [NSMutableString stringWithString:@"Not defined"];
		} else {
			rangeText = [NSMutableString stringWithString:[rangeSettings stringValue]];
			[rangeText appendString:@" km"];
		}

		[rangeSettingCell.detailTextLabel setText:rangeText];
		
		return rangeSettingCell;
	}
	*/
	
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	NSMutableArray * theSearchHistory = appDelegate.searchHistory;
	
	switch(section) {
		case searchSection:
			return @"Search";
		case historySection:
			if([theSearchHistory count] > 0) {
				if(appDelegate.searchSuggestions) {
					return @"Search suggestions";
				} else {
					return @"Search history";
				}
			}
		default:
			return nil;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == searchSection) {
		switch (indexPath.row) {
			case searchSectionSearchRow:
				;
				break;
			case searchSectionSearchByGpsRow:
				if(locationFound) {
					[self searchByGps];
				}
				break;
		}
	}
	
	/*
	 If we have anything in our searchHistory section, we allow the user to
	 select one and send him to the search
	 */
	if(indexPath.section == historySection) {
		[activityIndicator startAnimating];
		GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
		NSMutableArray * theSearchHistory = appDelegate.searchHistory;
		
		[self search:[theSearchHistory objectAtIndex:[theSearchHistory count] - indexPath.row - 1] addToSearchHistory:NO];
				
	}
}

#pragma mark UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	if([textField text].length == 0) {
		UIAlertView *charAlert = [[UIAlertView alloc]
								  initWithTitle:@"Empty search"
								  message:@"Your search is empty."
								  delegate:nil
								  cancelButtonTitle:@"OK, I'll fix that"
								  otherButtonTitles:nil];
		[charAlert show];
		[charAlert release];
	} else {
		[self search:[textField text] addToSearchHistory:YES];
	}
	return NO;
}

@end

