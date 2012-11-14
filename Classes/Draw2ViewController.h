//
//  Draw2ViewController.h
//  Draw2
//
//  Created by Hybrid Interaction on 21.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"
#import "RecordViewController.h"
#import "Vector.h"


@interface Draw2ViewController : UIViewController <DrawViewDelegate, RecordViewControllerDelegate> {
    
    /*
     * The draw view
     */
	IBOutlet DrawView *viewDraw;
    
    /*
     * Mode switch
     */
    IBOutlet UISegmentedControl *modeSwitch;
    
    /*
     * The users gesture to compare with possible gestures
     */
    NSMutableArray *userGesture;
    
    /*
     * The array of Predefined Gestures: where we store the predefined gestures. Defined in the view did load
     */
    NSMutableArray *predefinedGestureArray;
    
    /*
     * The array of drawable gestures: where we store the possible gestures that can be drawn. It is updated after every touch update.
     */
    NSMutableArray *drawableGesturesArray;
    
    /*
     * User to template distance
     */
    Vector *userToTemplateDistance;
    
    /*
     * Record View Controller
     */
    RecordViewController *recordViewController;
    
}

/**
 * Defines the viewDraw and exports it to the IB
 */
@property (nonatomic, readwrite, retain) IBOutlet DrawView *viewDraw;

/**
 * Defines the modeSwitch and exports it to the IB
 */
@property (nonatomic, readwrite, retain) IBOutlet UISegmentedControl *modeSwitch;

/**
 * Mode switch 
 */
-(IBAction)modeSwitch;

@end

