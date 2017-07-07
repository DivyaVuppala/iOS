//
//  Line.m
//  Paint App
//
//  Created by Ben Flannery on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Line.h"


@implementation Line

@synthesize linePath, lineColor, lineWidth, opacity;

-(id)init {
    // assumes settings uninitialized
    // change assigned values if appropriate
    if ((self = [super init])) {
        lineWidth = 2.0;
        lineColor = [UIColor blackColor];
        opacity = 1.0;
        linePath = CGPathCreateMutable();
    }
    return self;
} 

-(id)initWithOptions:(float)lineWidth_ color:(UIColor *)lineColor_ opacity:(float)opacity_{
    if ((self = [super init])) {
        lineWidth = lineWidth_;
        lineColor = lineColor_;
        opacity = opacity_;
        linePath = CGPathCreateMutable();
    }
    return self;
}


@end
