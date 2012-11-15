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
- (void)recordGestureWithColor:(NSString *)color applicationName:(NSString *)appName;

@end

@interface RecordViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
    
    /**
     * Picker
     */
    IBOutlet UIPickerView *picker;
    
    /**
     * Colors array
     */
    NSMutableArray *colorsArray;
    
    /**
     * Apps array
     */
    NSMutableArray *appsArray;
    
    /**
     * Delegate
     */
    id<RecordViewControllerDelegate>delegate;

}

/**
 * Picker
 */
@property (nonatomic, readwrite, retain) IBOutlet UIPickerView *picker;

/**
 * Delegate
 */
@property (nonatomic, readwrite, assign) id<RecordViewControllerDelegate>delegate;

@end
