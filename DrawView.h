//
//  DrawView.h
//
//  Created by Hybrid Interaction on 21.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Dot.h"

@protocol DrawViewDelegate

/**
 * Communicates which is the dot taked from the user input
 *
 * @param touch The dot
 * @param first Flag
 */
- (void)userTouch:(Dot *)touch isFirst:(BOOL)first;

/**
 * End recording the new gesture
 */
- (void)endRecordingNewGesture;

/**
 * Recognition finished
 */
- (void)recognitionFinished;

@end


@interface DrawView : UIView {
    
    /**
     * Delegate
     */
    id<DrawViewDelegate> delegate_;
    
    /**
     * User Points
     */
    NSMutableArray *userPoints;

    /**
     * Possible Gestures that can be drawn
     */
    NSMutableArray *drawableGestures;
    
    /**
     * Recognizing flag
     */
    BOOL recognizing;
    
    /**
     * Recording flag
     */
    BOOL recording;
    
    /**
     * Finish Recognizing flag
     */
    BOOL finishRecognizing;
}

/*
 * Delegate
 */
@property (nonatomic, readwrite, assign) id<DrawViewDelegate> delegate;

/*
 * Recognizing flag
 */
@property (nonatomic, readwrite, assign) BOOL recognizing;

/*
 * Recording flag
 */
@property (nonatomic, readwrite, assign) BOOL recording;

/*
 * Finish recognizing flag
 */
@property (nonatomic, readwrite, assign) BOOL finishRecognizing;

/**
 * Receives the gesture and posible gestures where the user gesture can be contained and prints them
 *
 * @param userGesture The user gesture
 * @param possibleGestures The possible gestures
 */
- (void)drawUserGesture:(NSArray *)userGesture forPossibleGesutures:(NSArray *)possibleGestures;


@end
