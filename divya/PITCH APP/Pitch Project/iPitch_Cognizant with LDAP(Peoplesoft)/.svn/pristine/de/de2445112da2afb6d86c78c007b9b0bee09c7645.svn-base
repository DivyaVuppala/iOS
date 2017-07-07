//
//  HTML5Container.h
//  H5Player
//
//  Created by unameit on 14/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTSMediaView.h"
#import "CanvasView.h"

typedef enum hTML5ContainerType{
    kHTML5ContainerTypeWeb     = 0,
    kHTML5ContainerTypeVideo   = 1,
    kHTML5ContainerTypePDF     = 2,
} HTML5ContainerType;

@class HTML5Container;

@protocol HTML5ContainerDelegate <NSObject>

- (void)hTML5ContainerWillStartLoading:(HTML5Container *)hTML5Container;
- (void)hTML5ContainerDidStopLoading:(HTML5Container *)hTML5Container;

@end


@interface HTML5Container : UIView <UIGestureRecognizerDelegate, CTSMediaViewDelegate, UIWebViewDelegate>{
    UIWebView *html5View;
    CTSMediaView *mediaContainer;
    HTML5ContainerType type;
    NSString *fileType;

}

@property (nonatomic, weak) id <HTML5ContainerDelegate> delegate;
@property (nonatomic, retain)UIWebView *html5View;
@property (nonatomic, retain)CTSMediaView *mediaContainer;
@property (nonatomic, retain)NSString *fileType;
@property (nonatomic, retain)NSString *localFilePath;

@property HTML5ContainerType type;


- (CGRect)getFrameForMediaContentAtPoint:(CGPoint) sourcePoint;
- (void)loadHTMLFileAtPath:(NSString *)filePath WithType:(NSString *)_type;
- (void)reset;
-(void)reloadWebView;

@end
