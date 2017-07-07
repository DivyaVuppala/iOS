//
//  HTML5Container.m
//  H5Player
//
//  Created by unameit on 14/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HTML5Container.h"
#import "Utils.h"

#define JS_ELEMENT_X @"document.elementFromPoint(%f, %f).offsetLeft"
#define JS_ELEMENT_Y @"document.elementFromPoint(%f, %f).offsetTop"
#define JS_ELEMENT_WIDTH @"document.elementFromPoint(%f, %f).width"
#define JS_ELEMENT_HEIGHT @"document.elementFromPoint(%f, %f).height"

@implementation HTML5Container

@synthesize html5View, mediaContainer, type, delegate,fileType,localFilePath;




- (void)configureWebView{
    self.html5View = [[UIWebView alloc]initWithFrame:self.bounds];
    [self addSubview:self.html5View];
    self.html5View.delegate = self;
    self.html5View.allowsInlineMediaPlayback = YES;
    
    CTSMediaView *mediaView = [[CTSMediaView alloc]initWithFrame:CGRectMake(200, 200, 400, 400)];
    mediaView.delegate = self;
    self.mediaContainer = mediaView;
    self.mediaContainer.activeWebView = self.html5View;
    [self addSubview:mediaView];

    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] 
                                              initWithTarget:self 
                                              action:@selector(pinchGestureAction:)]; 
    pinchGesture.delegate = self;
    [self.html5View addGestureRecognizer:pinchGesture];
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateMediaContainer:)];
    rotationGesture.delegate = self;
    [self.html5View addGestureRecognizer:rotationGesture];
    


}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.html5View.scrollView.canCancelContentTouches = YES;
//        self.html5View.scrollView.bounces = NO;
//        [self.html5View setOpaque:NO]; 
//        self.html5View.backgroundColor=[UIColor clearColor];
            
               
        
//        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMediaContainer:)];
//        [panGesture setMaximumNumberOfTouches:2];
//        [panGesture setMinimumNumberOfTouches:2];
//        [panGesture setDelegate:self];
//        [self.html5View  addGestureRecognizer:panGesture];
//        [panGesture release];
        
        [self configureWebView];
       
    }
    
    return self;
}

- (void)loadHTMLFileAtPath:(NSString *)filePath WithType:(NSString *)_type{
//    NSString *fileType = nil;     
//    switch (self.type) {
//        case kHTML5ContainerTypeWeb:
//             fileType = @"html";
//             break;
//        case kHTML5ContainerTypeVideo:
//             fileType = @"mp4";
//             break;
//        case kHTML5ContainerTypePDF:
//             fileType = @"pdf";
//             break;
//        default:
//            break;
//    }
    self.fileType = _type;
    [self.html5View removeFromSuperview];
    [self.mediaContainer removeFromSuperview];
    
    
    self.html5View = nil;
    self.mediaContainer = nil;
    [self configureWebView];
    
    if ([_type isEqualToString:@"zip"] || [_type isEqualToString:@"html"]) {
        NSLog(@"self.html5View.scalesPageToFit = NO;");
        self.html5View.scalesPageToFit = NO;
    }
    else {
         NSLog(@"self.html5View.scalesPageToFit = YES;");
        self.html5View.scalesPageToFit = YES;
    }
     
   [self.html5View  loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    self.localFilePath=filePath;
}

-(void)reloadWebView
{
    [self.html5View  loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.localFilePath]]];

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    // webView.hidden = YES;
    if([self.delegate respondsToSelector:@selector(hTML5ContainerWillStartLoading:)])
        [self.delegate hTML5ContainerWillStartLoading:self];

    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
   // webView.hidden = YES;
    [Utils showLoading:webView];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    webView.hidden = NO;
    if([self.delegate respondsToSelector:@selector(hTML5ContainerDidStopLoading:)])
        [self.delegate hTML5ContainerDidStopLoading:self];
    [Utils removeLoading:webView];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    webView.hidden = NO;
    if([self.delegate respondsToSelector:@selector(hTML5ContainerDidStopLoading:)])
        [self.delegate hTML5ContainerDidStopLoading:self];
    [Utils removeLoading:webView];

}

- (void)extractMediaComponentAtPoint:(CGPoint)touchPoint{
    
    NSString *tagName =   [self.html5View stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", touchPoint.x, touchPoint.y]];
    NSLog(@"HTML TAG:%@",tagName);
    
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    NSString *urlToSave = [self.html5View stringByEvaluatingJavaScriptFromString:imgURL];
    NSURL * imageURL = [NSURL URLWithString:urlToSave];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    if (image) {
        self.html5View.userInteractionEnabled = NO;
        self.mediaContainer.moviePlayer.view.hidden = YES;
        self.mediaContainer.imageContainer.hidden = NO;
        self.mediaContainer.alpha = 1.0;
        self.mediaContainer.imageContainer.image = image;
        self.mediaContainer.frame = [self getFrameForMediaContentAtPoint:touchPoint];
        self.mediaContainer.imageContainer.frame = self.mediaContainer.bounds;
        self.mediaContainer.imageContainer.image = image;
        self.mediaContainer.sourcePoint = touchPoint;
        self.mediaContainer.sourceRect = [self getFrameForMediaContentAtPoint:touchPoint];
        self.mediaContainer.center = touchPoint;
        
        NSString *item = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).style.opacity = 0.0", touchPoint.x, touchPoint.y];
        
        [self.html5View stringByEvaluatingJavaScriptFromString:item];
       
        
        
    }
    else if ([tagName isEqualToString:@"VIDEO"]) {
        self.html5View.userInteractionEnabled = NO;
        self.mediaContainer.alpha = 1.0;
        self.mediaContainer.moviePlayer.view.hidden = NO;
        self.mediaContainer.imageContainer.hidden = YES;
        
        self.mediaContainer.frame = [self getFrameForMediaContentAtPoint:touchPoint];
        self.mediaContainer.moviePlayer.view.frame = self.mediaContainer.bounds;
        [self.mediaContainer playMovieAtPath:urlToSave];
        NSLog(@"Video URL%@",urlToSave);
        
        self.mediaContainer.sourcePoint = touchPoint;
        self.mediaContainer.sourceRect = [self getFrameForMediaContentAtPoint:touchPoint];
        self.mediaContainer.center = touchPoint;
        
        NSString *item = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).style.opacity = 0.0", touchPoint.x, touchPoint.y];
        
        [self.html5View stringByEvaluatingJavaScriptFromString:item];
        
    }
  
   
}

- (void)rotateMediaContainer:(UIRotationGestureRecognizer *)gestureRecognizer
{
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        self.mediaContainer.transform = CGAffineTransformRotate([ self.mediaContainer transform], [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0];
    }
}

- (void)panMediaContainer:(UIPanGestureRecognizer *)gestureRecognizer
{
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan && self.mediaContainer.alpha < 1 ) {
        
        CGPoint touchPoint = [gestureRecognizer locationInView:self];
        [self extractMediaComponentAtPoint:touchPoint];
            
    }
    
    else if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:self];
        [self.mediaContainer setCenter:CGPointMake([self.mediaContainer center].x + translation.x, [self.mediaContainer center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:self];
    }
//    else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded){
//           
//        [self.mediaContainer collapseMediaView];
//    }
    
}


- (void)pinchGestureAction:(UIPinchGestureRecognizer *)pinchGesture{
    
    
    if ([pinchGesture state] == UIGestureRecognizerStateBegan && self.mediaContainer.alpha < 1 ){
        CGPoint touchPoint = [pinchGesture locationInView:self];
         [self extractMediaComponentAtPoint:touchPoint];  
        
    }
    
    else if([pinchGesture state] == UIGestureRecognizerStateChanged){
        self.mediaContainer.transform = CGAffineTransformScale([self.mediaContainer transform], [pinchGesture scale], [pinchGesture scale]);
        [pinchGesture setScale:1];
        
    }
    
    else if ([pinchGesture state] == UIGestureRecognizerStateEnded) {
        
        [self.mediaContainer collapseMediaView];
    }
    
}

- (CGFloat)runJavaScript:(NSString *)jS AtPoint:(CGPoint) sourcePoint{
    return [[self.html5View stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:jS, sourcePoint.x, sourcePoint.y]]floatValue];
}

- (CGRect)getFrameForMediaContentAtPoint:(CGPoint) sourcePoint{
    
    CGFloat x = [self runJavaScript:JS_ELEMENT_X AtPoint:sourcePoint];
    CGFloat y = [self runJavaScript:JS_ELEMENT_Y AtPoint:sourcePoint];
    CGFloat width = [self runJavaScript:JS_ELEMENT_WIDTH AtPoint:sourcePoint];
    CGFloat height = [self runJavaScript:JS_ELEMENT_HEIGHT AtPoint:sourcePoint];
    NSLog(@"Rectangle: %f %f %f %f", x,y,width,height);
    return CGRectMake(x, y, width, height);
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ((self.mediaContainer.alpha < 1) && ([self.fileType isEqualToString:@"zip"] || [self.fileType isEqualToString:@"html"])) {
        return YES;
    }
    
    else {
        return NO;
    }
    
}

- (void)reset{
    [self.html5View reload];
    self.html5View.userInteractionEnabled = YES;
    self.mediaContainer.alpha = 0.0;
    self.mediaContainer.imageContainer.image = nil;
    [self.mediaContainer.moviePlayer stop];
}

@end
