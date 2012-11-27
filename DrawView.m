//
//  DrawView.m
//
//  Created by Hybrid Interaction on 21.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.



#import "DrawView.h"

#import "Application.h"
#import "Constants.h"
#import "Dot.h"
#import "Gesture.h"
#import <QuartzCore/QuartzCore.h>


@implementation DrawView

#pragma mark -
#pragma mark Properties

@synthesize delegate;
@synthesize recording;
@synthesize recognizing;
@synthesize finishRecognizing;

#pragma mark -
#pragma mark Touches operations

/**
 * Tells the receiver when one or more fingers touch down in a view or window.
 *
 * @param touches A set of UITouch instances that represent the touches for the starting phase of the event represented by event.
 * @param event An object representing the event to which the touches belong.
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    finishRecognizing = NO;

	if(event.allTouches.count ==1){
		
		//NSLog(@"One Touch");
		NSArray *touches = [event.allTouches allObjects];
		CGPoint pointOne = [[touches objectAtIndex:0]locationInView:self];

		float xT = pointOne.x;
		float yT = pointOne.y;
        Dot *dot = [[Dot alloc]init];
        dot.x = xT;
        dot.y = yT;
        
        NSLog(@"FIRST Point (%f, %f)", xT, yT);
        
        [delegate userTouch:dot isFirst:YES];
        [dot release];
	
	}
}

/**
 * Tells the receiver when one or more fingers associated with an event move within a view or window.
 *
 * @param touches A set of UITouch instances that represent the touches for the starting phase of the event represented by event.
 * @param event An object representing the event to which the touches belong.
 */
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
    if ((event.allTouches.count ==1) && !finishRecognizing){
		
		//NSLog(@"One Touch");
		NSArray *touches = [event.allTouches allObjects];
		CGPoint pointOne = [[touches objectAtIndex:0]locationInView:self];
        
		float xT = pointOne.x;
		float yT = pointOne.y;
        Dot *dot = [[Dot alloc]init];
        dot.x = xT;
        dot.y = yT;
        
        NSLog(@"touchesMoved Point (%f, %f)", xT, yT);
        
        [delegate userTouch:dot isFirst:NO];
        [dot release];
        
	}
}


/**
 * Tells the receiver when one or more fingers are raised from a view or window.
 *
 * @param touches A set of UITouch instances that represent the touches for the starting phase of the event represented by event.
 * @param event An object representing the event to which the touches belong.
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (recording) {
        NSLog(@"YOU HAVE FINISHED YOUR RECORD!!!");
        [delegate endRecordingNewGesture];
    }

    if (recognizing && finishRecognizing) {
    
        finishRecognizing = NO;
        [delegate recognitionFinished];
    }

}

/**
 * Draws the receiver’s image within the passed-in rectangle
 *
 * @param rect The portion of the view’s bounds that needs to be updated. 
 */
-(void)drawRect:(CGRect)rect{
    
    //set up context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10);
    CGContextSetStrokeColorWithColor(context, COLOR_GRAY.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineCapRound);
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextBeginPath(context);
    
    for (int i = 0; i<[userPoints count]; i++) {
        
        Dot *dot = [userPoints objectAtIndex:i];
       
        if (i == 0) {
            CGContextMoveToPoint(context, dot.x, dot.y);
            
            if (i == [userPoints count]) {
                CGContextAddLineToPoint(context, dot.x, dot.y);
            }
            
        } 
        else{
            CGContextAddLineToPoint(context, dot.x, dot.y);
        }
    }
    
    //finished drawing
    CGContextStrokePath(context);
        
    for (Gesture *possibleGesture in drawableGestures) {
        
        int startingDot = [userPoints count];
        int count = [[possibleGesture gesture] count];
        int stop = [userPoints count] + 20;
        UIColor *color = [[possibleGesture color] color];
    
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        
        while (startingDot < count && startingDot < stop) {
            
            NSArray *array = [possibleGesture gesture];
            
            Dot *dot = [array objectAtIndex:startingDot];
            
            if (startingDot == [userPoints count]) {
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, dot.x, dot.y);
            } else {
                CGContextAddLineToPoint(context, dot.x, dot.y);
            }
            
            if ((startingDot == (count-1)) || (startingDot == (stop-1))) {    //finished drawing
                
                CGContextStrokePath(context);
                
                UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(dot.x, dot.y, 40, 40)] autorelease];
                UIImage *image = [UIImage imageNamed:[[possibleGesture app] appImageName]];
                
                [imageView setImage:image];
                imageView.layer.cornerRadius = 9.0;
                imageView.layer.masksToBounds = YES;
                imageView.layer.borderColor = color.CGColor;
                imageView.layer.borderWidth = 2.0;
                
                [appIcons addObject:imageView];
                [self addSubview:imageView];
                
            }
            
            startingDot++;
            
        }
        
    }
    
}

/*
 * Receives the gesture and posible gestures where the user gesture can be contained and prints them
 */
- (void)drawUserGesture:(NSArray *)userGesture forPossibleGesutures:(NSArray *)possibleGestures {

    if (userPoints == nil) {
        
        userPoints = [[NSMutableArray alloc] init];
        
    }
    
    [userPoints removeAllObjects];
    [userPoints addObjectsFromArray:userGesture];

    
    if (drawableGestures == nil) {
        
        drawableGestures = [[NSMutableArray alloc] init];
        
    }
    
    [drawableGestures removeAllObjects];
    [drawableGestures addObjectsFromArray:possibleGestures];
    
    if (appIcons == nil) {
    
        appIcons = [[NSMutableArray alloc] init];
    
    }
    
    for (UIImageView *imgView in appIcons) {
        
        [imgView removeFromSuperview];
        
    }
    
    [appIcons removeAllObjects];
    
    [self setNeedsDisplay];
        
}

/**
 * Deallocates the memory occupied by the receiver.
 */
-(void)dealloc {

    [userPoints release];
    userPoints = nil;
    
    [drawableGestures release];
    drawableGestures = nil;
    
    delegate_ = nil;
    
    [appIcons release];
    appIcons = nil;
    
    [super dealloc];
    
}

@end
