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
#import "RemoveGestureViewController.h"
#import "Vector.h"


@interface Draw2ViewController : UIViewController <DrawViewDelegate, RecordViewControllerDelegate, RemoveGestureViewControllerDelegate> {
    
    /*
     * The draw view
     */
	IBOutlet DrawView *viewDraw;
    
    /*
     * Mode switch
     */
    IBOutlet UISegmentedControl *modeSwitch_;
    
    /**
     * Options button
     */
    UIButton *optionsButton;
    
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
    
    /**
     * Remove Gesture View Controller
     */
    RemoveGestureViewController *removeGestureViewController;
    
    /**
     * Guide gestures array
     */
    NSMutableArray *guideGesturesArray;
    
    /**
     * Timer
     */
    double timer;
    
    /**
     * Expert mode
     */
    BOOL expertMode;
}

/**
 * Defines the viewDraw and exports it to the IB
 */
@property (nonatomic, readwrite, retain) IBOutlet DrawView *viewDraw;

/**
 * Defines the optionsButton and exports it to the IB
 */
@property (nonatomic, readwrite, retain) IBOutlet UIButton *optionsButton;

/**
 * Defines the modeSwitch and exports it to the IB
 */
@property (nonatomic, readwrite, retain) IBOutlet UISegmentedControl *modeSwitch;

/**
 * Mode switch 
 */
-(IBAction)modeSwitch;

/**
 * Options
 */
-(IBAction)optionsTapped;

@end

