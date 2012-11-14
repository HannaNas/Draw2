//
//  RecordViewController.m
//  Draw2
//
//  Created by Hanna Schneider on 11/14/12.
//
//

#import "RecordViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

@synthesize picker;
@synthesize navigationBar;
@synthesize cancelButton;
@synthesize saveButton;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    colorsArray = [[NSMutableArray alloc]initWithObjects: @"red",@"blue",@"green",@"yellow",@"orange", nil];
    appsArray = [[NSMutableArray alloc]initWithObjects:@"mail", @"calender", @"phonecall", @"camera", @"facebook", nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int) numberOfComponentsInPickerView:(UIPickerView*)picker{
    return 2;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component==0){
        return [colorsArray count];
    }
    else{
        return [appsArray count];
    }
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component==0){
        return [colorsArray objectAtIndex:row];
    }
    else{
        return [appsArray objectAtIndex:row];
    }
}

- (void) dealloc{
    [colorsArray release];
    colorsArray = nil;
    [appsArray release];
    appsArray = nil;
    
    [picker release];
    picker = nil;
    delegate = nil;
    
    [super dealloc];
}

- (IBAction) cancelButton{
    [delegate recordGesture:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) saveButton{
    [delegate recordGesture:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
