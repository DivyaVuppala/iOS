//
//  CISPViewController.h
//  iPitch V2
//
//  Created by Vineet on 26/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Folder.h"

@interface InvestmentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *DocumentsScrollView;
@property (nonatomic, retain) NSMutableArray *tableSource;
@property (nonatomic, retain) Folder *currentFolder;
@property (nonatomic, retain) NSString *currentFolderpath;
@property (weak, nonatomic) IBOutlet UIButton *DocumentButton;
@property (weak, nonatomic) IBOutlet UIButton *ProductButton;
@property (nonatomic,  retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)DocumentButtonClicked:(id)sender;
- (IBAction)ProductButtonClicked:(id)sender;
@end
