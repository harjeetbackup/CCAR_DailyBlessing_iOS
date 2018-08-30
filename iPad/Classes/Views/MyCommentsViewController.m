//
//  MyCommentsViewController.m
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 17/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import "MyCommentsViewController.h"
#import "AppDelegate_iPad.h"
#import "CardDetails.h"
#import "CommentsViewController.h"
#import "CardWrapper.h"
#import "DBAccess.h"


@implementation MyCommentsViewController

@synthesize _tableView;
@synthesize myComments;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title=@"My Comments";
	
	UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, 64, 30)];
	[leftButtonImg setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
	[leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
	self.navigationItem.leftBarButtonItem=leftButton;
	
	_tableView.backgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease];
	
	
	myComments=[[AppDelegate_iPad getDBAccess] getAllComments];
	
}

- (void)popView{
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) close:(id) sender{
	[self.view removeFromSuperview];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	if ([myComments count]==0) {
		return 1;
	}
	
    return [myComments count];
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
	return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// If row is deleted, remove it from the list.
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		CardWrapper* card=(CardWrapper*)[myComments objectAtIndex:indexPath.row];
		BOOL result=[[AppDelegate_iPad getDBAccess] deleteComments:card.flashCardId];
		if (result==YES) {
			[myComments removeObjectAtIndex:indexPath.row];
			[_tableView reloadData];
		}
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kCardListColor]];
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]]];
        [cell setSelectedBackgroundView:bgColorView];
        [bgColorView release];
    }
	
	if ([myComments count]==0) {
		cell.textLabel.text = @"No Comments Found!";
		cell.textLabel.font = [UIFont systemFontOfSize:14];
		cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled=NO;
		//cell.backgroundColor=[UIColor clearColor];
		
	}else {
		cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.929 blue:0.592 alpha:1.0];
		UIImage* myImage=[UIImage imageNamed:@"yel_arw.png"];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
		[cell setAccessoryView:imageView];
		
		NSString *cellValue = [[myComments objectAtIndex:indexPath.row] cardName];
		cell.textLabel.text = cellValue;
        cell.userInteractionEnabled=YES;
		//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
	
	
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if ([myComments count]==0) {
		return;
	}
	
	//Load Comments View
	CommentsViewController *detailViewController = [[CommentsViewController alloc] initWithNibName:@"CommentsViewiPad" bundle:nil];
	[detailViewController setFlashCardId:[[myComments objectAtIndex:indexPath.row] flashCardId]];
	
	detailViewController.view.frame = CGRectMake(0, 0, kDetailViewWidth, 724);
	[self.view addSubview:detailViewController.view];
	
	//[self.navigationController presentModalViewController:detailViewController animated:YES];
	//[detailViewController release];
	
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationLandscapeLeft)
		return YES;
	else
		return NO;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}


@end

