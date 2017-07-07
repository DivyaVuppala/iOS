//
//  AccountsViewController.h
//  HiPitchProject
//
//  Created by priteesh on 03/04/2015.
//  Copyright (c) 2015 priteesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailAccountViewCell.h"
#import "AccountOpportunityViewController_iPhone.h"
#import "AddOpportunityViewController_iPhone.h"
#import "SalesForceHelper.h"
#import "AppDelegate.h"
#import "iPitchConstants.h"


@interface DetailAccountViewController_iPhone : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * arry;
}
@property (weak, nonatomic) IBOutlet UITableView *mytableview;

@property (strong, nonatomic) NSString *receivedAccountName;
@property (strong, nonatomic) NSString *receivedAccountID;


@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountIDLabel;
@end

