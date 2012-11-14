//
//  Draw2ViewController.h
//  Draw2
//
//  Created by Hybrid Interaction on 21.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"
#import "Vector.h"

@interface Draw2ViewController : UIViewController <DrawViewDelegate> {
    
    /*
     * The draw view
     */
	IBOutlet DrawView *viewDraw;
    
    IBOutlet UISegmentedControl *modeSwitch;
    
    /*
     * The users gesture to compare with possible gestures
     */
    NSMutableArray *userGesture;
    
    /*
     * The array of Predefined Gestures: where we store the predefined gestures. Defined in the view did load
     */
    NSArray *predefinedGestureArray;
    
    /*
     * The array of drawable gestures: where we store the possible gestures that can be drawn. It is updated after every touch update.
     */
    NSMutableArray *drawableGesturesArray;
    
    /*
     * User to template distance
     */
    Vector *userToTemplateDistance;
    
}

/**
 * Defines the viewDraw and exports it to the IB
 */
@property (nonatomic, readwrite, retain) IBOutlet DrawView *viewDraw;
@property (nonatomic, readwrite, retain) IBOutlet UISegmentedControl *modeSwitch;


@end

