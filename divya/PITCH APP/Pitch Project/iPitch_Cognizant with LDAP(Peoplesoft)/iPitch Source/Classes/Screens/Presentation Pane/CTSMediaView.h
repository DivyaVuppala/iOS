//
//  CTSMediaView.h
//  HTML5Play
//
//  Created by unameit on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h> 


typedef enum mediaType {
    
    HTML5MediaTypeImage = 1,
    HTML5MediaTypeVideo
    
} MediaType;

@protocol CTSMediaViewDelegate;


@interface CTSMediaView : UIView <UIGestureRecognizerDelegate>{
    
    MediaType mediaType;
    UIImageView *imageContainer;
    MPMoviePlayerController *moviePlayer;
    CGPoint sourcePoint;
    CGRect sourceRect;
    CGSize originalSizeOfElement;
    UIWebView *activeWebView;
    
}

@property MediaType mediaType;
@property  CGPoint sourcePoint;
@property  CGSize originalSizeOfElement;
@property  CGRect sourceRect;

@property (nonatomic, retain) UIImageView *imageContainer;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;
@property (nonatomic, weak)id <CTSMediaViewDelegate> delegate;
@property (nonatomic, retain) UIWebView *activeWebView;

- (void)collapseMediaView;
- (void)playMovieAtPath:(NSString *)path;

@end

@protocol CTSMediaViewDelegate <NSObject>
@optional
- (void)CTSMediaView:(CTSMediaView *)cTSMediaView cTSMediaViewPinchGesture:(UIPinchGestureRecognizer *)pinchGesture;

@end