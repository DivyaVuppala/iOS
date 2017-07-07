//
//  CustomerViewCell.h
//  iPitch V2
//
//  Created by Krishna Chaitanya on 13/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerViewCell : UIView

@property (strong, nonatomic)  UIImageView *customerIcon;
@property (strong, nonatomic)  UILabel *customerName;
@property (strong, nonatomic)  UILabel *opportunityId;
@property (strong, nonatomic)  UILabel *opportunityIdValue;
@property (strong, nonatomic)  UILabel *TVC;
@property (strong, nonatomic)  UILabel *TVCValue;
@property (strong, nonatomic)  UILabel *txtDesc;
@property (strong, nonatomic)  UILabel    *desc;
@property (strong, nonatomic)  UILabel *customerDesignation;
@property (strong, nonatomic)  UILabel *customerCompany;

@end
