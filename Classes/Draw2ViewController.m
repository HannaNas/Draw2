//
//  Draw2ViewController.m
//  Draw2
//
//  Created by Hybrid Interaction on 21.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Draw2ViewController.h"
#import "Dot.h"

@implementation Draw2ViewController

//@synthesize viewDraw;
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
    dot1.y =100;
    
    Dot *dot3 = [[Dot alloc]init];
    dot1.x =50;
    dot1.y =150;
    
    Dot *dot4 = [[Dot alloc]init];
    dot1.x =50;
    dot1.y =200;
    
    predefinedGesture = [[NSMutableArray alloc] init ];
    [predefinedGesture addObject:dot1 ];
    [predefinedGesture addObject:dot2 ];
    [predefinedGesture addObject:dot3 ];
    [predefinedGesture addObject:dot4 ];
    
    userGesture = [[NSMutableArray alloc] init];
    
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
