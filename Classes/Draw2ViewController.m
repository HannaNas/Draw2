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

@end

#pragma mark -

@implementation Draw2ViewController

#pragma mark -
#pragma mark Properties

@synthesize viewDraw;
@synthesize modeSwitch;
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIApplicationDidBecomeActiveNotification];
    
    [super dealloc];
}

#pragma mark -
#pragma mark View life cycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    // Gesture 1
//    Dot *dotG11 = [[[Dot alloc] init] autorelease];
//    dotG11.x = 50;
//    dotG11.y = 20;
//    
//    Dot *dotG12 = [[[Dot alloc] init] autorelease];
//    dotG12.x = 50;
//    dotG12.y = 30;
//    
//    Dot *dotG13 = [[[Dot alloc] init] autorelease];
//    dotG13.x = 50;
//    dotG13.y = 40;
//    
//    Dot *dotG14 = [[[Dot alloc] init] autorelease];
//    dotG14.x = 50;
//    dotG14.y = 50;
//    
//    // Gesture 2
//    Dot *dotG21 = [[[Dot alloc] init] autorelease];
//    dotG21.x = 20;
//    dotG21.y = 20;
//    
//    Dot *dotG22 = [[[Dot alloc] init] autorelease];
//    dotG22.x = 30;
//    dotG22.y = 20;
//    
//    Dot *dotG23 = [[[Dot alloc] init] autorelease];
//    dotG23.x = 40;
//    dotG23.y = 20;
//    
//    Dot *dotG24 = [[[Dot alloc] init] autorelease];
//    dotG24.x = 50;
//    dotG24.y = 20;
//    
//    Dot *dotG25 = [[[Dot alloc] init] autorelease];
//    dotG25.x = 60;
//    dotG25.y = 20;
//    
//    Dot *dotG26 = [[[Dot alloc] init] autorelease];
//    dotG26.x = 70;
//    dotG26.y = 20;
//    
//    NSArray *array1 = [[[NSArray alloc] initWithObjects:dotG11, dotG12, dotG13, dotG14, nil] autorelease];
//    NSArray *array2 = [[[NSArray alloc] initWithObjects:dotG21, dotG22, dotG23, dotG24, dotG25, dotG26, nil] autorelease];
//    
//    predefinedGestureArray = [[NSMutableArray alloc] initWithObjects:array1, array2, nil];
//    
//    Gesture *gesture1 = [[Gesture alloc] init];
//    Gesture *gesture2 = [[Gesture alloc] init];
//    
//    [gesture1 setName:@"Gesture1"];
//    [gesture1 setColor:COLOR_BLUE];
//    [gesture1 setGesture:array1];
//    
//    [gesture2 setName:@"Gesture2"];
//    [gesture2 setColor:COLOR_LILA];
//    [gesture2 setGesture:array2];
//    
//    predefinedGestureArray = [[NSMutableArray alloc] initWithObjects:gesture1, gesture2, nil];

    predefinedGestureArray = [[NSMutableArray alloc] init];
    
    userGesture = [[NSMutableArray alloc] init];
    drawableGesturesArray = [[NSMutableArray alloc] init];

    optionsButton.layer.cornerRadius = 5.0;
    optionsButton.layer.masksToBounds = YES;

//    viewDraw.delegate = self;
    
}

/**
 * Notifies the view controller that its view is about to be added to a view hierarchy.
 * 
 * @param animated If YES, the view is being added to the window using an animation.
 */
-(void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clean)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];

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
    [viewDraw drawUserGesture:nil forPossibleGesutures:nil];
    
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
        
        // Cleans the arrays
        [drawableGesturesArray removeAllObjects];
        [userGesture removeAllObjects];
        
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
                
                [drawableGesturesArray addObject:gestureMoved];
            
            }
            
        }
        
        // Updates the interface
        [self updateDrawableGestures];
        
    } else {

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
        
        [predefinedGestureArray addObject:gestureToSave];

    }
    
    [viewDraw drawUserGesture:nil forPossibleGesutures:nil];
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
    
    NSLog(@"distance: %f", distance);
    
    if (distance ==  SAMPLING_DISTANCE) {
        
        [userGesture addObject:dot];
        [self updateDrawableGestures];
        
    } else if (distance > SAMPLING_DISTANCE) {
        
        NSInteger chunks = (int)(distance / SAMPLING_DISTANCE);
        NSInteger i = 0;
        BOOL isError = NO;
        
        while (i < chunks && !isError) {
            
            Dot *sampleDot = [Tools dotInConstantDistanceFromDot:[userGesture lastObject] toDot:dot];
            
            NSLog(@"SampleDot %d (%f, %f)", i, sampleDot.x, sampleDot.y );
            
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

    if (modeSwitch.selectedSegmentIndex == 0) {
    
        NSLog(@"Try to updateDrawableGestures");
        NSMutableArray *auxDrawableGesturesArray = [[[NSMutableArray alloc] init] autorelease];
        
        Dot *lastDot = [userGesture lastObject];

        for (Gesture *gesture in drawableGesturesArray) {
            
            NSArray *array = [gesture gesture];
            
            if ([self isPossibleDot:lastDot inGesture:array forPosition:([userGesture count] - 1)]) {
                
                [auxDrawableGesturesArray addObject:gesture];
                NSLog(@"Gesture admited");
                
            } else {
                
                NSLog(@"Gesture discarded");
                
            }
            
        }
        
        [drawableGesturesArray removeAllObjects];
        [drawableGesturesArray addObjectsFromArray:auxDrawableGesturesArray];
        
        
        // Sends to print the getures
        [viewDraw drawUserGesture:userGesture forPossibleGesutures:drawableGesturesArray];
    
        if ([drawableGesturesArray count] == 1) {
            
            NSArray *checkGesture = [[drawableGesturesArray objectAtIndex:0] gesture];
                                     
            if ([checkGesture count] == [userGesture count]) {
                
                NSLog(@"GESTURE RECOGNIZED!!!");
                viewDraw.finishRecognizing = YES;
                
            }
            
        }

    } else {
        
        [viewDraw drawUserGesture:userGesture forPossibleGesutures:nil];
        
    }
    
    
}

/**
 * Clean
 */
-(void)clean {

    [viewDraw drawUserGesture:nil forPossibleGesutures:nil];

}

/*
 * Mode switch
 */
-(IBAction)modeSwitch {

    viewDraw.recording = (modeSwitch.selectedSegmentIndex == 1);
    viewDraw.recognizing = (modeSwitch.selectedSegmentIndex == 0);

    [viewDraw drawUserGesture:nil forPossibleGesutures:nil];
    
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





@end
