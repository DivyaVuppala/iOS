//
//  CTSPresentationView.h
//  iPitch
//
//  Created by unameit on 14/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTML5Container.h"
#import "CanvasView.h"


typedef enum presentationType {
    PresentationTypeHTML = 0,
    PresentationTypeVideo,
    PresentationTypeImage,
    PresentationTypePDF,
    PresentationTypePPT
} PresentationType;


@interface CTSPresentationView : UIView <HTML5ContainerDelegate,UITableViewDataSource,UITableViewDelegate>{
      
    PresentationType presentationType;
    HTML5Container *hTML5Container;
    UIActivityIndicatorView *indicator;
    
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

@property (nonatomic, retain) HTML5Container *hTML5Container;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;


@property (nonatomic, retain) CanvasView *canvas;
@property(nonatomic,retain) NSString *currentFileName;

@property (nonatomic, strong) UIPopoverController *colorSelectionPopOver;
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
@property (assign, nonatomic) BOOL html5Flag;
@property (nonatomic, retain) UIView *toolBarViewNew;
@property (nonatomic, retain) UIView *toolBarViewNew1;
@property (nonatomic, retain) UIView *childToolsView;
@property (nonatomic, retain) UIButton *deselectButton;
@property (nonatomic, retain) UIButton *screenShotButton;

@property PresentationType presentationType;

- (void)isFullScreenMode:(BOOL)_isFullScreen;
- (void)reload;
- (void)nullLoadWebView;
- (void)resetSelection;

@end
