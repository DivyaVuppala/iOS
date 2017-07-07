//
//  PDFPreviewViewController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 5/17/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFFile.h"

@interface PDFPreviewViewController : UIViewController
@property (nonatomic,weak) IBOutlet UIWebView *documentWebView;
@property (nonatomic,retain) PDFFile *pdfFile;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *PDFNameLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *emailButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;


- (IBAction)emailButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

@end
