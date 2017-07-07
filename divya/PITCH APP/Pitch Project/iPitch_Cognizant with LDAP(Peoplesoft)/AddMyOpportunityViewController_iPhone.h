//
//  AddMyOpportunityViewController.h
//  iPitch V2
//
//  Created by Divya Vuppala on 10/04/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMyOpportunityViewController_iPhone : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *addProductTableView;
@property (weak, nonatomic) IBOutlet UIView *addProductGroupView;

- (IBAction)addProductButton:(UIButton *)sender;

@end
