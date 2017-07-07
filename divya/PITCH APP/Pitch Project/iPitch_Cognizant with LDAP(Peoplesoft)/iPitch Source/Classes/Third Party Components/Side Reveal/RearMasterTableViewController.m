//
//  RearMasterTableViewController.m
//  RevealControllerProject3
//
//  Created by Joan on 30/12/12.
//
//

#import "RearMasterTableViewController.h"

#import "SWRevealViewController.h"
#import "ModelTrackingClass.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "CalendarViewController.h"
#import "iPitchConstants.h"
#import "iPitchAnalytics.h"
#import "Utils.h"
#import "ThemeHelper.h"

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@implementation RearMasterTableViewController
{
    NSInteger _previouslySelectedRow;
}
@synthesize sDayViewController, customerView, documentView, OpportunityView,rearTableView,toolBarView,settingsViewController, horizontalLine,personalDashBoardViewController,leadsListViewController;

#pragma mark View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.rearTableView.separatorColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
    self.rearTableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"darkPattern.png" ]];
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
    {
        self.homeButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_icon.png"]];
        self.toolBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Dashboard_bg.png"]];
        self.horizontalLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"horzontal_line.png"]];
    }
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
    {
        self.homeButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_home_icon.png"]];
        self.toolBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_bg.png"]];
        self.horizontalLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_horizontal_line.png"]];
    }
    //self.rearTableView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1.0];
}

- (void)viewDidUnload {
    [self setRearTableView:nil];
    [self setToolBarView:nil];
    [self setHomeButton:nil];
    [super viewDidUnload];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (SAppDelegateObject.revealStatus) {
        //  self.homeButton.hidden=YES;
    }
    
    else
    {
        self.homeButton.hidden=NO;
    }
    [ThemeHelper applyCurrentThemeToView];
    
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft );
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    _previouslySelectedRow = -1;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSString *image = nil;
    switch ( indexPath.row )
    {
        case 0: image = @"calander_sideicon.png"; break;
        case 1: image = @"document_sideicon.png"; break;
        case 2: image = @"customer_sideicon.png"; break;
        case 3: image = @"customer_sideicon.png"; break;
        case 4: image = @"oppr_sideicon"; break;
        case 5: image = @"account_sideicon.png"; break;
        case 6: image = @"suit_case"; break;
        case 7: image = @"setting_sideicon.png"; break;
        case 8: image = @"logout.png"; break;
            
    }
    
    
    NSString *text = nil;
    switch ( indexPath.row )
    {
        case 0: text = NSLocalizedString(@"MY_CALENDAR", @"My Calendar"); cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor lightGrayColor]; cell.textLabel.font=[UIFont fontWithName:FONT_REGULAR size:15];
            break;
        case 1: text = [NSString stringWithFormat:@" %@", NSLocalizedString(@"PRODUCTS", @"Products") ]; cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor lightGrayColor]; cell.textLabel.font=[UIFont fontWithName:FONT_REGULAR size:15];
            break;
        case 2: text = NSLocalizedString(@"MY_LEADS", @"My Leads"); cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor lightGrayColor]; cell.textLabel.font=[UIFont fontWithName:FONT_REGULAR size:15];
            break;
        case 3: text = NSLocalizedString(@"MY_CUSTOMERS", @"My Customers"); cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor lightGrayColor]; cell.textLabel.font=[UIFont fontWithName:FONT_BOLD size:15];
            break;
        case 4: text = NSLocalizedString(@"MY_OPPORTUNITIES", @"My Opportunities"); cell.selectionStyle=UITableViewCellSelectionStyleGray; cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0]; cell.textLabel.font=[UIFont fontWithName:FONT_BOLD size:18];
            break;
        case 5: text = NSLocalizedString(@"MY_ACCOUNTS", @"My Accounts"); cell.selectionStyle=UITableViewCellSelectionStyleGray;
            cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0]; cell.textLabel.font=[UIFont fontWithName:FONT_BOLD size:18];
            break;
        case 6: text = NSLocalizedString(@"PERSONAL", @"Personal"); cell.selectionStyle=UITableViewCellSelectionStyleNone; cell.textLabel.textColor = [UIColor lightGrayColor]; cell.textLabel.font=[UIFont fontWithName:FONT_REGULAR size:15];
            break;
        case 7: text = NSLocalizedString(@"SETTINGS", @"Settings"); cell.selectionStyle=UITableViewCellSelectionStyleNone; cell.textLabel.textColor = [UIColor lightGrayColor]; cell.textLabel.font=[UIFont fontWithName:FONT_REGULAR size:15];
            break;
        case 8: text = NSLocalizedString(@"LOGOUT", @"Logout"); cell.selectionStyle=UITableViewCellSelectionStyleGray; cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0]; cell.textLabel.font=[UIFont fontWithName:FONT_BOLD size:18];
            break;
            
            
    }
    
    cell.imageView.image = [UIImage imageNamed:image];
    cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
    cell.textLabel.text = text;
    
    
  
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
    {
        self.homeButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_icon.png"]];
        self.toolBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Dashboard_bg.png"]];
        self.horizontalLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"horzontal_line.png"]];
    }
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
    {
        self.homeButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_home_icon.png"]];
        self.toolBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_bg.png"]];
        self.horizontalLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_horizontal_line.png"]];
    }
    
    SWRevealViewController *revealController = self.revealViewController;
    
    NSInteger row = indexPath.row;
    
    
    _previouslySelectedRow = row;
    
    UIViewController *frontController = nil;
    switch ( row )
    {
            
            
            
        case 0:
        {
            /*
             
             if(SAppDelegateObject.revealStatus)
             {
             calendarViewController=[[CalendarViewController alloc]initWithNibName:@"CalendarViewController" bundle:nil];
             
             RearMasterTableViewController *rearViewController = [[RearMasterTableViewController alloc] init];
             
             SWRevealViewController *mainRevealController =
             [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:calendarViewController];
             
             mainRevealController.rearViewRevealWidth = 200;
             mainRevealController.rearViewRevealOverdraw = 150;
             mainRevealController.bounceBackOnOverdraw = NO;
             mainRevealController.stableDragOnOverdraw = YES;
             [mainRevealController setFrontViewPosition:FrontViewPositionLeft];
             
             // mainRevealController.delegate = self;
             
             SAppDelegateObject.revealStatus=NO;
             [SAppDelegateObject.viewController.dashBoard.revealViewController revealToggleAnimated:YES];
             [SAppDelegateObject.viewController.dashBoard.navigationController pushViewController:mainRevealController animated:YES];
             }
             
             else
             {
             [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
             
             [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Side Reveal Screen" withAction:@"Calendar Button Clicked" withLabel:nil withValue:nil];
             calendarViewController=[[CalendarViewController alloc]initWithNibName:@"CalendarViewController" bundle:nil];
             UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:calendarViewController];
             navController.navigationBarHidden=YES;
             frontController = navController;
             
             [revealController setFrontViewController:frontController animated:NO];
             [revealController setFrontViewPosition:FrontViewPositionRight animated:YES];
             [revealController revealToggleAnimated:YES];
             }
             
             */
            break;
            
        }
        case 1:
        {
            /*
             
             if(SAppDelegateObject.revealStatus)
             {
             documentView=[[DocumentTableView alloc]initWithNibName:@"DocumentTableView" bundle:nil];
             // UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:documentView];
             //  navController.navigationBarHidden=YES;
             
             RearMasterTableViewController *rearViewController = [[RearMasterTableViewController alloc] init];
             
             SWRevealViewController *mainRevealController =
             [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:documentView];
             
             mainRevealController.rearViewRevealWidth = 200;
             mainRevealController.rearViewRevealOverdraw = 150;
             mainRevealController.bounceBackOnOverdraw = NO;
             mainRevealController.stableDragOnOverdraw = YES;
             [mainRevealController setFrontViewPosition:FrontViewPositionLeft];
             
             // mainRevealController.delegate = self;
             
             SAppDelegateObject.revealStatus=NO;
             [SAppDelegateObject.viewController.dashBoard.revealViewController revealToggleAnimated:YES];
             [SAppDelegateObject.viewController.dashBoard.navigationController pushViewController:mainRevealController animated:YES];
             }
             
             else
             {
             [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
             
             [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Side Reveal Screen" withAction:@"Documents Button Clicked" withLabel:nil withValue:nil];
             documentView=[[DocumentTableView alloc]initWithNibName:@"DocumentTableView" bundle:nil];
             UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:documentView];
             navController.navigationBarHidden=YES;
             frontController = navController;
             
             [revealController setFrontViewController:frontController animated:NO];
             [revealController setFrontViewPosition:FrontViewPositionRight animated:YES];
             [revealController revealToggleAnimated:YES];
             }
             
             */
            break;
        }
        case 2:
        {
            /*
             
             if(SAppDelegateObject.revealStatus)
             {
             leadsListViewController=[[LeadsViewController alloc]initWithNibName:@"LeadsViewController" bundle:nil];
             RearMasterTableViewController *rearViewController = [[RearMasterTableViewController alloc] init];
             
             SWRevealViewController *mainRevealController =
             [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:leadsListViewController];
             
             mainRevealController.rearViewRevealWidth = 200;
             mainRevealController.rearViewRevealOverdraw = 150;
             mainRevealController.bounceBackOnOverdraw = NO;
             mainRevealController.stableDragOnOverdraw = YES;
             [mainRevealController setFrontViewPosition:FrontViewPositionLeft];
             
             // mainRevealController.delegate = self;
             
             SAppDelegateObject.revealStatus=NO;
             [SAppDelegateObject.viewController.dashBoard.revealViewController revealToggleAnimated:YES];
             [SAppDelegateObject.viewController.dashBoard.navigationController pushViewController:mainRevealController animated:YES];
             }
             
             else
             {
             
             [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
             [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Side Reveal Screen" withAction:@"Customer Button Clicked" withLabel:nil withValue:nil];
             leadsListViewController=[[LeadsViewController alloc]initWithNibName:@"LeadsViewController" bundle:nil];
             UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:leadsListViewController];
             navController.navigationBarHidden=YES;
             frontController = navController;
             
             [revealController setFrontViewController:frontController animated:NO];
             [revealController setFrontViewPosition:FrontViewPositionRight animated:YES];
             [revealController revealToggleAnimated:YES];
             }
             
             */
            break;
        }
            
        case 3:
        {
            
            /*
             if(SAppDelegateObject.revealStatus)
             {
             customerView=[[CustomerViewController alloc]initWithNibName:@"CustomerViewController" bundle:nil];
             RearMasterTableViewController *rearViewController = [[RearMasterTableViewController alloc] init];
             
             SWRevealViewController *mainRevealController =
             [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:customerView];
             
             mainRevealController.rearViewRevealWidth = 200;
             mainRevealController.rearViewRevealOverdraw = 150;
             mainRevealController.bounceBackOnOverdraw = NO;
             mainRevealController.stableDragOnOverdraw = YES;
             [mainRevealController setFrontViewPosition:FrontViewPositionLeft];
             
             // mainRevealController.delegate = self;
             
             SAppDelegateObject.revealStatus=NO;
             [SAppDelegateObject.viewController.dashBoard.revealViewController revealToggleAnimated:YES];
             [SAppDelegateObject.viewController.dashBoard.navigationController pushViewController:mainRevealController animated:YES];
             }
             
             else
             {
             
             [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
             [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Side Reveal Screen" withAction:@"Customer Button Clicked" withLabel:nil withValue:nil];
             customerView=[[CustomerViewController alloc]initWithNibName:@"CustomerViewController" bundle:nil];
             UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:customerView];
             navController.navigationBarHidden=YES;
             frontController = navController;
             
             [revealController setFrontViewController:frontController animated:NO];
             [revealController setFrontViewPosition:FrontViewPositionRight animated:YES];
             [revealController revealToggleAnimated:YES];
             }
             */
            break;
        }
        case 4:
        {
            
            if(SAppDelegateObject.revealStatus)
            {
                OpportunityView=[[OpportunitiesViewController alloc]initWithNibName:@"OpportunitiesViewController" bundle:nil];
                
                RearMasterTableViewController *rearViewController = [[RearMasterTableViewController alloc] init];
                
                SWRevealViewController *mainRevealController =
                [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:OpportunityView];
                
                mainRevealController.rearViewRevealWidth = 200;
                mainRevealController.rearViewRevealOverdraw = 150;
                mainRevealController.bounceBackOnOverdraw = NO;
                mainRevealController.stableDragOnOverdraw = YES;
                [mainRevealController setFrontViewPosition:FrontViewPositionLeft];
                
                // mainRevealController.delegate = self;
                
                SAppDelegateObject.revealStatus=NO;
                [SAppDelegateObject.viewController.dashBoard.revealViewController revealToggleAnimated:YES];
                [SAppDelegateObject.viewController.dashBoard.navigationController pushViewController:mainRevealController animated:YES];
            }
            
            else
            {
                
                [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
                
                
                [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Side Reveal Screen" withAction:@"Opportunity Button Clicked" withLabel:nil withValue:nil];
                OpportunityView=[[OpportunitiesViewController alloc]initWithNibName:@"OpportunitiesViewController" bundle:nil];
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:OpportunityView];
                navController.navigationBarHidden=YES;
                frontController = navController;
                
                [revealController setFrontViewController:frontController animated:NO];
                [revealController setFrontViewPosition:FrontViewPositionRight animated:YES];
                [revealController revealToggleAnimated:YES];
            }
            break;
        }
            
        case 5:
        {
            
            if(SAppDelegateObject.revealStatus)
            {
                accountsView=[[AccountsViewController alloc]initWithNibName:@"AccountsViewController" bundle:nil];
                RearMasterTableViewController *rearViewController = [[RearMasterTableViewController alloc] init];
                
                SWRevealViewController *mainRevealController =
                [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:accountsView];
                
                mainRevealController.rearViewRevealWidth = 200;
                mainRevealController.rearViewRevealOverdraw = 150;
                mainRevealController.bounceBackOnOverdraw = NO;
                mainRevealController.stableDragOnOverdraw = YES;
                [mainRevealController setFrontViewPosition:FrontViewPositionLeft];
                
                // mainRevealController.delegate = self;
                
                SAppDelegateObject.revealStatus=NO;
                [SAppDelegateObject.viewController.dashBoard.revealViewController revealToggleAnimated:YES];
                [SAppDelegateObject.viewController.dashBoard.navigationController pushViewController:mainRevealController animated:YES];
            }
            
            else
            {
                
                [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
                
                
                [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Side Reveal Screen" withAction:@"Account Button Clicked" withLabel:nil withValue:nil];
                accountsView=[[AccountsViewController alloc]initWithNibName:@"AccountsViewController" bundle:nil];
                UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:accountsView];
                navController.navigationBarHidden=YES;
                frontController = navController;
                
                [revealController setFrontViewController:frontController animated:NO];
                [revealController setFrontViewPosition:FrontViewPositionRight animated:YES];
                [revealController revealToggleAnimated:YES];
            }
            break;
            
        }
            
        case 6:
            
        {
            /*
             if(SAppDelegateObject.revealStatus)
             {
             personalDashBoardViewController=[[PersnoalDashboardViewController alloc]initWithNibName:@"PersnoalDashboardViewController" bundle:nil];
             
             RearMasterTableViewController *rearViewController = [[RearMasterTableViewController alloc] init];
             
             SWRevealViewController *mainRevealController =
             [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:personalDashBoardViewController];
             
             mainRevealController.rearViewRevealWidth = 200;
             mainRevealController.rearViewRevealOverdraw = 150;
             mainRevealController.bounceBackOnOverdraw = NO;
             mainRevealController.stableDragOnOverdraw = YES;
             [mainRevealController setFrontViewPosition:FrontViewPositionLeft];
             
             // mainRevealController.delegate = self;
             
             SAppDelegateObject.revealStatus=NO;
             [SAppDelegateObject.viewController.dashBoard.revealViewController revealToggleAnimated:YES];
             [SAppDelegateObject.viewController.dashBoard.navigationController pushViewController:mainRevealController animated:YES];
             }
             
             else
             {
             
             [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
             
             
             [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Side Reveal Screen" withAction:@"Personal Dashboard Clicked" withLabel:nil withValue:nil];
             personalDashBoardViewController=[[PersnoalDashboardViewController alloc]initWithNibName:@"PersnoalDashboardViewController" bundle:nil];
             UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:personalDashBoardViewController];
             navController.navigationBarHidden=YES;
             frontController = navController;
             
             [revealController setFrontViewController:frontController animated:NO];
             [revealController setFrontViewPosition:FrontViewPositionRight animated:YES];
             [revealController revealToggleAnimated:YES];
             }
             */
            break;
        }
        case 7:
        {
            /*
             [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
             
             [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Side Reveal Screen" withAction:@"Setting Button Clicked" withLabel:nil withValue:nil];
             settingsViewController=[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
             
             UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:settingsViewController];
             navController.modalPresentationStyle=UIModalPresentationFormSheet;
             navController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
             [SAppDelegateObject.window.rootViewController presentModalViewController:navController animated:YES];
             [revealController revealToggleAnimated:YES];
             */
            break;
            
        }
            
        case 8:
        {
            [revealController revealToggleAnimated:YES];
            [Utils clearAllTempFiles];
            [SAppDelegateObject.opportArray removeAllObjects];
            [SAppDelegateObject.acntArray   removeAllObjects];
            [[ModelTrackingClass sharedInstance]setUserID:@""];
            [[ModelTrackingClass sharedInstance]setUserName:@""];
            [SAppDelegateObject.viewController.dashBoard.navigationController popToRootViewControllerAnimated:YES];
        }
            
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    return;
}


#pragma mark Custom UI Methods

- (IBAction)homeButtonPressed:(id)sender
{
    if(SAppDelegateObject.revealStatus)
    {
        [SAppDelegateObject.viewController.dashBoard.revealViewController revealToggleAnimated:YES];
    }
    
    else
    {
        [SAppDelegateObject.viewController.dashBoard.navigationController popViewControllerAnimated:YES];
    }
    
    
}
@end