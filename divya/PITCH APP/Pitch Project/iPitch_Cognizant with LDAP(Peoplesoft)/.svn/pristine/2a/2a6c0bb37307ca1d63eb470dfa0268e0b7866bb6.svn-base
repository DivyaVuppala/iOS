//
//  PresentationPanelViewController.h
//  iPitch V2
//
//  Created by Satheeshwaran on 06/03/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//
#import "CanvasView.h"
#import "QuartzCore/CALayer.h"

#define LASER_CORNER_RADIUS 5
#define LASER_RADIUS 10

@implementation CanvasView
@synthesize lines, currentLine,laserSelected;

-(id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        currentLine = [[Line alloc] init];
        lines = [NSMutableArray arrayWithCapacity:10];
        laserSelected=NO;
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsBeginImageContext(self.frame.size);
    
    // draw accumulated lines
    if ([self.lines count] > 0) {
        for (Line *tempLine in self.lines){
            CGContextSetAlpha(context, tempLine.opacity);
            CGContextSetStrokeColorWithColor(context, tempLine.lineColor.CGColor);
            CGContextSetLineWidth(context, tempLine.lineWidth);
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            CGContextAddPath(context, tempLine.linePath);
            CGContextStrokePath(context);
            
            }
    }

    //draw current line
    CGContextSetAlpha(context, self.currentLine.opacity);

    
    CGContextSetStrokeColorWithColor(context, self.currentLine.lineColor.CGColor);
    CGContextSetLineWidth(context, self.currentLine.lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextBeginPath(context);
    CGContextAddPath(context, self.currentLine.linePath);
    CGContextStrokePath(context);


	UIGraphicsEndImageContext();
    

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!laserSelected)
    {
    UITouch *touch = [touches anyObject];
    CGPoint cPoint = [touch locationInView:self];
    
	CGPathMoveToPoint(self.currentLine.linePath, NULL, cPoint.x, cPoint.y);
    
    [self setNeedsDisplay];
    }
    else
    {
        for (UIView *tView in [self subviews]) {
            [tView removeFromSuperview];
        }
        // Enumerate over all the touches and draw a red dot on the screen where the touches were
        [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            // Get a single touch and it's location
            UITouch *touch = obj;
            CGPoint touchPoint = [touch locationInView:self];
            // Draw a red circle where the touch occurred
            UIView *touchView = [[UIView alloc] init];
            [touchView setBackgroundColor:[UIColor redColor]];
            touchView.frame = CGRectMake(touchPoint.x, touchPoint.y, LASER_RADIUS, LASER_RADIUS);
            touchView.layer.cornerRadius = LASER_CORNER_RADIUS;
            [self addSubview:touchView];
        }];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!laserSelected)
    {
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:self];
    
    CGPathAddLineToPoint(self.currentLine.linePath, NULL, currentPoint.x, currentPoint.y);
	
    [self setNeedsDisplay];
    }
    else
    {
        for (UIView *tView in [self subviews]) {
            [tView removeFromSuperview];
        }        // Enumerate over all the touches and draw a red dot on the screen where the touches were
        [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            // Get a single touch and it's location
            UITouch *touch = obj;
            CGPoint touchPoint = [touch locationInView:self];
            // Draw a red circle where the touch occurred
            UIView *touchView = [[UIView alloc] init];
            [touchView setBackgroundColor:[UIColor redColor]];
            touchView.frame = CGRectMake(touchPoint.x, touchPoint.y, LASER_RADIUS, LASER_RADIUS);
            touchView.layer.cornerRadius = LASER_CORNER_RADIUS;
            [self addSubview:touchView];
        }];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {	
    if(!laserSelected)
    {
	UITouch *touch = [touches anyObject];
    CGPoint cPoint = [touch locationInView:self];
    CGPathAddLineToPoint(self.currentLine.linePath, NULL, cPoint.x, cPoint.y);
    
    [self setNeedsDisplay];
    [self.lines addObject:self.currentLine];
    Line *nextLine = [[Line alloc] initWithOptions:self.currentLine.lineWidth color:self.currentLine.lineColor opacity:self.currentLine.opacity];
    self.currentLine = nextLine;
    NSLog(@"touch #: %u", [self.lines count]);
    }
}






-(void)removeLaserObjects
{
    for (UIView *tView in [self subviews]) {
        [tView removeFromSuperview];
    }

}

-(void)clearScreen
{
    [self.lines removeLastObject];
    [self setNeedsDisplay];
}
@end
