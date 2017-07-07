//
//  AddOpportunityViewController.h
//  Pitch
//
//  Created by Divya Vuppala on 03/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailAccountViewController_iPhone.h"

@interface AddOpportunityViewController_iPhone : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIView *headerView;
    UIView *footerView;
}

@property (weak, nonatomic) IBOutlet UITableView *productsGroupTableView;
- (IBAction)addProductButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *addProductView;

@end
