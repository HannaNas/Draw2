//
//  Draw2ViewController.h
//  Draw2
//
//  Created by Hybrid Interaction on 21.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"

@interface Draw2ViewController : UIViewController {
    
    
	IBOutlet DrawView *viewDraw;
    
    /*
     * Predefined Gesture where we store a possible gesture
     */
    NSArray *predefinedGesture;
    /*
     * The users gesture to compare with possible gestures
     */
    NSMutableArray *userGesture;
    

}

@property (nonatomic, retain) IBOutlet DrawView *viewDraw;

@property (readwrite, assign) NSArray *predefinedGesture;
@property (readwrite, assign) NSMutableArray *userGesture;

@end

