//
//  RecordViewController.h
//  Draw2
//
//  Created by Hanna Schneider on 11/14/12.
//
//

#import <UIKit/UIKit.h>

@protocol RecordViewControllerDelegate

/**
 * Record gesture
 *
 * @param color The color name
 * @param appName The application name
 */
- (void)recordGestureWithColor:(UIColor *)color applicationName:(NSString *)appName;

@end

@interface RecordViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
    
    /**
     * Picker
     */
    IBOutlet UIPickerView *picker;
    
    /**
     * Advice label
     */
    IBOutlet UILabel *adviceLabel;
    
    /**
     * Colors array
     */
    NSMutableArray *colorsArray;

    /**
     * Available colors array
     */
    NSMutableArray *availableColorsArray;
    
    /**
     * Apps array
     */
    NSMutableArray *appsArray;
    
    /**
     * Available apps array
     */
    NSMutableArray *availableAppsArray;
    
    /**
     * Delegate
     */
    id<RecordViewControllerDelegate>delegate;

    /**
     * Gestures array. To check apps and colors in use
     */
    NSMutableArray *auxGesturesArray;
    
}

/**
 * Picker
 */
@property (nonatomic, readwrite, retain) IBOutlet UIPickerView *picker;

/**
 * Delegate
 */
@property (nonatomic, readwrite, assign) id<RecordViewControllerDelegate>delegate;

/**
 * Advice label
 */
@property (nonatomic, readwrite, retain) IBOutlet UILabel *adviceLabel;

/**
 * Gestures array
 */
@property (nonatomic, readwrite, retain) NSArray *gesturesArray;

@end
