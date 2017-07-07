//
//  ReviewClientViewController.h
//  iPitch V2
//
//  Created by Vineet on 26/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewClientViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) IBOutlet UILabel *customerName;
@property (nonatomic,retain) IBOutlet UILabel *customerDesignation;
@property (nonatomic,retain) IBOutlet UILabel *customerOrganization;
@property (nonatomic,retain) UITableViewCell *labelCell;
@end
