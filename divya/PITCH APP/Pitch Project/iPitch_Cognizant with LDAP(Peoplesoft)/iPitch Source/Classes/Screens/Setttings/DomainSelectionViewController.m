//
//  DomainSelectionViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 3/4/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "DomainSelectionViewController.h"

#import "iPitchConstants.h"

#import "Utils.h"

@interface DomainSelectionViewController ()

@end

@implementation DomainSelectionViewController

@synthesize domainListTableView,domainList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    
    self.domainList =  [NSArray arrayWithObjects:BFS_DOMAIN,INSURANCE_DOMAIN ,nil];
    
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
    return 1;
}



- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [self.domainList count];
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

    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN] isEqualToString:[domainList objectAtIndex:indexPath.row]]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[domainList objectAtIndex:indexPath.row]];
        
    
	return cell;
}

#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [Utils userDefaultsSetObject:[self.domainList objectAtIndex:indexPath.row] forKey:IPITCH_CURRENT_DOMAIN];
    
    if ([[self.domainList objectAtIndex:indexPath.row] isEqualToString:BFS_DOMAIN]) {
        [Utils userDefaultsSetObject:BFS_STAGES_PLIST forKey:IPITCH_CURRENT_DOMAIN_PLIST_FILE];

    }
    
    else if ([[self.domainList objectAtIndex:indexPath.row] isEqualToString:INSURANCE_DOMAIN]) {
        [Utils userDefaultsSetObject:INSURANCE_STAGES_PLIST forKey:IPITCH_CURRENT_DOMAIN_PLIST_FILE];

    }
    [tableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
