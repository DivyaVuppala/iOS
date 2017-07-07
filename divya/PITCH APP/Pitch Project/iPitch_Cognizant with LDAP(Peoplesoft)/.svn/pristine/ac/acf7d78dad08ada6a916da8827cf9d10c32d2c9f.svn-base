//
//  PresentationPanelViewController.h
//  iPitch V2
//
//  Created by Krishna Chaitanya on 06/03/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTSPresentationView.h"
#import "Events.h"
#import "PDFPresentationView.h"

@interface PresentationPaneViewController : UIViewController{
    UIButton *dummyBtn;
    BOOL selectedFileTypePDF;
    BOOL PlayDocfromDocuments;
}

@property (retain, nonatomic) IBOutlet CTSPresentationView *presentationView;
@property (retain, nonatomic) IBOutlet UIScrollView *pptDocsScrollView;
@property (retain, nonatomic) Events *pptEvent;
@property (retain, nonatomic) NSMutableArray *pptDocsArray;
@property (nonatomic, retain) IBOutlet UIButton *btnPlayPresentation;
@property (nonatomic, retain) IBOutlet UIButton *btnClose;
@property (nonatomic, retain) IBOutlet UILabel *SelectDocLabel;
@property (retain, nonatomic) IBOutlet PDFPresentationView *PDFPPTView;

- (IBAction)btnPlayAction:(id)sender;
- (IBAction)btnCloseAction:(id)sender;

@end
