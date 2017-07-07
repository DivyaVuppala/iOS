//
//  OpportunitiesViewController.h
//  iPitch V2
//
//  Created by Vineet on 27/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface OpportunitiesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray * OpportunityArray;
    UIButton *opportunityButton;
    UIPopoverController *SearchPopoverController;
    UITableView *OpportunitySearchtable;
    NSMutableArray * SearchOpportunityDetails;
    MBProgressHUD *HUD;
    int index;
  
}
@property (weak, nonatomic) IBOutlet UIScrollView *OpportunityScrollView;
@property (retain, nonatomic) NSMutableArray *filteredArray;
@property (nonatomic, strong) IBOutlet UIButton *buttonToggle;
@property (weak, nonatomic) IBOutlet UIView *toolBarView;
@property(nonatomic, retain) IBOutlet UIButton *NotificationIcon;
@property(nonatomic, retain) IBOutlet UIButton *UserIcon;
@property(nonatomic, retain) IBOutlet UIButton *Searchbtn;
@property (weak, nonatomic) IBOutlet UIImageView *horizontalLine;
@property (weak, nonatomic) IBOutlet UITextField *opportunitySearch;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)searchButtonClicked:(id)sender;
@end

