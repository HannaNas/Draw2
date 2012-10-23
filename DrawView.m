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

@synthesize mX;
@synthesize mY;
@synthesize tangible;
@synthesize angle;
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
        dot.x=xT;
        dot.y=yT;
        
        [delegate userTouch:dot];
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
        dot.x=xT;
        dot.y=yT;
        
        [delegate userTouch:dot];
        [dot release];
        
		//[self setNeedsDisplay];
	}
}

-(void)drawRect:(CGRect)rect{



	if(self.mX != 0.0){
	CGContextRef context = UIGraphicsGetCurrentContext();
	//CGContextSetRGBFillColor(context, 100, 149, 237, 1);
		
	//wieder in Bogenmaß umrechnen
	float endAngle = (M_PI*self.angle)/180;
	NSLog(@"endAngle %f", endAngle);
		
	if (self.tangible ==1) {
		float xArg = self.mX - 200.0;
		float yArg = self.mY - 200.0;
		CGContextSetRGBFillColor(context, 100, 149, 237, 1);
		CGContextFillEllipseInRect(context, CGRectMake(xArg, yArg, 400, 400));
		
		/* Kreisumfang berechnen */
		float umfang = (M_PI * 400);

		UIBezierPath* path = [[UIBezierPath alloc] init];
		CGPoint centerPoint = CGPointMake(mX, mY);
		[path moveToPoint:centerPoint];
			
		[path addArcWithCenter:centerPoint radius:(umfang / (2*M_PI)) startAngle:0.0 endAngle:endAngle clockwise:YES];
		[path closePath];
		
		[[UIColor redColor] setFill];
		[path fill];
	}
	else if (self.tangible ==2) {
		float xArg = self.mX - 250.0;
		float yArg = self.mY - 250.0;
		CGContextSetRGBFillColor(context, 255, 255, 000, 1);
		CGContextFillEllipseInRect(context, CGRectMake(xArg, yArg, 500, 500));
		
		/* Kreisumfang berechnen */
		float umfang = (M_PI * 500);
		
		UIBezierPath* path = [[UIBezierPath alloc] init];
		CGPoint centerPoint = CGPointMake(mX, mY);
		[path moveToPoint:centerPoint];
		
		[path addArcWithCenter:centerPoint radius:(umfang / (2*M_PI)) startAngle:0.0 endAngle:endAngle clockwise:YES];
		[path closePath];
		
		[[UIColor redColor] setFill];
		[path fill];
	}
	else if (self.tangible ==3) {
		float xArg = self.mX - 150.0;
		float yArg = self.mY - 150.0;
		CGContextSetRGBFillColor(context, 255, 100, 000, 1);
		CGContextFillEllipseInRect(context, CGRectMake(xArg, yArg, 300, 300));
		
		/* Kreisumfang berechnen */
		float umfang = (M_PI * 300);
		UIBezierPath* path = [[UIBezierPath alloc] init];
		CGPoint centerPoint = CGPointMake(mX, mY);
		[path moveToPoint:centerPoint];
		
		[path addArcWithCenter:centerPoint radius:(umfang / (2*M_PI)) startAngle:0.0 endAngle:endAngle clockwise:YES];
		[path closePath];
		
		[[UIColor redColor] setFill];
		[path fill];
	}
	else if (self.tangible ==4) {
		float xArg = self.mX - 100.0;
		float yArg = self.mY - 100.0;
		CGContextSetRGBFillColor(context, 84, 255, 159, 1);
		CGContextFillEllipseInRect(context, CGRectMake(xArg, yArg, 200, 200));
		
		/* Kreisumfang berechnen */
		float umfang = (M_PI * 200);
		UIBezierPath* path = [[UIBezierPath alloc] init];
		CGPoint centerPoint = CGPointMake(mX, mY);
		[path moveToPoint:centerPoint];
		

		[path addArcWithCenter:centerPoint radius:(umfang / (2*M_PI)) startAngle:0.0 endAngle:endAngle clockwise:YES];
		[path closePath];
		
		[[UIColor redColor] setFill];
		[path fill];
	}
	
		

	}

}

@end
