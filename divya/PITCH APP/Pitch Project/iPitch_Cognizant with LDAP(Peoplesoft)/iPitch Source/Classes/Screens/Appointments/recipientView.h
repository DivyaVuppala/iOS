//
//  recipientView.h
//  iPitch V2
//
//  Created by Satheeshwaran on 2/20/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface recipientView : UIView

@property (strong, nonatomic) UIImageView *recipientIcon;
@property (strong, nonatomic) UILabel *recipientName;
@property (strong, nonatomic) UILabel *recipientDesignation;
@property (strong, nonatomic) UILabel *recipientCompany;
@property (strong, nonatomic) UILabel *recipientLocation;
@property (strong, nonatomic) UILabel *recipientContactNumber;
@property (strong, nonatomic) UIButton *recipient360Button;

@end
