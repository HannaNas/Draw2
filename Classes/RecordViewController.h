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
 * @param condition The condition
 */
- (void)recordGesture:(BOOL)condition;

@end

@interface RecordViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
    
    IBOutlet UIPickerView *picker;
    NSMutableArray *colorsArray;
    NSMutableArray *appsArray;
    
    id<RecordViewControllerDelegate>delegate;
    

}

@property (nonatomic, readwrite, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, readwrite, assign) id<RecordViewControllerDelegate>delegate;


- (IBAction) cancelButton;
- (IBAction) saveButton;

@end
