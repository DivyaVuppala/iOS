//
//  ThemeSelectionViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 3/4/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "ThemeSelectionViewController.h"

#import "iPitchConstants.h"

#import "Utils.h"

@interface ThemeSelectionViewController ()

@end

@implementation ThemeSelectionViewController

@synthesize themeListTableView,sortedKeys,settingsTableContents;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
	//NSDictionary *temp =[[NSDictionary alloc]initWithObjectsAndKeys:@"A",@"A",@"A",@"B",@"A",@"c",nil];
    
    
    self.settingsTableContents=[[NSMutableDictionary alloc]initWithObjectsAndKeys:NSLocalizedString(@"APPLY_THEME_1",@"Apply Theme 1"),IPITCH_THEME1_NAME,NSLocalizedString(@"APPLY_THEME_2",@"Apply Theme 2"),IPITCH_THEME2_NAME, nil];
    
	NSLog(@"table %@",self.settingsTableContents);
	NSLog(@"table with Keys %@",[self.settingsTableContents allKeys]);
    
    self.sortedKeys =  [[self.settingsTableContents allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
	//self.sortedKeys =[[self.tableContents allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    [super viewDidLoad];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
#pragma mark Table View Datasource Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sortedKeys count];
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 44.0)];
    //headerView.contentMode = UIViewContentModeScaleToFill;
    
    // Add the label
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, -5.0, 300.0, 44)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    
    headerLabel.text = [self.sortedKeys objectAtIndex:section];
    
    
    headerLabel.textColor = [Utils colorFromHexString:ORANGE_COLOR_CODE];
    headerLabel.highlightedTextColor = [UIColor blackColor];
    
    //this is what you asked
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18];
    
    headerLabel.shadowColor = [UIColor clearColor];
    headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    headerLabel.numberOfLines = 0;
    [headerView addSubview: headerLabel];
    
    // Return the headerView
    return headerView;
}
/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 return [[self.sortedKeys objectAtIndex:section] substringFromIndex:3];
 }*/

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView setBackgroundView:nil];
    
	static NSString *CellIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    else
    {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.font=[UIFont fontWithName:FONT_BOLD size:18];
    cell.textLabel.textColor=[Utils colorFromHexString:@"868686"];
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:[self.sortedKeys objectAtIndex:[indexPath section]]]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.settingsTableContents objectForKey:[self.sortedKeys objectAtIndex:[indexPath section]]]];
        

	return cell;
}

#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    [Utils userDefaultsSetObject:[self.sortedKeys objectAtIndex:[indexPath section]] forKey:IPITCH_CURRENT_THEME_NAME];
    
    if ([[self.sortedKeys objectAtIndex:indexPath.section] isEqualToString:IPITCH_THEME1_NAME])
    {
        [Utils userDefaultsSetObject:IPITCH_THEME1_BG forKey:IPITCH_CURRENT_THEME_BG_IMAGE];
    
    }

    else if ([[self.sortedKeys objectAtIndex:indexPath.section] isEqualToString:IPITCH_THEME2_NAME])
    {
        [Utils userDefaultsSetObject:IPITCH_THEME2_BG forKey:IPITCH_CURRENT_THEME_BG_IMAGE];
    }
    
    
    [tableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
