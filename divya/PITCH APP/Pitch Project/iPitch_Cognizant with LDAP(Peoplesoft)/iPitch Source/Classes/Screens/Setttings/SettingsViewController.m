//
//  SettingsViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 2/28/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "SettingsViewController.h"

#import "CRMSelectionViewController.h"

#import "iPitchConstants.h"

#import "ThemeSelectionViewController.h"

#import "DomainSelectionViewController.h"

#import "Utils.h"

#import "ThemeHelper.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
        
    NSArray *zohoSettingItems=[NSArray arrayWithObjects:NSLocalizedString(@"CURRENT_ZOHO_ACCOUNT",@"Current Zoho Account"),NSLocalizedString(@"ZOHO_GENERAL_SETTINGS",@"Zoho General Settings"), nil];
    NSArray *boxSettingItems=[NSArray arrayWithObjects:NSLocalizedString(@"CURRENT_BOX_ACCOUNT",@"Current Box Account"),NSLocalizedString(@"BOX_SETTINGS","Box Settings"), nil];
    NSArray *themeSettingItems=[NSArray arrayWithObjects:NSLocalizedString(@"THEME",@"Theme"),nil];

    NSArray *domainSettingItems=[NSArray arrayWithObjects:NSLocalizedString(@"CURRENT_DOMAIN",@"Current Domain"),nil];

    self.settingsTableContents=[[NSMutableDictionary alloc]initWithObjectsAndKeys:zohoSettingItems,NSLocalizedString(@"CRM",@"01.CRM"),boxSettingItems,NSLocalizedString(@"CONTENT_MANAGEMENT",@"02.Content Management"),domainSettingItems,NSLocalizedString(@"DOMAIN_SETTINGS",@"03.Domain Settings"),themeSettingItems,NSLocalizedString(@"CHANGE_COLOR_THEME",@"04.Change Color Theme") ,nil];
    
	NSLog(@"table %@",self.settingsTableContents);
	NSLog(@"table with Keys %@",[self.settingsTableContents allKeys]);
    
    self.sortedKeys =  [[self.settingsTableContents allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
	//self.sortedKeys =[[self.tableContents allKeys] sortedArrayUsingSelector:@selector(compare:)];
	NSLog(@"sorted %@",self.sortedKeys);
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DONE","Done") style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonPressed:)];
    
    self.navigationItem.rightBarButtonItem=doneButton;
    

    [super viewDidLoad];
}


-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [self.settingsTableView reloadData];
    [ThemeHelper applyCurrentThemeToView];

    
}
// Override to allow orientations other than the default portrait orientation.
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setSettingsTableView:nil];
    [self setDoneButton:nil];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table View Datasource Methods

-(CGFloat)getLabelHeightForIndex:(NSIndexPath *)index
{
    NSArray *listData =[self.settingsTableContents objectForKey:[self.sortedKeys objectAtIndex:[index section]]];
    CGSize maximumSize = CGSizeMake(900, 200);
    CGSize labelHeighSize = [[listData objectAtIndex:index.row] sizeWithFont: [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0f] constrainedToSize:maximumSize];
    // NSLog(@"label size in fn:%f",labelHeighSize.height);
    return labelHeighSize.height;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*int tempHeight = [self getLabelHeightForIndex:indexPath];
    
    if (tempHeight<=19) {
        return 44;
    }
    
    else{
        return 100;
    }*/
    
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
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
    
    headerLabel.text = [[self.sortedKeys objectAtIndex:section] substringFromIndex:3];
    
    
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
	return [[self.settingsTableContents objectForKey:[self.sortedKeys objectAtIndex:section]] count];
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
        
        UILabel *accessoryLabel=[[UILabel alloc]initWithFrame:CGRectMake(250, 10, 230, 30)];
        
        [accessoryLabel setTag:10];
        accessoryLabel.backgroundColor = [UIColor clearColor];
        accessoryLabel.opaque = NO;
                
        
        accessoryLabel.textColor = [Utils colorFromHexString:ORANGE_COLOR_CODE];
        accessoryLabel.highlightedTextColor = [UIColor blackColor];
        accessoryLabel.textAlignment=NSTextAlignmentRight;
        accessoryLabel.font = [UIFont fontWithName:FONT_BOLD size:16];
        
        accessoryLabel.shadowColor = [UIColor clearColor];
        accessoryLabel.shadowOffset = CGSizeMake(0.0, 1.0);
         
        [cell addSubview:accessoryLabel];
        
        
    }
    
    else
    {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.font=[UIFont fontWithName:FONT_BOLD size:16];
    cell.textLabel.textColor=[Utils colorFromHexString:@"868686"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;


    
    if (indexPath.row==0 && indexPath.section==0)
    {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.settingsTableContents objectForKey:[self.sortedKeys objectAtIndex:[indexPath section]]] objectAtIndex:indexPath.row]];

        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        NSString *zohoConnectionStatus=@"";

        if ([[Utils userDefaultsGetObjectForKey:ZOHO_CRM_USERNAME] length]>0)
        {
            zohoConnectionStatus=[Utils userDefaultsGetObjectForKey:ZOHO_CRM_USERNAME];
        }
        
        else
        {
            zohoConnectionStatus=@"Not Connected";
            
        }
        
        NSLog(@"connection status: %@",zohoConnectionStatus);
        
        UILabel *connectionStatusLabel= (UILabel *)[cell viewWithTag:10];
        
        connectionStatusLabel.text = zohoConnectionStatus;

    }

    if (indexPath.row==0 && indexPath.section==1)
    {
        
    NSString *boxConnectionStatus=@"";

    UILabel *boxCurrentUser=(UILabel *)[cell viewWithTag:10];
    
    boxConnectionStatus=@"Not Connected";

    if ([BoxLoginViewController currentUser])
    {
        boxConnectionStatus=[BoxLoginViewController currentUser].userName;
        
    }
        
    boxCurrentUser.text=boxConnectionStatus;
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    }

    if (indexPath.row==1 && indexPath.section==1)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.settingsTableContents objectForKey:[self.sortedKeys objectAtIndex:[indexPath section]]] objectAtIndex:indexPath.row]];

        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }

    if (indexPath.row==0 && indexPath.section==2)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.settingsTableContents objectForKey:[self.sortedKeys objectAtIndex:[indexPath section]]] objectAtIndex:indexPath.row]];
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row==0 && indexPath.section==2)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.settingsTableContents objectForKey:[self.sortedKeys objectAtIndex:[indexPath section]]] objectAtIndex:indexPath.row]];
        
        NSString *zohoConnectionStatus=@"";
        
        if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN] length]>0)
        {
            zohoConnectionStatus=[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_DOMAIN];
        }
        
        else
        {
            zohoConnectionStatus=@"Not Connected";
            
        }
        
        NSLog(@"connection status: %@",zohoConnectionStatus);
        
        UILabel *connectionStatusLabel= (UILabel *)[cell viewWithTag:10];
        
        connectionStatusLabel.text = zohoConnectionStatus;

        
    }
    
    if (indexPath.row==0 && indexPath.section==3)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.settingsTableContents objectForKey:[self.sortedKeys objectAtIndex:[indexPath section]]] objectAtIndex:indexPath.row]];
        
        NSString *zohoConnectionStatus=@"";
        
        
        if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] length]>0)
        {
            zohoConnectionStatus=[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME];
        }
        
        else
        {
            zohoConnectionStatus=@"Not Connected";
            
        }
        
        NSLog(@"connection status: %@",zohoConnectionStatus);
        
        UILabel *connectionStatusLabel= (UILabel *)[cell viewWithTag:10];
        
        connectionStatusLabel.text = zohoConnectionStatus;

        
    }
    
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.settingsTableContents objectForKey:[self.sortedKeys objectAtIndex:[indexPath section]]] objectAtIndex:indexPath.row]];
    }
    //\u2B1C
	return cell;
}

#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0 && indexPath.section==0)
    {
    CRMSelectionViewController *crmSelection=[[CRMSelectionViewController alloc]initWithNibName:@"CRMSelectionViewController" bundle:nil];
    [self.navigationController pushViewController:crmSelection animated:YES];
    }
    
    if (indexPath.row==0 && indexPath.section==1)
    {
        //[self BoxLogin];
    }
    
    if (indexPath.row==0 && indexPath.section==2)
    {
        DomainSelectionViewController *themeSelector=[[DomainSelectionViewController alloc]initWithNibName:@"DomainSelectionViewController" bundle:nil];
        [self.navigationController pushViewController:themeSelector animated:YES];
    }
    
    if (indexPath.row==0 && indexPath.section==3)
    {
        ThemeSelectionViewController *themeSelector=[[ThemeSelectionViewController alloc]initWithNibName:@"ThemeSelectionViewController" bundle:nil];
        [self.navigationController pushViewController:themeSelector animated:YES];
    }
}


- (IBAction)doneButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)BoxLogin
{
    self.view.userInteractionEnabled=YES;
    
    vc = [BoxLoginViewController loginViewControllerWithNavBar:NO];
    vc.title=@"Login to Box";
    
    //[BoxCommonUISetup formatNavigationBarWithBoxIconAndColorScheme:vc.navigationController andNavItem:vc.navigationItem]; //Adds the box styling to the navigation item of the view. This is optional.
    vc.boxLoginDelegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    /*CGRect r = CGRectMake(self.view.bounds.size.width/2 - 250, self.view.bounds.size.height/2 - 325, 650, 500);
     r = [self.view convertRect:r toView:vc.view.superview.superview];
     vc.view.superview.frame = r;*/
    
    //[promptForDropBoxCredentials removeFromSuperview];
    
    
}

- (void)boxLoginViewController:(BoxLoginViewController *)boxLoginViewController didFinishWithResult:(LoginResult)result {
    
    if(result==LoginSuccess)
    {
        //        BoxDownloadActionViewController * inputController = [[BoxDownloadActionViewController alloc] initWithFolderID:@"0"];
        //
        //        [viewTail buildBoxFolderListAfterLogin:inputController];
        
        //[vc dismissModalViewControllerAnimated:YES];
        
        [vc.navigationController popViewControllerAnimated:YES];

    }
    
    
    if (result==LoginCancelled)
    {
        [vc.navigationController popViewControllerAnimated:YES];

        //[vc dismissModalViewControllerAnimated:YES];
    }
    
    
    //  [self.navigationController popViewControllerAnimated:YES]; //Only one of these lines should actually be used depending on how you choose to present it.
}

@end
