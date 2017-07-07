//
//  LeavesViewController.m
//  Leaves
//
//  Created by Tom Brow on 4/18/10.
//  Copyright Tom Brow 2010. All rights reserved.
//

#import "LeavesViewController.h"
#import "AppDelegate.h"

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@implementation LeavesViewController


@synthesize leavesView;

- (void) initialize {
  leavesView = [[LeavesView alloc] initWithFrame:CGRectZero];
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
   if (self = [super initWithNibName:nibName bundle:nibBundle]) {
      [self initialize];
   }
   return self;
}

- (id)init {
   return [self initWithNibName:nil bundle:nil];
}

- (void) awakeFromNib {
	[super awakeFromNib];
	[self initialize];
}

- (void)dealloc {
	[leavesView release];
    [super dealloc];
}

#pragma mark LeavesViewDataSource methods

- (NSUInteger) numberOfPagesInLeavesView:(LeavesView*)leavesView {
	return 0;
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	
}

#pragma mark  UIViewController methods

- (void)loadView {
	[super loadView];
    self.leavesView.frame = CGRectMake(0, 10, 1024, 590);
	//self.leavesView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    pageScroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024,768)];

    pageScroller.delegate=self;
    pageScroller.minimumZoomScale=1.0;
    pageScroller.maximumZoomScale=8.0;
    pageScroller.contentSize=CGSizeMake(0, 0);
	[pageScroller addSubview:leavesView];

    leavesView.tag=1;
    [self.view addSubview:pageScroller];
    
}

- (void) viewDidLoad
{
	[super viewDidLoad];
    
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
    
    
    [doubleTap release];
    
	self.leavesView.dataSource = self;
	self.leavesView.delegate = self;
	[self.leavesView reloadData];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return leavesView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];

}

-(void)handleDoubleTap:(UIGestureRecognizer*)gestureRecognizer
{
    
    NSLog(@"pageScroller scale: %f",[pageScroller zoomScale]);
    float newScale = [pageScroller zoomScale] * 2.0;
    NSLog(@"newScale: %f",newScale);

    if (newScale<pageScroller.maximumZoomScale) {
        
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        [pageScroller zoomToRect:zoomRect animated:YES];
    }
    
    else{
        float newScale = 1.0;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        [pageScroller zoomToRect:zoomRect animated:YES];


    }

}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [pageScroller frame].size.height / scale;
    zoomRect.size.width  = [pageScroller frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
@end
