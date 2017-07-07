//
//  PDFExampleViewController.h
//  Leaves
//
//  Created by Tom Brow on 4/19/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

#import "LeavesViewController.h"
#import "MBProgressHUD.h"

@interface PDFViewController : LeavesViewController<UIAlertViewDelegate> {
	CGPDFDocumentRef pdf;
    
    CGContextRef currentPageContext;
    NSInteger currentPageNumber;
    BOOL currentPageSelected;
    UIViewController * generatedPDFController;
    NSString *pdfFileName;
    MBProgressHUD *HUD;
    
    UIBarButtonItem *showPages;
    UIScrollView *pageThumbnailsScrollView;
    UILabel *titleLabel;
    UIBarButtonItem* pageSelectionButton;
    
}

- (id)initWithPDFFile:(NSString *)fileName;

@property (nonatomic,strong)    UIScrollView *pageThumbnailsScrollView;
@property (nonatomic,strong)  UIPopoverController *selectedPagesPopOver;
@end
