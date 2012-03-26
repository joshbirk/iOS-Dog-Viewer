//
//  DogViewController.m
//  HelloLA
//
//  Created by Joshua Birk on 1/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DogViewController.h"

@implementation DogViewController
@synthesize dog;
@synthesize breeds;
@synthesize lblDogName;
@synthesize lblAge;
@synthesize lblBreed;
@synthesize selectBreed;
@synthesize selectedBreed;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dog:(NSDictionary *)_dog breeds:(NSArray *)_breeds
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dog = _dog;
        self.title = [dog objectForKey:@"Name"];
        self.breeds = _breeds;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *name = [dog objectForKey:@"Name"];
    NSString *breed = [dog objectForKey:@"Breed__c"];
    
    [lblDogName setText:name];
    [lblBreed setText:breed];
    
}

//Define our picker view behavior
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.breeds count];
}


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.breeds objectAtIndex:row] objectForKey:@"value"];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedBreed = [[self.breeds objectAtIndex:row] objectForKey:@"value"];
}


//Define our button behavior
- (IBAction) doButtonUpdateBreed {
	NSArray *keys = [[NSArray alloc] initWithObjects:@"Breed__c", nil];
    NSArray *objs = [[NSArray alloc] initWithObjects:selectedBreed, nil];
    NSDictionary *fields = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"Dog__c" objectId:[dog objectForKey:@"Id"] fields:fields];    
    [[SFRestAPI sharedInstance] send:request delegate:self];
    
}

//Our dog data was updated, we can respectfully update both our data and view
- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    [lblBreed setText:selectedBreed];
    [dog setValue:selectedBreed forKey:@"Breed__c"];
}


- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    [[[[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"errorCode"]
                                 message: [[error userInfo] objectForKey:@"message"]
                                delegate:nil
                       cancelButtonTitle:NSLocalizedString(@"OK", nil)
                       otherButtonTitles:nil] autorelease] show];
    
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
