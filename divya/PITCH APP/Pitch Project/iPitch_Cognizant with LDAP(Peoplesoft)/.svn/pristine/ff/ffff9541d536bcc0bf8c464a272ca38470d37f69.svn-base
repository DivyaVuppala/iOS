//
//  HomeViewController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 1/24/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MetroTile.h"
#import "SDayViewController.h"
#import "MBProgressHUD.h"


#import "RearMasterTableViewController.h"
#import "SWRevealViewController.h"

#import "BoxUser.h"
#import "BoxCommonUISetup.h"
#import "BoxLoginViewController.h"

#import "MBProgressHUD.h"

#import "BoxLoginViewController.h"

@class MAEventKitDataSource;

@interface HomeViewController : UIViewController<SWRevealViewControllerDelegate,BoxLoginViewControllerDelegate>

{   
    NSMutableArray *parsedItems;
    NSMutableArray *itemsToDisplay;
    MetroTile *metroTile;
    SDayViewController *sdayView;

    BoxLoginViewController * vc;
    MBProgressHUD *HUD;

}
@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UIView *liveNewsView;
@property (weak, nonatomic) IBOutlet UIView *documentsView;
@property (weak, nonatomic) IBOutlet UIButton *customersButton;
@property (strong, nonatomic)SDayViewController *sdayView;
@property (strong, nonatomic) UINavigationController *navControl;
@property (weak, nonatomic) IBOutlet UIButton *documentsButton;
- (IBAction)documentsClicked:(id)sender;
- (IBAction)calendarClicked:(id)sender;
- (IBAction)customersClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *oppurtunitiesView;
@property (weak, nonatomic) IBOutlet UIButton *oppurtunitiesButton;
- (IBAction)oppurtunitiesPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *customersView;

@end
