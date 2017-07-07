//
//  EventRecipientsCell.h
//  iPitch V2
//
//  Created by Satheeshwaran on 1/31/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventRecipientsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recipientIcon;
@property (weak, nonatomic) IBOutlet UILabel *recipientName;
@property (weak, nonatomic) IBOutlet UILabel *recipientOrganisationSummary;
@property (weak, nonatomic) IBOutlet UIButton *skypeButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *linkedInButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *CRMButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
