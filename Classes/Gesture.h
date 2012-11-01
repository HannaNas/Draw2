//
//  Gesture.h
//  Draw2
//
//  Created by Victor Valle Juarranz on 01/11/12.
//
//

#import <Foundation/Foundation.h>

@interface Gesture : NSObject {

    /**
     * The name identifier
     */
    NSString *name;

    /**
     * The color
     */
    UIColor *color;
    
    /**
     * The array of Dots
     */
    NSMutableArray *auxGesture;

}

@property (nonatomic, readwrite, copy) NSString *name;

@property (nonatomic, readwrite, retain) UIColor *color;

@property (nonatomic, readonly, retain) NSArray *gesture;

/**
 * Sets the gesture
 *
 * @param gesture The array of dots
 */
- (void)setGesture:(NSArray *)gesture;

/**
 * Returns the gesture
 * 
 * @return The gesture
 */
- (NSArray *)gesture;

@end
