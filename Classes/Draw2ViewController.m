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

@implementation Draw2ViewController

#pragma mark -
#pragma mark Properties

@synthesize viewDraw;
@synthesize predefinedGesture;
@synthesize userGesture;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];

    Dot *dot1 = [[Dot alloc] init];
    dot1.x =50;
    dot1.y =20;
    
    Dot *dot2 = [[Dot alloc] init];
    dot1.x =50;
    dot1.y =30;
    
    Dot *dot3 = [[Dot alloc] init];
    dot1.x =50;
    dot1.y =40;
    
    Dot *dot4 = [[Dot alloc] init];
    dot1.x =50;
    dot1.y =40;
    
    predefinedGesture =  [[NSArray alloc] initWithObjects:dot1,dot2,dot3,dot4, nil];

    userGesture = [[NSMutableArray alloc] init];
    
    viewDraw.delegate = self;
    
}

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
        
        Dot *lastpoint = userGesture.lastObject;
        CGFloat distance = [Tools  distanceBetweenPoint:touch andPoint:lastpoint];
        
        //if distance > 10, save next point [sampeling]
        if (distance == SAMPLING_DISTANCE) {
        
            [userGesture addObject:touch];
            newSample = YES;
        
        } else if (distance > SAMPLING_DISTANCE) {
            //compute intersection between circle and line between last and new dot
            
            Dot *sampleDot = [[Dot alloc] init];
            sampleDot = [Tools dotInConstantDistanceFromDot:lastpoint toDot:touch];
            
            [userGesture addObject:sampleDot];
            newSample = true;
        
        }
    
    }

    BOOL isError = NO;

    //Checking the error
    if (newSample) {

        Dot *sampleDot = [userGesture lastObject];
        Dot *transDot = [[Dot alloc] init];
        transDot.x = sampleDot.x + userToTemplateDistance.x;
        transDot.y = sampleDot.y + userToTemplateDistance.y;
        
        Dot *tempDot = [predefinedGesture objectAtIndex:([userGesture count] - 1)];
        CGFloat transToTempDistance = fabsf([Tools distanceBetweenPoint:transDot andPoint:tempDot]);

//        Dot *transDot = [[Dot alloc] init];
//        transDot.x = touch.x + userToTemplateDistance.x;
//        transDot.y = touch.y + userToTemplateDistance.y;
//
//        int index = [userGesture indexOfObject:touch];
//        Dot *tempDot = [[Dot alloc] init];
//        tempDot = [predefinedGesture objectAtIndex:index];
//        
//        CGFloat transToTempDistance = fabsf([Tools distanceBetweenPoint:transDot andPoint:tempDot]);
        
        if (transToTempDistance > ERROR_DISTANCE) {
            isError = YES;
        }
        
    }
    
    if (isError) {
    
        NSLog(@"The point (%f, %f) is out of the gesture", touch.x, touch.y);
        
    } else {
    
        NSLog(@"The point (%f, %f) is inside the gesture", touch.x, touch.y);

    }

}

// Override to allow orientations other than the default portrait orientation.
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

@end
