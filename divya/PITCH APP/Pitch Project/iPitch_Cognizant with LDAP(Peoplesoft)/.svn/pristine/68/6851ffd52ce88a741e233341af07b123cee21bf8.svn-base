//
//  AccountsViewController.h
//  iPitch V2
//
//  Created by Swarnava(376755) on 27/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

/*
 
 THIS CLASS IS USED FOR SHOWING EXISTING ACCOUNT LISTS
 
 */

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"




@interface AccountsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray * AccountArray;
    UIButton *accountBtn;
    UIPopoverController *SearchPopoverController;
    UITableView *AccountsSearchtable;
    NSMutableArray * SearchAccountDetails;
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIScrollView *AccountScrollView;
@property (weak, nonatomic) IBOutlet UITextField *Accountsearch;
@property (retain, nonatomic) NSMutableArray *filteredArray;
@property (nonatomic, strong) IBOutlet UIButton *buttonToggle;
@property (weak, nonatomic) IBOutlet UIView *toolBarView;
@property(nonatomic, retain) IBOutlet UIButton *NotificationIcon;
@property(nonatomic, retain) IBOutlet UIButton *UserIcon;
@property(nonatomic, retain) IBOutlet UIButton *Searchbtn;
@property (weak, nonatomic) IBOutlet UIImageView *horizontalLine;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


- (IBAction)toggleButtonClicked:(id)sender;
- (IBAction)searchButtonClicked:(id)sender;

@end
