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
    
    /*
     * Delegate
     */
    id<DrawViewDelegate> delegate_;
    NSMutableArray *userPoints;

}

/*
 * Delegate
 */
@property (nonatomic, readwrite, assign) id<DrawViewDelegate> delegate;
@property (nonatomic, readwrite, assign) NSArray *userPoints;


@end
