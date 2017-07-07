//
//  PageSelectorViewController.h
//  Leaves
//
//  Created by Satheeshwaran on 1/4/13.
//  Copyright (c) 2013 Tom Brow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>
#import "PDFFile.h"

@interface PageSelectorViewController : UITableViewController<MFMailComposeViewControllerDelegate>
{
    MBProgressHUD *HUD;
    UIViewController * generatedPDFController;
    PDFFile *generatedPDFFile;
}

@end
