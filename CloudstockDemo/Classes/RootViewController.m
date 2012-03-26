#import "RootViewController.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "DogViewController.h"

@implementation RootViewController

@synthesize dataRows;
@synthesize breedNames;

#pragma mark Misc

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    self.dataRows = nil;
    [super dealloc];
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Mobile SDK Sample App";
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForDescribeWithObjectType:@"Dog__c"];  
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    //This response holds fields, and we have no fields
    if([jsonResponse objectForKey:@"fields"] != nil && self.breedNames == nil) {
        NSArray *fields = [jsonResponse objectForKey:@"fields"]; 
        for (id object in fields) {
            if([(NSString *)[object objectForKey:@"name"] isEqualToString:@"Breed__c"]) {
                NSLog(@"Found Breed");
                self.breedNames = [object objectForKey:@"picklistValues"];
            }
        }
        //We have our fields from the describe - make the original SOQL request
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Id, Name, Breed__c, Weight__c, Years_Old__c from Dog__c ORDER BY CreatedDate DESC LIMIT 100"];    
        [[SFRestAPI sharedInstance] send:request delegate:self];
    } else {
        NSArray *records = [jsonResponse objectForKey:@"records"];
        
    	//We got records this time, fill out the table
	    if(records != nil) {
	        self.dataRows = records;
	        [self.tableView reloadData];
	    } 
    }
    
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataRows count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
    }
	//if you want to add an image to your cell, here's how
	UIImage *image = [UIImage imageNamed:@"icon.png"];
	cell.imageView.image = image;
    
	// Configure the cell to show the data.
	NSDictionary *obj = [dataRows objectAtIndex:indexPath.row];
	cell.textLabel.text =  [obj objectForKey:@"Name"];
    
	//this adds the arrow to the right hand side.
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *obj = [dataRows objectAtIndex:indexPath.row];
    DogViewController *dogViewController = [[DogViewController alloc] initWithNibName:@"DogViewController" bundle:nil dog:obj breeds:self.breedNames];
    
    
    [self.navigationController pushViewController:dogViewController animated:YES];
    [dogViewController release];
    
}
@end
