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
    
    IBOutlet UIPickerView *picker;
    NSMutableArray *colorsArray;
    NSMutableArray *appsArray;
    
    id<RecordViewControllerDelegate>delegate;
    

}

@property (nonatomic, readwrite, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, readwrite, assign) id<RecordViewControllerDelegate>delegate;


@end
