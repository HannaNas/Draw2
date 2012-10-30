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
- (void) userTouch:(Dot *)touch isFirst:(BOOL)first;

@end


@interface DrawView : UIView {

    // TODO: Do we need this?
	int tangible;
	float mX;
	float mY;
	float angle;
  
    
	IBOutlet UILabel *tempLabel;
	
	IBOutlet UILabel *tangibleLabel;
    
    /*
     * Delegate
     */
    id<DrawViewDelegate> delegate_;
	


}

// TODO: Do we need this?

@property (readwrite, assign) float mX;
@property (readwrite, assign) float mY;
@property (readwrite, assign) float angle;
@property (readwrite, assign) int tangible;

/*
 * Delegate
 */
@property (nonatomic, readwrite, assign) id<DrawViewDelegate> delegate;



@end
