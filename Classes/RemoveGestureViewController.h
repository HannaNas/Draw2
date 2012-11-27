//
//  RemoveGestureViewController.h
//  Draw2
//
//  Created by Victor Valle Juarranz on 27/11/12.
//
//

#import <UIKit/UIKit.h>

@protocol RemoveGestureViewControllerDelegate

/**
 * Gestures remove result transmits the array of gestures that will stay
 *
 * @param array The array of gestures
 */
- (void)gesturesRemovedResult:(NSArray *)array;

@end

@interface RemoveGestureViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    /**
     * Table view
     */
    UITableView *table;
    
    /**
     * Gestures array
     */
    NSMutableArray *auxGesturesArray;

    /**
     * Delegate
     */
    id<RemoveGestureViewControllerDelegate>delegate;
    
}


/**
 * Table view
 */
@property(nonatomic, readwrite, retain) IBOutlet UITableView *table;

/**
 * Gestures arrayx
 */
@property(nonatomic, readwrite, retain) NSArray *gesturesArray;

/**
 * Delegate
 */
@property (nonatomic, readwrite, assign) id<RemoveGestureViewControllerDelegate>delegate;

@end
