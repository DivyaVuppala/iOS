//
//  CustomerViewController.h
//  iPitch V2
//
//  Created by Krishna Chaitanya on 13/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerViewCell.h"
#import "MBProgressHUD.h"


@interface CustomerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    UIButton *dummyBtn;
    UIPopoverController *SearchPopoverController;
    UITableView *CustomerSearchtable;
    NSMutableArray * customersArray;
    NSMutableArray * SearchcustomerDetails;
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UIScrollView *customerScrollView;
@property (retain, nonatomic) NSMutableArray *filteredArray;
@property (nonatomic, strong) IBOutlet UIButton *buttonToggle;
@property (weak, nonatomic) IBOutlet UIView *toolBarView;
@property(nonatomic, retain) IBOutlet UIButton *NotificationIcon;
@property(nonatomic, retain) IBOutlet UIButton *UserIcon;
@property(nonatomic, retain) IBOutlet UIButton *Searchbtn;
@property (weak, nonatomic) IBOutlet UIImageView *horizontalLine;
@property (weak, nonatomic) IBOutlet UITextField *customersearch;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)toggleButtonClicked:(id)sender;

- (IBAction)searchButtonClicked:(id)sender;
@end
