//
//  Draw2ViewController.m
//  Draw2
//
//  Created by Hybrid Interaction on 21.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Draw2ViewController.h"
#import "Constants.h"
#import "Dot.h"
#import "Tools.h"
#import "Vector.h"

@interface Draw2ViewController ()

/**
 * Checks if the distante between dot1 and dot2 is bigger than the ERROR_DISTANCE
 *
 * @param dot1
 * @param dot1
 * @return TRUE if distance between dot1 and dot2 is =< ERROR_DISTANCE. False otherwise
 */
- (BOOL)checkErrorBetweenDot1:(Dot *)dot1 andDot2:(Dot *)dot2;

@end

#pragma mark -

@implementation Draw2ViewController

#pragma mark -
#pragma mark Properties

@synthesize viewDraw;
@synthesize predefinedGesture;
@synthesize userGesture;

#pragma mark -
#pragma mark Memory management

/**
 * Deallocates the memory occupied by the receiver.
 */
- (void)dealloc {
    
    [predefinedGesture release];
    predefinedGesture = nil;
    
    [userGesture release];
    userGesture = nil;
    
    [viewDraw release];
    viewDraw = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark View life cycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];

    Dot *dot1 = [[Dot alloc] init];
    dot1.x = 50;
    dot1.y = 20;
    
    Dot *dot2 = [[Dot alloc] init];
    dot2.x = 50;
    dot2.y = 30;
    
    Dot *dot3 = [[Dot alloc] init];
    dot3.x = 50;
    dot3.y = 40;
    
    Dot *dot4 = [[Dot alloc] init];
    dot4.x = 50;
    dot4.y = 50;
    
    
    predefinedGesture = [[NSArray alloc] initWithObjects:dot1,dot2,dot3,dot4, nil];

    userGesture = [[NSMutableArray alloc] init];
    
    viewDraw.delegate = self;
    
}

/**
 * Returns a Boolean value indicating whether the view controller supports the specified orientation.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark DrawViewDelegate

/*
 * Gets Point from the view and checks if it is in the gesture
 */
- (void)userTouch:(Dot *)touch isFirst:(BOOL)first {
    //calculate distance to last saved point
    BOOL newSample = NO;
    
    if (first) {
        [userGesture removeAllObjects];
    }
    
    if (userGesture.count == 0){
    
        [userGesture addObject:touch];
        
        if (userToTemplateDistance != nil) {
            
            [userToTemplateDistance release];
            userToTemplateDistance = nil;
            
        }
        
        userToTemplateDistance = [[Vector alloc] init];
        
        Dot *templateFirstDot = [predefinedGesture objectAtIndex:0];
        
        userToTemplateDistance.x = templateFirstDot.x - touch.x;
        userToTemplateDistance.y = templateFirstDot.y - touch.y;
    
    } else {
        
//        if the distance between touch and last userGesture is big we have
        
        Dot *lastpoint = userGesture.lastObject;
        CGFloat distance = [Tools  distanceBetweenPoint:touch andPoint:lastpoint];
        BOOL isError = false;
        
        //if distance > 10, save next point [sampeling]
        if (distance == SAMPLING_DISTANCE) {
        
            [userGesture addObject:touch];
            newSample = YES;
        
        } else if (distance > SAMPLING_DISTANCE) {
            //compute intersection between circle and line between last and new dot
            
            NSInteger chunks = (int)(distance / SAMPLING_DISTANCE);
            NSInteger i = 0;
            
            Dot *sampleDot = [[Dot alloc] init];
            
            while (i < chunks && !isError) {
                
                lastpoint = userGesture.lastObject;
                
                // next time I enter here I have a new last point
                sampleDot = [Tools dotInConstantDistanceFromDot:lastpoint toDot:touch];
                
                [userGesture addObject:sampleDot];

                Dot *predefDot = [predefinedGesture objectAtIndex:([userGesture count] -1)];
                
                isError = [self checkErrorBetweenDot1:[userGesture lastObject] andDot2:predefDot];

                i++;

                
                if (isError) {
                    
                    NSLog(@"The point (%f, %f) is OUT of the gesture", touch.x, touch.y);
                    //TODO: What do I have to do when the gesture is finished

                } else {
                    
                    NSLog(@"The point (%f, %f) is INSIDE the gesture", touch.x, touch.y);
                    
                }
                
                NSInteger predefinedGestureCount = [predefinedGesture count];
                NSInteger userGestureCount = [userGesture count];

                if (!isError && (predefinedGestureCount ==  userGestureCount)) {
                
                    NSLog(@"Gesture completed");
                    
                    for (Dot *dot in userGesture) {
                    
                        NSLog(@"Dot in user gesture (%f, %f)", dot.x, dot.y);
                    
                    }
                    
                    for (Dot *dot in predefinedGesture) {
                        
                        NSLog(@"Dot in predefined gesture (%f, %f)", dot.x, dot.y);
                        
                    }
                    
                    NSLog(@"Gesture completed");
                    //TODO: What do I have to do when the gesture is finished

                    
                } else if (!isError && (predefinedGestureCount >  userGestureCount)) {
                
                    NSLog(@"Keep on gesture");
                    
                }
                
            }
            
            [sampleDot release];

        }
    
    }
    


}

/*
 * Checks if the distante between dot1 and dot2 is bigger than the ERROR_DISTANCE
 */
- (BOOL)checkErrorBetweenDot1:(Dot *)dot1 andDot2:(Dot *)dot2 {
    
    Dot *transDot = [[Dot alloc] init];
    transDot.x = dot1.x + userToTemplateDistance.x;
    transDot.y = dot1.y + userToTemplateDistance.y;
    
//    NSLog(@"checkErrorBetweenDot1");
//    NSLog(@"TransDot (%f, %f)", transDot.x, transDot.y);
//    NSLog(@"PredifDot (%f, %f)", dot2.x, dot2.y);
//    NSLog(@"UserDot (%f, %f)", dot1.x, dot1.y);

    CGFloat transToTempDistance = fabsf([Tools distanceBetweenPoint:transDot andPoint:dot2]);

    return transToTempDistance > ERROR_DISTANCE;

}


@end
