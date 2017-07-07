//
//  Product.h
//  iPitch V2
//
//  Created by Satheeshwaran on 5/4/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, retain) NSString *PRODUCT_NAME;
@property (nonatomic, retain) NSString *PRODUCT_DESCRIPTION;
@property (nonatomic, retain) NSString *PRODUCT_OWNER;
@property (nonatomic, retain) NSString *PRODUCT_WEBSITE;
@property (nonatomic, retain) NSString *PRODUCT_RELEASE_DATE;
@property (nonatomic, retain) NSString *PRODUCT_CONTACT_EMAIL;
@property (nonatomic, retain) NSString *PRODUCT_CATEGORY;
@property (nonatomic, retain) UIImage *productIcon;
@property (nonatomic, retain) NSMutableArray *productCollaterals;

@end
