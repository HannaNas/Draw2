//
//  RecordViewController.m
//  Draw2
//
//  Created by Hanna Schneider on 11/14/12.
//
//

#import "RecordViewController.h"

@interface RecordViewController ()

/**
 * Performs the cancel action
 */
- (void) cancelButton;

/**
 * Performs the save action
 */
- (void) saveButton;

@end

@implementation RecordViewController

#pragma mark -
#pragma mark Properties

@synthesize picker;
@synthesize delegate;

#pragma mark -
#pragma mark Memory management

/**
 * Deallocates the memory occupied by the receiver
 */
- (void) dealloc{
    
    [colorsArray release];
    colorsArray = nil;
    
    [appsArray release];
    appsArray = nil;
    
    delegate = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 * Called after the controller’s view is loaded into memory
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    colorsArray = [[NSMutableArray alloc]initWithObjects: @"red",@"blue",@"green",@"yellow",@"orange", nil];
    appsArray = [[NSMutableArray alloc]initWithObjects:@"mail", @"calender", @"phonecall", @"camera", @"facebook", nil];
    
    self.navigationItem.title = @"Record Gesture";
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveButton)] autorelease];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButton)] autorelease];
    
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    
    // Do any additional setup after loading the view from its nib.
}


/**
 * Sent to the view controller when the app receives a memory warning.
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark PickerView methods

/**
 * Called by the picker view when it needs the number of components.
 * 
 * @param pickerView The picker view requesting the data.
 * @return The number of components (or “columns”) that the picker view should display
 */
- (int) numberOfComponentsInPickerView:(UIPickerView*)picker{
    return 2;
}

/**
 * Called by the picker view when it needs the number of rows for a specified component.
 *
 * @param pickerView The picker view requesting the data.
 * @param component A zero-indexed number identifying a component of pickerView. Components are numbered left-to-right.
 * @return The number of rows for the component.
 */
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component==0){
        return [colorsArray count];
    }
    else{
        return [appsArray count];
    }
}

/**
 * Called by the picker view when it needs the title to use for a given row in a given component.
 *
 * @param pickerView An object representing the picker view requesting the data.
 * @param row A zero-indexed number identifying a row of component. Rows are numbered top-to-bottom.
 * @param component A zero-indexed number identifying a component of pickerView. Components are numbered left-to-right.
 * @return The string to use as the title of the indicated component row.
 */
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component==0){
        return [colorsArray objectAtIndex:row];
    }
    else{
        return [appsArray objectAtIndex:row];
    }
}


#pragma mark -
#pragma mark User interaction

/*
 * Performs the cancel button action
 */
- (void) cancelButton{
    [delegate recordGestureWithColor:@""
                     applicationName:@""];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 * Performs the save button action
 */
- (void) saveButton{
    [delegate recordGestureWithColor:[colorsArray objectAtIndex:[picker selectedRowInComponent:0]]
                     applicationName:[appsArray objectAtIndex:[picker selectedRowInComponent:1]]];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
