//
//  Draw2ViewController.m
//  Draw2
//
//  Created by Hybrid Interaction on 21.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Draw2ViewController.h"

#import "Application.h"
#import "Color.h"
#import "Constants.h"
#import "Dot.h"
#import "Gesture.h"
#import "RecordViewController.h"
#import "Tools.h"
#import "Vector.h"

#import <QuartzCore/QuartzCore.h>

@interface Draw2ViewController ()

/**
 * Checks if the distante between dot1 and dot2 is bigger than the ERROR_DISTANCE
 *
 * @param dot1
 * @param dot1
 * @return TRUE if distance between dot1 and dot2 is =< ERROR_DISTANCE. False otherwise
 */
- (BOOL)checkErrorBetweenDot1:(Dot *)dot1
                      andDot2:(Dot *)dot2;


/**
 * Brings the gesture to star in the user touch
 *
 * @param gesture The array of dots
 * @param dot The reference dot
 * @return The gesture translated
 */
- (NSArray *)bringPosibleGesture:(NSArray *)gesture
                           toDot:(Dot *)dot;

/**
 * Brings the gesture to star in the user touch
 *
 * @param gesture The array of dots
 * @param dot The reference dot
 * @param position The position of the reference dot in gesture
 * @return The gesture translated
 */
- (NSArray *)bringPosibleGesture:(NSArray *)gesture
                           toDot:(Dot *)dot
                     forPosition:(NSInteger)position;


/**
 * Determines if a Dot could be part of a gesture given a position in the gesture array
 *
 * @param dot The dot to check
 * @param gesture The gesture
 * @param position The reference position of the dot inside the gesture
 * @result YES if dot is the allowed distance and 
 */
- (BOOL)isPossibleDot:(Dot *)dot
            inGesture:(NSArray *)gesture
          forPosition:(NSInteger)position;


/**
 * Samples the line between the last dot in the user gesture and the touch
 *
 * @param dot The touch dot
 */
- (void)samplingDotsToNewTouch:(Dot *)dot;

/**
 * Updates the drawable gestures
 */
- (void)updateDrawableGestures;

/**
 * Clean
 */
-(void)clean;


/**
 * Calculates the thickness based on the distance error
 */
- (CGFloat)thicknessByDistance:(CGFloat)distance;

@end

#pragma mark -

@implementation Draw2ViewController

#pragma mark -
#pragma mark Properties

@synthesize viewDraw;
@synthesize modeSwitch = modeSwitch_;
@synthesize optionsButton;

#pragma mark -
#pragma mark Memory management

/**
 * Deallocates the memory occupied by the receiver.
 */
- (void)dealloc {
    
    [userGesture release];
    userGesture = nil;
    
    [predefinedGestureArray release];
    predefinedGestureArray = nil;
    
    [drawableGesturesArray release];
    drawableGesturesArray = nil;
    
    [userToTemplateDistance release];
    userToTemplateDistance = nil;
    
    [viewDraw release];
    viewDraw = nil;
    
    [recordViewController release];
    recordViewController = nil;
    
    [removeGestureViewController release];
    removeGestureViewController = nil;
    
    [guideGesturesArray release];
    guideGesturesArray = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIApplicationDidBecomeActiveNotification];
    
    [super dealloc];
}

#pragma mark -
#pragma mark View life cycle

/**
 * Called after the controller’s view is loaded into memory.
 */
 - (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    predefinedGestureArray = [[NSMutableArray alloc] init];
    
    userGesture = [[NSMutableArray alloc] init];
    drawableGesturesArray = [[NSMutableArray alloc] init];
    guideGesturesArray = [[NSMutableArray alloc] init];
     
    optionsButton.layer.cornerRadius = 5.0;
    optionsButton.layer.masksToBounds = YES;
    
}

/**
 * Notifies the view controller that its view is about to be added to a view hierarchy.
 * 
 * @param animated If YES, the view is being added to the window using an animation.
 */
-(void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clean)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    [super viewWillAppear:animated];
    [self modeSwitch];
    viewDraw.delegate = self;
    [viewDraw setBackgroundColor:[UIColor whiteColor]];
    
    [optionsButton setEnabled:([predefinedGestureArray count] > 0)];
}

/**
 * Notifies the view controller that its view is about to be removed from a view hierarchy.
 */
-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [viewDraw drawUserGesture:nil forPossibleGesutures:nil expertMode:expertMode];
    
}


/**
 * Returns a Boolean value indicating whether the view controller supports the specified orientation.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

/**
 * Sent to the view controller when the app receives a memory warning.
 */
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


#pragma mark -
#pragma mark DrawViewDelegate

/*
 * Gets Point from the view and checks if it is in the gesture
 */
- (void)userTouch:(Dot *)touch isFirst:(BOOL)first {
    //calculate distance to last saved point

    // n gestures algorithm
    
    if (first) {
        
        timer = CFAbsoluteTimeGetCurrent();
        expertMode = NO;
        
        // Cleans the arrays
        [drawableGesturesArray removeAllObjects];
        [userGesture removeAllObjects];
        [guideGesturesArray removeAllObjects];
        
        // Inits the userGesture with the first dot
        [userGesture addObject:touch];
        
        // Brings all the predefined gestures to the user first tap and they fit in the screen they will
        // be stored in the drawableGesturesArray
        for (Gesture *gesture in predefinedGestureArray) {
            
            NSArray *gestureToCheck = [NSArray arrayWithArray:[gesture gesture]];
            NSArray *array = [self bringPosibleGesture:gestureToCheck toDot:touch];
            
            CGRect frame = [[self view] frame];
            
            if ([Tools gestureFitsOnScreen:array inRect:&frame]) {
            
                Gesture *gestureMoved = [[[Gesture alloc] init] autorelease];
                [gestureMoved setApp:[gesture app]];
                [gestureMoved setColor:[gesture color]];
                [gestureMoved setGesture:[[NSArray alloc] initWithArray:array]];
                [gestureMoved setThickness:GESTURE_THICKNESS];
                
                [drawableGesturesArray addObject:gestureMoved];
                [guideGesturesArray addObject:gestureMoved];
            }
            
        }
        
        // Updates the interface
        [self updateDrawableGestures];
        
    } else {
        
        double currentTime = CFAbsoluteTimeGetCurrent();
        double difference = currentTime - timer;
        
        timer = currentTime;
        
        expertMode = NO;

        if ((difference < EXPERT_TIME) && ([modeSwitch_ selectedSegmentIndex] == 0) ) {
        
            expertMode = YES;
            
        }

        // From the drawableGestures we have to see which one of them are still possible to draw
        [self samplingDotsToNewTouch:touch];
    
    }
}

/**
 * End recording the new gesture
 */
- (void)endRecordingNewGesture {

    if (recordViewController == nil) {
        recordViewController = [[RecordViewController alloc]init];
        recordViewController.delegate = self;

    }
    
    [recordViewController setGesturesArray:predefinedGestureArray];
    
    UINavigationController *navigationController = [[[UINavigationController alloc]initWithRootViewController:recordViewController] autorelease];
    [self presentViewController:navigationController animated:YES completion:nil];

}

/**
 * Recognition finished. Opens the application recorded in the gesuture
 */
- (void)recognitionFinished {

// http://mobiledevelopertips.com/cocoa/launching-other-apps-within-an-iphone-application.html
//    http://wiki.akosma.com/IPhone_URL_Schemes#Facebook
    
    Gesture *gesture = [drawableGesturesArray objectAtIndex:0];
    NSString *schema = [[gesture app] schema];
    
    NSURL *urlString = [NSURL URLWithString:schema];
    
    // An the final magic ... openURL!
    [[UIApplication sharedApplication] openURL:urlString];
}

#pragma mark -
#pragma mark RecordViewControllerDelegate

/**
 * Record gesture
 */
- (void)recordGestureWithColor:(Color *)color applicationName:(Application *)appName {

    if (appName != nil) {
        
        Gesture *gestureToSave = [[[Gesture alloc] init] autorelease];
        [gestureToSave setApp:appName];
        [gestureToSave setColor:color];
        [gestureToSave setGesture:[NSArray arrayWithArray:userGesture]];
        [gestureToSave setThickness:GESTURE_THICKNESS];
        
        [predefinedGestureArray addObject:gestureToSave];

    }
    
    [viewDraw drawUserGesture:nil forPossibleGesutures:nil expertMode:expertMode];
    [optionsButton setEnabled:([drawableGesturesArray count] > 0)];

}

#pragma mark -
#pragma mark RemoveGestureViewControllerDelegate

/**
 * Gestures remove result transmits the array of gestures that will stay
 *
 * @param array The array of gestures
 */
- (void)gesturesRemovedResult:(NSArray *)array {

    if (array != nil) {
        
        [predefinedGestureArray removeAllObjects];
        [predefinedGestureArray addObjectsFromArray:array];
        
    }
    
    [optionsButton setEnabled:([predefinedGestureArray count] > 0)];

}

#pragma mark -
#pragma mark Other methods

/*
 * Checks if the distante between dot1 and dot2 is bigger than the ERROR_DISTANCE
 */
- (BOOL)checkErrorBetweenDot1:(Dot *)dot1 andDot2:(Dot *)dot2 {
    
    Dot *transDot = [[[Dot alloc] init] autorelease];
    transDot.x = dot1.x + userToTemplateDistance.x;
    transDot.y = dot1.y + userToTemplateDistance.y;

    CGFloat transToTempDistance = fabsf([Tools distanceBetweenPoint:transDot andPoint:dot2]);

    return transToTempDistance > ERROR_DISTANCE;

}

/*
 * Brings the gesture to star in the user touch
 */
- (NSArray *)bringPosibleGesture:(NSArray *)gesture toDot:(Dot *)dot {

    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
    
    Dot *firstDotInGesture = [gesture objectAtIndex:0];
    
    NSInteger gestureCount = [gesture count];
    NSInteger i = 1;
    
    [result addObject:dot];
    
    while (i < gestureCount) {
        
        Dot *translatedDot = [Tools transformFromDot:[gesture objectAtIndex:i] givenDot1:firstDotInGesture dot2:dot];
        
        [result addObject:translatedDot];
        
        i++;
    
    }
    
    return result;

}

/*
 * Brings the gesture to star in the user touch
 */
- (NSArray *)bringPosibleGesture:(NSArray *)gesture toDot:(Dot *)dot forPosition:(NSInteger)position {
    
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
    
    Dot *dotInGesture = [gesture objectAtIndex:position];
    
    NSInteger gestureCount = [gesture count];
    NSInteger i = 0;
        
    while (i < gestureCount) {
        
        Dot *translatedDot = [Tools transformFromDot:[gesture objectAtIndex:i] givenDot1:dotInGesture dot2:dot];
        
        [result addObject:translatedDot];
        
        i++;
        
    }
    
    return result;
    
}

/*
 * Determines if a Dot could be part of a gesture given a position in the gesture array
 */
- (BOOL)isPossibleDot:(Dot *)dot
            inGesture:(NSArray *)gesture
          forPosition:(NSInteger)position {

    BOOL result = NO;
    
    if (position >= [gesture count]) {
        
        NSLog(@"YOU SHOULD HAVE ALREADY RECOGNIZED THE GESTURE");
        
    } else {
    
        Dot *dotInGesture = [gesture objectAtIndex:position];
        
        CGFloat distance = [Tools distanceBetweenPoint:dot andPoint:dotInGesture];
        result = (distance <= ERROR_DISTANCE);
        
    }
    
    return result;

}

/*
 * Samples the line between the last dot in the user gesture and the touch
 */
- (void)samplingDotsToNewTouch:(Dot *)dot {
    
    CGFloat distance = [Tools distanceBetweenPoint:[userGesture lastObject] andPoint:dot];
    
    if (distance ==  SAMPLING_DISTANCE) {
        
        [userGesture addObject:dot];
        [self updateDrawableGestures];
        
    } else if (distance > SAMPLING_DISTANCE) {
        
        NSInteger chunks = (int)(distance / SAMPLING_DISTANCE);
        NSInteger i = 0;
        BOOL isError = NO;
        
        while (i < chunks && !isError) {
            
            Dot *sampleDot = [Tools dotInConstantDistanceFromDot:[userGesture lastObject] toDot:dot];
                        
            [userGesture addObject:sampleDot];
            
            [self updateDrawableGestures];
            
            i++;
            
        }
                
    }

}

/*
 * Updates the drawable gestures
 */
- (void)updateDrawableGestures {

    if (modeSwitch_.selectedSegmentIndex == 0) {
    
        NSMutableArray *auxDrawableGesturesArray = [[[NSMutableArray alloc] init] autorelease];
        NSMutableArray *auxGuideGesturesArray = [[[NSMutableArray alloc] init] autorelease];

        Dot *lastDot = [userGesture lastObject];

        for (Gesture *gesture in guideGesturesArray) {//drawableGesturesArray) {
            
            NSArray *array = [gesture gesture];
            
            if ([self isPossibleDot:lastDot inGesture:array forPosition:([userGesture count] - 1)]) {
                
                [auxGuideGesturesArray addObject:gesture];
                
                NSArray *gestureToCheck = [NSArray arrayWithArray:[gesture gesture]];
                NSArray *array = [self bringPosibleGesture:gestureToCheck
                                                     toDot:lastDot
                                               forPosition:([userGesture count] - 1)];
                                
                Gesture *gestureMoved = [[[Gesture alloc] init] autorelease];
                [gestureMoved setApp:[gesture app]];
                [gestureMoved setColor:[gesture color]];
                [gestureMoved setGesture:[[NSArray alloc] initWithArray:array]];
                
                CGFloat distance = [Tools distanceBetweenPoint:lastDot
                                                      andPoint:[gestureToCheck objectAtIndex:([userGesture count] - 1)]];
                
                CGFloat thickness = [self thicknessByDistance:distance];
                
                [gestureMoved setThickness:thickness];

                [auxDrawableGesturesArray addObject:gestureMoved];
                
            } else {
                
                // The gesture is discarded
            }
            
        }
        
        [guideGesturesArray removeAllObjects];
        [guideGesturesArray addObjectsFromArray:auxGuideGesturesArray];

        [drawableGesturesArray removeAllObjects];
        [drawableGesturesArray addObjectsFromArray:auxDrawableGesturesArray];
        
        
        // Sends to print the getures
        [viewDraw drawUserGesture:userGesture forPossibleGesutures:drawableGesturesArray expertMode:expertMode];
    
        if ([drawableGesturesArray count] == 1) {
            
            NSArray *checkGesture = [[drawableGesturesArray objectAtIndex:0] gesture];
                                     
            if ([checkGesture count] == [userGesture count]) {
                
                viewDraw.finishRecognizing = YES;
                
            }
            
        }

    } else {
        
        [viewDraw drawUserGesture:userGesture forPossibleGesutures:nil expertMode:expertMode];
        
    }
    
    
}

/**
 * Clean
 */
-(void)clean {

    [viewDraw drawUserGesture:nil forPossibleGesutures:nil expertMode:expertMode];

}

/*
 * Mode switch
 */
-(IBAction)modeSwitch {

    viewDraw.recording = (modeSwitch_.selectedSegmentIndex == 1);
    viewDraw.recognizing = (modeSwitch_.selectedSegmentIndex == 0);

    [viewDraw drawUserGesture:nil forPossibleGesutures:nil expertMode:expertMode];
    
}

/**
 * Options
 */
-(IBAction)optionsTapped {

    if (removeGestureViewController != nil) {
        
        [removeGestureViewController release];
        removeGestureViewController = nil;
    }
    
    
    removeGestureViewController = [[RemoveGestureViewController alloc] init];
    removeGestureViewController.delegate = self;
    
    [removeGestureViewController setGesturesArray:predefinedGestureArray];

    
    UINavigationController *navigationController = [[[UINavigationController alloc]initWithRootViewController:removeGestureViewController] autorelease];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];

    
    
}

/**
 * Calculates the thickness based on the distance error
 */
- (CGFloat)thicknessByDistance:(CGFloat)distance {
    
    CGFloat result = GESTURE_THICKNESS;
    
    CGFloat error = ERROR_DISTANCE;
    CGFloat sample = (error / 10.0f);
    
    if (distance > ERROR_DISTANCE) {
        result = 0.0f;
    } else if (distance > (sample * 8)) {
        result = (result/5)*1;
    } else if (distance > (sample * 6)) {
        result = (result/5)*3;
    } else if (distance > (sample * 4)) {
        result = (result/5)*3;
    } else if (distance > (sample * 2)) {
        result = (result/5)*4;
    }
    
    return result;
    
}





@end
