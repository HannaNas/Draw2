//
//  Gesture.h
//  Draw2
//
//  Created by Victor Valle Juarranz on 01/11/12.
//
//

#import <Foundation/Foundation.h>

#import "Application.h"
#import "Color.h"

@interface Gesture : NSObject {

    /**
     * The name identifier
     */
    Application *app;

    /**
     * The color
     */
    Color *color;
    
    /**
     * The array of Dots
     */
    NSMutableArray *auxGesture;

}

@property (nonatomic, readwrite, retain) Application *app;

@property (nonatomic, readwrite, retain) Color *color;

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
