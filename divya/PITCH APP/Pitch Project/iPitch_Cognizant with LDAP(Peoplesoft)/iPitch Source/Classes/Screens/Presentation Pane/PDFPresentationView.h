//
//  PDFPresentationView.h
//  iPitch V2
//
//  Created by Krishna Chaitanya on 11/03/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeavesViewController.h"
#import "CanvasView.h"

@interface PDFPresentationView : LeavesViewController<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    CGPDFDocumentRef pdf;
    CGContextRef currentPageContext;
    NSInteger currentPageNumber;
    BOOL currentPageSelected;
    NSString *pdfFileName;
    UILabel *titleLabel;
    
    BOOL laserSelected;
    BOOL toolBarVisible;
    BOOL toolBarNewVisible;
    BOOL pencilSelected;
    BOOL highlightSelected;
    BOOL menuOpen;
    BOOL childToolOpen;
    BOOL userStoppedEditing;
    UIViewController *popOverContent;
}

@property (nonatomic, retain) CanvasView *canvas;

@property (nonatomic, retain) UIPopoverController *colorSelectionPopOver;
@property (nonatomic, retain) UITableView *colorSelectionTable;
@property (nonatomic, retain) NSMutableArray *colorsArray;
@property (nonatomic, retain) UIButton *laserButton;
@property (nonatomic, retain) UIButton *clearButton;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) UIButton *pencilButton;
@property (nonatomic, retain) UIButton *highlightButton;
@property (nonatomic, retain) UIButton *undoButton;
@property (nonatomic, retain) UIButton *colorPaletteButton;
@property (nonatomic, retain) UIView *toolBarView;
@property (nonatomic, retain) UIButton *pullDownButton;
@property (nonatomic, retain) UIImageView *toolBarViewBg;
@property (nonatomic, retain) UIImageView *childToolsViewBg;
@property (nonatomic, retain) UIView *toolBarViewNew;
@property (nonatomic, retain) UIView *childToolsView;
@property (nonatomic, retain) UIButton *deselectButton;
@property (nonatomic, retain) UIButton *screenShotButton;

- (void)resetSelection;

- (void)isFullScreenMode:(BOOL)_isFullScreen;

- (id)initWithPDFFileinPPT:(NSString *)fileName andPath:(NSString *)path;

@end
