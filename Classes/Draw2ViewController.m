//
//  Draw2ViewController.m
//  Draw2
//
//  Created by Hybrid Interaction on 21.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Draw2ViewController.h"
#import "Dot.h"
#import "Tools.h"
#define CONSTANT_DISTANCE 10.0f

@implementation Draw2ViewController

@synthesize viewDraw;
@synthesize predefinedGesture;
@synthesize userGesture;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];

    Dot *dot1 = [[Dot alloc]init];
    dot1.x =50;
    dot1.y =20;
    
    Dot *dot2 = [[Dot alloc]init];
    dot1.x =50;
    dot1.y =30;
    
    Dot *dot3 = [[Dot alloc]init];
    dot1.x =50;
    dot1.y =40;
    
    Dot *dot4 = [[Dot alloc]init];
    dot1.x =50;
    dot1.y =40;
    
    predefinedGesture = [NSArray arrayWithObjects:dot1,dot2,dot3,dot4, nil];

    userGesture = [[NSMutableArray alloc] init];
    
}

/*
 *Gets Point
 */
- (void) userTouch:(Dot *)touch{
    //calculate distance to last saved point
    BOOL newSample = false;
    if(userGesture.count==0){
        [userGesture addObject:touch];
        newSample = true;
    }
    
    else{
        Dot *lastpoint = userGesture.lastObject;
        CGFloat distance = [Tools  distanceBetweenPoint:touch andPoint:lastpoint];
        //if distance > 10, save next point [sampeling]
        if (distance==CONSTANT_DISTANCE) {
            [userGesture addObject:touch];
            newSample = true;
        }
        if (distance>CONSTANT_DISTANCE) {
            //compute intersection between circle and line between last and new dot
            [userGesture addObject:touch];
            newSample = true;
        }
    
    
    
    // if new point was added compare saved point with next point in predefinded gesture 

        
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


- (void)dealloc {
    [super dealloc];
}

@end
