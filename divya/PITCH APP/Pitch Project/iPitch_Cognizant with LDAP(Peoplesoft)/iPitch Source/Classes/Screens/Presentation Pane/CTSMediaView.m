//
//  CTSMediaView.m
//  HTML5Play
//
//  Created by unameit on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CTSMediaView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CTSMediaView

@synthesize imageContainer,activeWebView;
@synthesize moviePlayer;
@synthesize delegate;
@synthesize sourcePoint, sourceRect;
@synthesize originalSizeOfElement;
@synthesize mediaType;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
       
        MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc] init]; 
        moviePlayerController.view.frame = self.bounds;
        moviePlayerController.view.backgroundColor = [UIColor clearColor];
        self.moviePlayer = moviePlayerController;
        [self addSubview:self.moviePlayer.view]; 
        
        UIImageView *container = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imageContainer = container;
        self.imageContainer.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageContainer];
       
        
               
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] 
                                                  initWithTarget:self 
                                                  action:@selector(pinchGestureAction:)]; 
        pinchGesture.delegate = self;
        [self addGestureRecognizer:pinchGesture];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMediaContainer:)];
        [panGesture setMaximumNumberOfTouches:2];
        [panGesture setDelegate:self];
        [self addGestureRecognizer:panGesture];
        
        UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
        rotationGesture.delegate = self;
        [self addGestureRecognizer:rotationGesture];
        
        
    }
    
    return self;
}

- (void)addMediaToContainer{
    switch (self.mediaType) {
            
        case HTML5MediaTypeImage:
            self.imageContainer.hidden = NO;
            
            break;
            
        default:
            break;
    }
    

}

-(void)playMovieAtPath:(NSString *)path  {  
    self.alpha = 1.0;
    NSURL    *videoURL    =   [NSURL fileURLWithPath:[path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];   
    self.moviePlayer.contentURL = [videoURL standardizedURL];
    NSLog(@"Playing video URL at %@",videoURL);
    [self.moviePlayer play]; 
}  


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
    
}



- (void)pinchGestureAction:(UIPinchGestureRecognizer *)pinchGesture{
    //[self adjustAnchorPointForGestureRecognizer:pinchGesture];
       self.activeWebView.userInteractionEnabled = NO;
    if ([pinchGesture state] == UIGestureRecognizerStateBegan || [pinchGesture state] == UIGestureRecognizerStateChanged) {
        [pinchGesture view].transform = CGAffineTransformScale([[pinchGesture view] transform], [pinchGesture scale], [pinchGesture scale]);
        [pinchGesture setScale:1];
       
    }
    
    else if([pinchGesture state] == UIGestureRecognizerStateEnded){
        
        [self collapseMediaView];  
        
    }
}
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)panMediaContainer:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = [gestureRecognizer view];
    self.activeWebView.userInteractionEnabled = NO;
   // [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
    
    else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        [self collapseMediaView];
    }
}

- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer
{
   // [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    self.activeWebView.userInteractionEnabled = NO;
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0];
    }
    else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        [self collapseMediaView];
    }

}

- (void)animationEnded{
    NSString *item = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).style.opacity = 1",  self.sourcePoint.x, self.sourcePoint.y];
    
    [self.activeWebView stringByEvaluatingJavaScriptFromString:item];
     self.frame = self.sourceRect;
    [self.moviePlayer stop];
    self.activeWebView.userInteractionEnabled = YES;
    
    NSString *jSString = [NSString stringWithFormat:@"var allImages = document.getElementsByTagName('IMG');for(var i=0;i<allImages.length;i++){allImages[i].style.opacity=1}"];
    
    [self.activeWebView stringByEvaluatingJavaScriptFromString:jSString];

    
}
- (void)collapseMediaView{
    CGSize newSize = CGSizeApplyAffineTransform(self.bounds.size, self.transform);
    //NSLog(@"New SIZE: W:%f H:%f",fabs(newSize.width),fabs(newSize.height));
    if ((fabs(newSize.width) < self.bounds.size.width) || (fabs(newSize.height) < self.bounds.size.height)) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.7];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationEnded)];
        self.center = self.sourcePoint;
        self.alpha = 0.0;
        [UIView commitAnimations];
        self.transform = CGAffineTransformIdentity;
    }
    
}


@end
