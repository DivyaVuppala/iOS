//
//  CTSPresentationView.m
//  iPitch
//
//  Created by unameit on 14/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CTSPresentationView.h"
#import "ModelTrackingClass.h"
#import "QuartzCore/CALayer.h"
#import "PDFPreviewViewController.h"
#import "PDFFile.h"
#import "AppDelegate.h"
#import "iPitchConstants.h"
#import "iPitchAnalytics.h"
#import "Utils.h"

@interface CTSPresentationView ()
{
    PDFFile *generatedPDFFile;
}
@end
@implementation CTSPresentationView

@synthesize hTML5Container;
@synthesize presentationType;
@synthesize indicator;
@synthesize canvas;
@synthesize colorsArray;
@synthesize colorPaletteButton;
@synthesize colorSelectionTable;
@synthesize colorSelectionPopOver;
@synthesize clearButton;
@synthesize closeButton;
@synthesize pencilButton;
@synthesize highlightButton;
@synthesize laserButton;
@synthesize pullDownButton;
@synthesize toolBarView;
@synthesize toolBarViewNew;
@synthesize toolBarViewNew1;
@synthesize childToolsView;
@synthesize childToolsViewBg;
@synthesize toolBarViewBg;
@synthesize undoButton;
@synthesize html5Flag;
@synthesize deselectButton;
@synthesize currentFileName;
@synthesize screenShotButton;

#define PENCIL_OPACITY  1.0
#define PENCIL_THICKNESS 2.0
#define HIGHLIGHT_OPACITY 0.5
#define HIGHLIGHT_THICKNESS 15.0
#define COLORS_COUNT 5
#define LASER_CHILD_VIEW_HEIGHT 50
#define OTHER_CHILD_VIEW_HEIGHT 200

#define REDCOLOR @"Red Color"
#define BLACKCOLOR @"Black Color"
#define YELLOWCOLOR @"Yellow Color"
#define GRAYCOLOR @"Gray Color"
#define BLUECOLOR @"Blue Color"


- (void)configureViews
{
    popOverContent=[[UIViewController alloc]init];
    self.userInteractionEnabled = NO;
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.center = self.center;
    [self addSubview:self.indicator];
    
    self.hTML5Container = [[HTML5Container alloc]initWithFrame:self.bounds];
    self.hTML5Container.delegate = self;
    [self addSubview:self.hTML5Container];
    
    colorSelectionTable =[[UITableView alloc]init];
    colorSelectionTable.dataSource=self;
    colorSelectionTable.delegate=self;
    
    CanvasView *newCanvas = [[CanvasView alloc] initWithFrame:CGRectMake(0.0, 0, 1024, 748)];
  
    self.canvas = newCanvas;
    
    self.backgroundColor = [UIColor blackColor];
    self.canvas.currentLine.lineWidth = 2.0;
    self.canvas.currentLine.opacity = 1.0;
    self.canvas.currentLine.lineColor=[UIColor blueColor];
    self.canvas.laserSelected=YES;
    
    colorsArray =[[NSMutableArray alloc]initWithObjects:@"black.png",@"blue.png",@"grey.png",@"Red.png",@"yellow.png", nil];
    
    childToolsView=[[UIView alloc]initWithFrame:CGRectMake(-60,(self.frame.size.height-LASER_CHILD_VIEW_HEIGHT)/2, 50, 50)];
    [childToolsView setBackgroundColor:[UIColor clearColor]];
    [childToolsView setOpaque:NO];
    [self addSubview:self.childToolsView];
    
    childToolsViewBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0 , 0)];
    [childToolsViewBg setImage:[UIImage imageNamed:@"side_bar_1.png"]];
    [childToolsViewBg setOpaque:NO];
    [childToolsView addSubview:childToolsViewBg];
    
    deselectButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [deselectButton setFrame:CGRectMake(10, 10, 30, 30)];
    [deselectButton setImage:[UIImage imageNamed:@"close_btn1"] forState:UIControlStateNormal];
    [deselectButton addTarget:self action:@selector(deselectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [childToolsView addSubview:deselectButton];


    toolBarViewNew=[[UIView alloc]initWithFrame:CGRectMake(994, 85, 84, 608)];
    [toolBarViewNew setBackgroundColor:[UIColor clearColor]];
    [toolBarViewNew setOpaque:NO];
    toolBarViewNew.layer.zPosition = 1;
    [toolBarViewNew setHidden:YES];
    [self addSubview:self.toolBarViewNew];
    
    toolBarViewBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 84 , 608)];
    [toolBarViewBg setImage:[UIImage imageNamed:@"side_bar_2.png"]];
    [toolBarViewBg setOpaque:NO];
    [toolBarViewNew addSubview:toolBarViewBg];
    
    pullDownButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [pullDownButton setFrame:CGRectMake(10, 250, 20, 120)];
    [pullDownButton setImage:[UIImage imageNamed:@"down_arrow_New.png"] forState:UIControlStateNormal];
    [pullDownButton addTarget:self action:@selector(pullDownButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarViewNew addSubview:pullDownButton];
    
    laserButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [laserButton setFrame:CGRectMake(50, 80, 30, 30)];
    [laserButton setImage:[UIImage imageNamed:@"hand.png"] forState:UIControlStateNormal];
    [laserButton addTarget:self action:@selector(laserButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarViewNew addSubview:laserButton];
    

    pencilButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [pencilButton setFrame:CGRectMake(50, 160, 30, 30)];
    [pencilButton setImage:[UIImage imageNamed:@"pen.png"] forState:UIControlStateNormal];
    [pencilButton addTarget:self action:@selector(pencilButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarViewNew addSubview:pencilButton];
    
    highlightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [highlightButton setFrame:CGRectMake(50, 420, 30, 30)];
    [highlightButton setImage:[UIImage imageNamed:@"highlighetr.png"] forState:UIControlStateNormal];
    [highlightButton addTarget:self action:@selector(highlightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarViewNew addSubview:highlightButton];
    
    colorPaletteButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [colorPaletteButton setFrame:CGRectMake(10, 5, 30, 30)];
    [colorPaletteButton setImage:[UIImage imageNamed:@"color_wheel.png"] forState:UIControlStateNormal];
    [colorPaletteButton addTarget:self action:@selector(colorPalettePressed:) forControlEvents:UIControlEventTouchUpInside];
    [childToolsView addSubview:colorPaletteButton];  
    
    undoButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [undoButton setFrame:CGRectMake(10, 50, 30, 30)];
    [undoButton setImage:[UIImage imageNamed:@"undo.png"] forState:UIControlStateNormal];
    [undoButton addTarget:self action:@selector(undoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [childToolsView addSubview:undoButton];

    
    clearButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setFrame:CGRectMake(10, 100, 30, 30)];
    [clearButton setImage:[UIImage imageNamed:@"eraser.png"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [childToolsView addSubview:clearButton];
    
    screenShotButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [screenShotButton setFrame:CGRectMake(50, 500, 30, 30)];
    [screenShotButton setImage:[UIImage imageNamed:@"screen_shot.png"] forState:UIControlStateNormal];
    [screenShotButton addTarget:self action:@selector(takeScreenShotSelected:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarViewNew addSubview:screenShotButton];
    
    //takeScreenShotSelected
    
    laserSelected=NO;
    toolBarVisible=NO;
    toolBarNewVisible=NO;
    pencilSelected=NO;
    childToolOpen = NO;
    highlightSelected = NO;
    userStoppedEditing=YES;

}

- (void)animationEnded{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.4];
//    [UIView setAnimationDelegate:nil];
//    self.hTML5Container.html5View.frame = CGRectMake(0, 0, 1024, 768);
//    [UIView commitAnimations];
}

- (void)isFullScreenMode:(BOOL)_isFullScreen{    
    self.currentFileName=[[ModelTrackingClass sharedInstance] getModelObjectForKey:@"CURRENT_FILE_NAME"];
        
    [self resetSelection];
    [self.canvas removeFromSuperview];
    [self.canvas removeLaserObjects];
    [self.canvas.lines removeAllObjects];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationEnded)];

    if (_isFullScreen) {
        self.frame = CGRectMake(0, 0, 1024, 748);
        self.hTML5Container.frame = CGRectMake(0, 0, 1024, 748);
        self.hTML5Container.html5View.frame = CGRectMake(0,0, 1024, 748);
        [toolBarViewNew setHidden:NO];
        
        toolBarViewNew.frame=CGRectMake(994, 85, 84, 608);
        pullDownButton.frame=CGRectMake(10, 250, 20, 100);
        [pullDownButton setImage:[UIImage imageNamed:@"down_arrow_New.png"] forState:UIControlStateNormal];
       [self.childToolsView setFrame:CGRectMake(-60, (self.frame.size.height-LASER_CHILD_VIEW_HEIGHT)/2, 50, 50)];
        toolBarVisible = NO;
        childToolOpen = NO;
    }
    
    else {
         self.frame = CGRectMake(8, 10, 1009, 521);
         self.hTML5Container.frame =  CGRectMake(0, 0, 1009, 521);
         self.hTML5Container.html5View.frame = CGRectMake(0, 0, 1009                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               , 521);
        [toolBarViewNew setHidden:YES];
        [self.childToolsView setFrame:CGRectMake(-60, (self.frame.size.height-LASER_CHILD_VIEW_HEIGHT)/2, 50, 50)];
        childToolOpen = NO;        
    }
    
    [UIView commitAnimations];
}

- (void)reload{
    [self.hTML5Container reset];
}

- (void)nullLoadWebView{
    [self.hTML5Container.html5View loadHTMLString:@"" baseURL:nil];  
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       [self configureViews];    
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder]) {
       [self configureViews];
    }
	return self;
}

- (void)hTML5ContainerWillStartLoading:(HTML5Container *)hTML5Container{
    [self.indicator startAnimating];
}
- (void)hTML5ContainerDidStopLoading:(HTML5Container *)hTML5Container{
    [self.indicator stopAnimating];
}


#pragma mark Custom Annotation Methods

-(IBAction)undoButtonPressed:(UIButton *)sender{
    if ([self.canvas.lines count] > 0) {
        
        //NSLog(@"last line: %i", [self.canvas.lines count]);
        
        [self.canvas.lines removeLastObject];
        [self.canvas setNeedsDisplay];
    }
}


-(IBAction)colorPalettePressed:(id)sender
{
  if (!self.canvas.laserSelected)
    {
        popOverContent.view=colorSelectionTable;
        [popOverContent setContentSizeForViewInPopover:CGSizeMake(210, 50)];
        UIPopoverController *tempPopOver = [[UIPopoverController alloc]initWithContentViewController:popOverContent];
        self.colorSelectionPopOver = tempPopOver;
        
        [colorSelectionPopOver presentPopoverFromRect:colorPaletteButton.frame inView:childToolsView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
        else
        {
            for (UIView *subview in cell.contentView.subviews)
                [subview removeFromSuperview];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        for(int i=0;i<COLORS_COUNT;i++)
        {
            UIButton *colorButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [colorButton setFrame:CGRectMake((i*40)+10, 10, 30, 30)];
            [colorButton setTag:i];
            [colorButton setImage:[UIImage imageNamed:[colorsArray objectAtIndex:i]] forState:UIControlStateNormal];
            [colorButton.layer setCornerRadius:9];
            [colorButton addTarget:self action:@selector(colorSelected:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:colorButton];
        }
    return cell;    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *tView=[[UIView alloc]init] ;
    return tView;
}

#define radians(degrees) (degrees * M_PI/180)

- (void)screenshot
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, imageSize.height, imageSize.width), nil);

    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [[self.hTML5Container.html5View layer]renderInContext:pdfContext];
    [[self.canvas layer]renderInContext:pdfContext];
    
    CGContextTranslateCTM( pdfContext, 0.5f * imageSize.height, 0.5f * imageSize.width ) ;
    CGContextRotateCTM( pdfContext, radians( 90 ) ) ;
    
    UIGraphicsEndPDFContext();
    
}

- (void)takeScreenShotSelected:(UIButton *)sender
{
    [Utils showLoading:self.hTML5Container.html5View];
    
    [self hideToolBar];
    
    generatedPDFFile=[[PDFFile alloc]init];
    
    generatedPDFFile.fileName=[NSString stringWithFormat:@"Pitch_screen_shot_%@.pdf",[NSDate date]];
    
    generatedPDFFile.filePath=[NSTemporaryDirectory() stringByAppendingPathComponent:generatedPDFFile.fileName];
    
    [self setupPDFDocumentNamed:generatedPDFFile.filePath];
    
    [self screenshot];
    
    [Utils removeLoading:self.hTML5Container.html5View];

    PDFPreviewViewController *pdfPreview=[[PDFPreviewViewController alloc]initWithNibName:@"PDFPreviewViewController" bundle:nil];
    pdfPreview.pdfFile=generatedPDFFile;
    pdfPreview.modalPresentationStyle=UIModalPresentationFormSheet;
    [SAppDelegateObject.window.rootViewController presentModalViewController:pdfPreview animated:YES];
    
}

- (void)setupPDFDocumentNamed:(NSString*)path
{
    UIGraphicsBeginPDFContextToFile(path, CGRectZero, nil);
}

-(void)colorSelected:(UIButton*)sender
{
    
    switch (sender.tag) {
        case 0:
        {
            self.canvas.currentLine.lineColor=[UIColor blackColor];
            break;
        }
        case 1:
        {
            self.canvas.currentLine.lineColor=[UIColor blueColor];
            break;
        }
        case 2:
        {
            self.canvas.currentLine.lineColor=[UIColor grayColor];
            break;
        }
        case 3:
        {
            self.canvas.currentLine.lineColor=[UIColor redColor];
            break;
        }
        case 4:
        {
            self.canvas.currentLine.lineColor=[UIColor yellowColor];
            break;
            
        }
        default:
        {
            self.canvas.currentLine.lineColor=[UIColor blueColor];
            break;
        }
    }
    
    if (colorSelectionPopOver.isPopoverVisible) {
        [colorSelectionPopOver dismissPopoverAnimated:YES];
        
    }

    
}

-(IBAction)laserButtonPressed:(id)sender
{
    
    [self resetSelection];
    userStoppedEditing=NO;
    laserSelected = YES;
    self.canvas.laserSelected=YES;
    [laserButton setBackgroundImage:[UIImage imageNamed:@"selection.png"] forState:UIControlStateNormal];
    if(self.canvas.laserSelected)
    {
        [self.canvas removeLaserObjects];
    }
    else
    {
    }
    
    
    [self showChildTools];
    
}

-(IBAction)clearButtonPressed:(id)sender
{
    [self.canvas.lines removeAllObjects];
    [self.canvas setNeedsDisplay];
    
}

-(IBAction)pullDownButtonPressed:(id)sender
{
    [self.canvas removeLaserObjects];
    toolBarVisible=!toolBarVisible;
    
    if(!toolBarVisible)
        [self hideToolBar];
    else
        [self showToolBar];
    
    [self bringSubviewToFront:pullDownButton];
}


-(IBAction)pencilButtonPressed:(id)sender
{
    userStoppedEditing=NO;
    [self resetSelection];
    self.canvas.laserSelected=NO;
    [self.canvas removeLaserObjects];
    [pencilButton setBackgroundImage:[UIImage imageNamed:@"selection.png"] forState:UIControlStateNormal];
    pencilSelected=YES;
    highlightSelected=NO;
    self.canvas.currentLine.lineWidth = PENCIL_THICKNESS;
    self.canvas.currentLine.opacity =PENCIL_OPACITY;
    self.canvas.currentLine.lineColor=[UIColor blueColor];
    [self showChildTools];
}

-(IBAction)highlightButtonPressed:(id)sender
{
    userStoppedEditing=NO;
    [self resetSelection];
    self.canvas.laserSelected=NO;
    [self.canvas removeLaserObjects];
    [highlightButton setBackgroundImage:[UIImage imageNamed:@"selection.png"] forState:UIControlStateNormal];
    highlightSelected=YES;
    pencilSelected=NO;
    self.canvas.currentLine.lineWidth = HIGHLIGHT_THICKNESS;
    self.canvas.currentLine.opacity = HIGHLIGHT_OPACITY;
    self.canvas.currentLine.lineColor=[UIColor yellowColor];

    [self showChildTools];
}

-(void)resetSelection
{
    [pencilButton setBackgroundImage:nil forState:UIControlStateNormal];
    [highlightButton setBackgroundImage:nil forState:UIControlStateNormal];
    [laserButton setBackgroundImage:nil forState:UIControlStateNormal];
    laserSelected = NO;
    pencilSelected = NO;
    highlightSelected = NO;
}

-(IBAction)deselectButtonPressed:(id)sender
{
    userStoppedEditing=YES;
    [self hideChildTools];
    [self resetSelection];
}

-(void)showChildTools
{
    childToolOpen = YES;
    
    if(toolBarVisible)
        [self hideToolBar];
    
    if(laserSelected)
    {
        childToolsViewBg.frame=CGRectMake(0, 0, 50, 50);
        [self.childToolsView setFrame:CGRectMake(-60, (768-LASER_CHILD_VIEW_HEIGHT)/2, 50, LASER_CHILD_VIEW_HEIGHT)];
        [deselectButton setFrame:CGRectMake(10, 10, 30, 30)];
        [colorPaletteButton setHidden:YES];
        [undoButton setHidden:YES];
        [clearButton setHidden:YES];
    }
    
    else
    {
        childToolsViewBg.frame=CGRectMake(0, 0, 50, 200);
        [self.childToolsView setFrame:CGRectMake(-60, (768-OTHER_CHILD_VIEW_HEIGHT)/2, 50, OTHER_CHILD_VIEW_HEIGHT)];
        [deselectButton setFrame:CGRectMake(10, 150, 30, 30)];
        [colorPaletteButton setHidden:NO];
        [undoButton setHidden:NO];
        [clearButton setHidden:NO];
    }
    
    [self addSubview: canvas];
    [self bringSubviewToFront:canvas];
    [self bringSubviewToFront:toolBarViewNew];
    
    [UIView animateWithDuration:0.50f
                          delay:0.0f
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         [self bringSubviewToFront:childToolsView];
                         if(laserSelected)
                        [self.childToolsView setFrame:CGRectMake(0, (768-LASER_CHILD_VIEW_HEIGHT)/2, 50, LASER_CHILD_VIEW_HEIGHT)];
                         
                         else
                        [self.childToolsView setFrame:CGRectMake(0, (768-OTHER_CHILD_VIEW_HEIGHT)/2, 50, OTHER_CHILD_VIEW_HEIGHT)];
                     }
     
                     completion:nil];
}

-(void)hideChildTools
{
    childToolOpen = NO;
    
    if(userStoppedEditing)
    {
        [self.canvas.lines removeAllObjects];
        [self.canvas setNeedsDisplay];
        [self.canvas removeFromSuperview];
    }
    
    [UIView animateWithDuration:0.50f
                          delay:0.0f
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         if(laserSelected)
                             [self.childToolsView setFrame:CGRectMake(-60, (self.frame.size.height-LASER_CHILD_VIEW_HEIGHT)/2, 50, LASER_CHILD_VIEW_HEIGHT)];
                         
                         else
                             [self.childToolsView setFrame:CGRectMake(-60, (self.frame.size.height-OTHER_CHILD_VIEW_HEIGHT)/2, 50, OTHER_CHILD_VIEW_HEIGHT)];
                         
                     }
     
                     completion:nil];
}

-(void)showToolBar
{
    toolBarVisible = YES;
    
    if(childToolOpen)
        [self hideChildTools];
    
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         toolBarViewNew.frame=CGRectMake(941, 85, 84, 608);
                         pullDownButton.frame=CGRectMake(10, 250, 20, 100);
                     }
                     completion:nil];
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                     }
                     completion:^ (BOOL finished)
     {
         if (finished) {
             
             [pullDownButton setImage:[UIImage imageNamed:@"up_arrow_New.png"] forState:UIControlStateNormal];
             
         }
     }
     ];
    
}

-(void)hideToolBar
{
    toolBarVisible = NO;
    
    if((laserSelected || pencilSelected || highlightSelected) && !childToolOpen)
        [self showChildTools];
    
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         toolBarViewNew.frame=CGRectMake(994, 85, 84, 608);
                         pullDownButton.frame=CGRectMake(10, 250, 20, 100);
                     }
                     completion:nil];
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                     }
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [pullDownButton setImage:[UIImage imageNamed:@"down_arrow_New.png"] forState:UIControlStateNormal];
         }
     }
     ];
}

@end
