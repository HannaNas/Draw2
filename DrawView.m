//
//  DrawView.m
//
//  Created by Hybrid Interaction on 21.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import "DrawView.h"
#import "Dot.h"

@implementation DrawView

#pragma mark -
#pragma mark Properties

@synthesize delegate;

#pragma mark -
#pragma mark Touches operations

/**
 * Tells the receiver when one or more fingers touch down in a view or window.
 *
 * @param touches A set of UITouch instances that represent the touches for the starting phase of the event represented by event.
 * @param event An object representing the event to which the touches belong.
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

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
	
		//[self setNeedsDisplay];
	}
}

/**
 * Tells the receiver when one or more fingers associated with an event move within a view or window.
 *
 * @param touches A set of UITouch instances that represent the touches for the starting phase of the event represented by event.
 * @param event An object representing the event to which the touches belong.
 */
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if(event.allTouches.count ==1){
		
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
        
		//[self setNeedsDisplay];
	}
}


/**
 * Tells the receiver when one or more fingers are raised from a view or window.
 *
 * @param touches A set of UITouch instances that represent the touches for the starting phase of the event represented by event.
 * @param event An object representing the event to which the touches belong.
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    
    if(event.allTouches.count ==1){
		
		//NSLog(@"One Touch");
		NSArray *touches = [event.allTouches allObjects];
		CGPoint pointOne = [[touches objectAtIndex:0]locationInView:self];
        
		float xT = pointOne.x;
		float yT = pointOne.y;
        Dot *dot = [[Dot alloc]init];
        dot.x = xT;
        dot.y = yT;
        
        NSLog(@"touchesEnded Point (%f, %f)", xT, yT);
        
        [delegate userTouch:dot isFirst:NO];
        [dot release];
        
		//[self setNeedsDisplay];
	}

}

/**
 * Draws the receiver’s image within the passed-in rectangle
 *
 * @param rect The portion of the view’s bounds that needs to be updated. 
 */
-(void)drawRect:(CGRect)rect{
    
    /**UIBezierPath* aPath = [UIBezierPath bezierPath];
     //[aPath lineCapStyle:kCGLineCapRound];
     [aPath moveToPoint:CGPointMake(0.0, 0.0)];
     [aPath addLineToPoint:CGPointMake(10.0, 10.0)];
     [aPath addCurveToPoint:CGPointMake(18.0, 21.0)
     controlPoint1:CGPointMake(6.0, 2.0)
     controlPoint2:CGPointMake(28.0, 10.0)];
     [aPath stroke];**/
    
    // needed:  getPointsUserGesture
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth (c,10);

    CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
    CGContextSetStrokeColor(c, red);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 50.0f, 50.0f);

    CGContextAddLineToPoint(c, 100.0f, 100.0f);

    CGContextAddLineToPoint(c, 200.0f, 100.0f);
    CGContextAddLineToPoint(c, 200.0f, 200.0f);

//    CGContextAddLineToPoint(c, 100.0f, 100.0f);
//    CGContextAddLineToPoint(c, 200.0f, 100.0f);
//    CGContextAddLineToPoint(c, 200.0f, 200.0f);

    CGContextAddLineToPoint(c, 50.0f, 70.0f);
    CGContextAddLineToPoint(c, 60.0f, 78.0f);
    CGContextAddLineToPoint(c, 70.0f, 86.0f);

    CGContextSetLineCap(c, kCGLineCapRound);
    CGContextSetLineJoin(c, kCGLineCapRound);
    CGContextStrokePath(c);

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
    
    [self drawRect:self.frame];
    
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
    
    [super dealloc];
    
}

@end
