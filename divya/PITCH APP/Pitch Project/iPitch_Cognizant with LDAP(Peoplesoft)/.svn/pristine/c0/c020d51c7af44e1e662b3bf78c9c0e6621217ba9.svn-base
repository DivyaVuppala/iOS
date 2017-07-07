//
//  AddEditAccountsViewController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 5/10/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Accounts.h"

@protocol AddEditAccountStatusDelegate <NSObject>

@optional

-(void)accountDataSavedSuccessfully;

-(void)accountDataSaveFailedWithError:(NSError *)error;

@end
@interface AddEditAccountsViewController : UIViewController
@property (nonatomic,retain) Accounts *accountObject;
@property (nonatomic,weak) id <AddEditAccountStatusDelegate> delegate;

@end
