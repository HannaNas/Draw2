//
//  RecordViewController.m
//  Draw2
//
//  Created by Hanna Schneider on 11/14/12.
//
//

#import "RecordViewController.h"

#import "Application.h"
#import "Color.h"
#import "Constants.h"

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
@synthesize adviceLabel;

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
    
    [adviceLabel release];
    adviceLabel = nil;
    
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
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [adviceLabel setBackgroundColor:[UIColor clearColor]];
    [adviceLabel setTextColor:[UIColor darkGrayColor]];
    [adviceLabel setFont:[UIFont systemFontOfSize:14]];
    [adviceLabel setNumberOfLines:2];
    [adviceLabel setTextAlignment:NSTextAlignmentCenter];
    [adviceLabel setText:@"Choose a color and an application\nplease."];

    Color *color1 = [[[Color alloc] init] autorelease];
    [color1 setColorName:@"blue"];
    [color1 setColor:COLOR_LILA];
    
    Color *color2 = [[[Color alloc] init] autorelease];
    [color2 setColorName:@"lila"];
    [color2 setColor:COLOR_LILA];
    
    Color *color3 = [[[Color alloc] init] autorelease];
    [color3 setColorName:@"red"];
    [color3 setColor:COLOR_RED];
    
    Color *color4 = [[[Color alloc] init] autorelease];
    [color4 setColorName:@"light green"];
    [color4 setColor:COLOR_LIGHTGREEN];
    
    Color *color5 = [[[Color alloc] init] autorelease];
    [color5 setColorName:@"dark green"];
    [color5 setColor:COLOR_DARKGREEN];
    
    Color *color6 = [[[Color alloc] init] autorelease];
    [color6 setColorName:@"dark red"];
    [color6 setColor:COLOR_DARKRED];
    
    Color *color7 = [[[Color alloc] init] autorelease];
    [color7 setColorName:@"dark blue"];
    [color7 setColor:COLOR_DARKBLUE];
    
    Application *app1 = [[[Application alloc] init] autorelease];
    [app1 setAppName:@"Safari"];
    [app1 setSchema:@"http://www.u-psud.fr"];
    
    Application *app2 = [[[Application alloc] init] autorelease];
    [app2 setAppName:@"Maps"];
     NSString *title = @"title";
     float latitude = 35.4634;
     float longitude = 9.43425;
     int zoom = 13;
     NSString *stringURL = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@@%1.6f,%1.6f&z=%d", title, latitude, longitude, zoom];
    [app2 setSchema:stringURL];
    
    Application *app3 = [[[Application alloc] init] autorelease];
    [app3 setAppName:@"Phone"];
    [app3 setSchema:@"tel:0695442388"];
    
    Application *app4 = [[[Application alloc] init] autorelease];
    [app4 setAppName:@"SMS"];
    [app4 setSchema:@"sms:0695442388"];
    
    Application *app5 = [[[Application alloc] init] autorelease];
    [app5 setAppName:@"Mail"];
    [app5 setSchema:@"mailto:test@example.com"];
    
    Application *app6 = [[[Application alloc] init] autorelease];
    [app6 setAppName:@"iTunes"];
    [app6 setSchema:@"music:"];
    
    Application *app7 = [[[Application alloc] init] autorelease];
    [app7 setAppName:@"App Store"];
    [app7 setSchema:@"http://itunes.apple.com/"];
    
    colorsArray = [[NSMutableArray alloc]initWithObjects: color1, color2, color3, color4, color5, color6, color7, nil];
    appsArray = [[NSMutableArray alloc]initWithObjects:app1, app2, app3, app4, app5, app6, app7, nil];
    
    self.navigationItem.title = @"Record Gesture";
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveButton)] autorelease];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButton)] autorelease];
        
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {


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
        return [[colorsArray objectAtIndex:row] colorName];
    }
    else{
        return [[appsArray objectAtIndex:row] appName];
    }
}


/**
 * Called by the picker view when it needs the view to use for a given row in a given component.
 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {

    UIView *resultView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] autorelease];

    if (component == 0) {
        
        [resultView setBackgroundColor:[[colorsArray objectAtIndex:row] color]];
        
    } else {
    
        [resultView setBackgroundColor:[UIColor clearColor]];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] autorelease];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[[appsArray objectAtIndex:row] appName]];
        [label setTextColor:[UIColor blackColor]];
        [resultView addSubview:label];

    }
    
    return resultView;

}


#pragma mark -
#pragma mark User interaction

/*
 * Performs the cancel button action
 */
- (void) cancelButton{
    [delegate recordGestureWithColor:COLOR_YELLOW
                     applicationName:@""];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 * Performs the save button action
 */
- (void) saveButton{
    
    Color *color = [colorsArray objectAtIndex:[picker selectedRowInComponent:0]];
    Application *app = [appsArray objectAtIndex:[picker selectedRowInComponent:1]];

    [delegate recordGestureWithColor:[color color]
                     applicationName:[app schema]];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
