//
//  RemoveGestureViewController.m
//  Draw2
//
//  Created by Victor Valle Juarranz on 27/11/12.
//
//

#import "RemoveGestureViewController.h"

#import "Application.h"
#import "Color.h"
#import "Gesture.h"

#import <QuartzCore/QuartzCore.h>

@interface RemoveGestureViewController ()

/**
 * Performs the cancel action
 */
- (void) cancelButton;

/**
 * Performs the save action
 */
- (void) saveButton;

@end

@implementation RemoveGestureViewController

#pragma mark -
#pragma mark Properties

@synthesize table = table;
@synthesize gesturesArray = auxGesturesArray;
@synthesize delegate = delegate;

#pragma mark -
#pragma mark Memory management

/**
 * Deallocates the memory occupied by the receiver.
 */
- (void)dealloc {

    [table release];
    table = nil;
    
    [auxGesturesArray release];
    auxGesturesArray = nil;
    
    delegate = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

/**
 * Called after the controller’s view is loaded into memory.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Your Gestures";
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveButton)] autorelease];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButton)] autorelease];
    
    // Do any additional setup after loading the view from its nib.
}

/**
 * Returns a Boolean value indicating whether the view controller supports the specified orientation.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

#pragma mark -
#pragma mark Table methods

/**
 * Tells the data source to return the number of rows in a given section of a table view. (required)
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger result = [auxGesturesArray count];
    return result;

}

/**
 * Asks the data source for a cell to insert in a particular location of the table view. (required)
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *result = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (result == nil)  {
        result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
    }
    
    [result setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 35, 35)] autorelease];
    
    Gesture *gesture = [auxGesturesArray objectAtIndex:[indexPath row]];
    Application *app = [gesture app];
    UIImage *image = [UIImage imageNamed:[app appImageName]];
    
    [imageView setImage:image];
    imageView.layer.cornerRadius = 9.0;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = [UIColor blackColor].CGColor;
    imageView.layer.borderWidth = 0.0;
    
    [result addSubview:imageView];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(80, 5, 150, 35)] autorelease];
    label.layer.cornerRadius = 9.0;
    label.layer.masksToBounds = YES;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    label.layer.borderWidth = 1.0;
    [label setBackgroundColor:[[gesture color] color]];
    
    [result addSubview:label];
    
    return result;

}


/**
 * Asks the data source to verify that the given row is editable.
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

/**
 * Asks the data source to commit the insertion or deletion of a specified row in the receiver.
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [auxGesturesArray removeObjectAtIndex:[indexPath row]];
        [tableView reloadData];
        
    }
}

#pragma mark -

-(void)setGesturesArray:(NSArray *)gesturesArray {

    if (auxGesturesArray == nil) {
        
        auxGesturesArray = [[NSMutableArray alloc] init];
        
    }
    
    [auxGesturesArray removeAllObjects];
    [auxGesturesArray addObjectsFromArray:gesturesArray];
    
    [table reloadData];

}


#pragma mark -
#pragma mark User interaction

/*
 * Performs the cancel button action
 */
- (void) cancelButton{
    
    [delegate gesturesRemovedResult:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 * Performs the save button action
 */
- (void) saveButton{
    
    [delegate gesturesRemovedResult:auxGesturesArray];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
