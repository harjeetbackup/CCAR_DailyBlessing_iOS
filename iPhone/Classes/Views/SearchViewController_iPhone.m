//
//  SearchViewController.m
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 10/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import "SearchViewController_iPhone.h"
#import "CardDetails_iPhone.h"
#import "FlashCard.h"
#import "DBAccess.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@implementation SearchViewController_iPhone
@synthesize _tableView;
@synthesize cards;
@synthesize _searchBar;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    
	[super viewDidLoad];
	self.navigationItem.title=@"Search Blessings";
	
	UIView *leftView=[[UIView alloc] initWithFrame:CGRectMake(5, 7, 50, 30)];
	//UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(-5, 6, 50, 20)];
    UIButton *leftButtonImg ;

    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
     {
         leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
	   [leftButtonImg setImage:[UIImage imageNamed:@"back_btn_iPhone.png"] forState:UIControlStateNormal];
        
     }
    else
    {
        leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(-5, 6, 50, 20)];
    
        [leftButtonImg setImage:[UIImage imageNamed:@"backNew_1.png"] forState:UIControlStateNormal];
    }
    
    leftButtonImg.contentMode = UIViewContentModeScaleAspectFit;
	   [leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
	  [leftView addSubview:leftButtonImg];
    // }
    
	UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftView] autorelease];
  //  if (SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"6.0"))
   // {
	self.navigationItem.leftBarButtonItem=leftButton;
       
   // }
   // else
  //  {
      /*  UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Back"
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(popView)];
       // [backButton setImage:[UIImage imageNamed:@"back-red.png"]];
        
        self.navigationItem.leftBarButtonItem=backButton;*/
        
        
       /* [buttonPrevious addTarget:self
                           action:@selector(loadPrevCardDetails:)
                 forControlEvents:UIControlEventTouchUpInside];*/
  //  }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
    
    CGRect myFrameTable = self._tableView.frame;
    myFrameTable.origin.y = 44;
    self._tableView.frame = myFrameTable;
    //self.dailyBlessingsTable.backgroundColor = [UIColor whiteColor];
    
    CGRect myFrameTableHeight = self._tableView.frame;
    myFrameTableHeight.size.height = 396+20;
    self._tableView.frame = myFrameTableHeight;
    }
    

	[leftView release];
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	cards=[db searchCardsByName:@""];
	
}


- (void)popView{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	
	/*if ([searchText isEqualToString:@""]) {
		return;
	}
	
	[cards removeAllObjects];	 
	cards=[[AppDelegate_iPhone getDBAccess] searchCardsByName:searchText];
	[_tableView reloadData];*/
	 
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
	NSString *searchText=[searchBar text];
	//if ([searchText isEqualToString:@""]) {
	//	return;
	//}
	
	[cards removeAllObjects];
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	cards=[db searchCardsByName:searchText];
	[_tableView reloadData];
	
	[searchBar resignFirstResponder];

}
/*- (void)SearchButtonClicked:(UISearchBar *)searchBar
{
    
	NSString *searchText=[searchBar text];
	//if ([searchText isEqualToString:@""]) {
	//	return;
	//}
	
	[cards removeAllObjects];
	cards=[[AppDelegate_iPhone getDBAccess] getCardsByAlphabet:searchText];
	[_tableView reloadData];
	
	[searchBar resignFirstResponder];
    
}*/



- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
	[cards removeAllObjects];	
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	cards=[db searchCardsByName:@""];
	[_tableView reloadData];
	
	[searchBar resignFirstResponder];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	// Return the number of rows in the section.
    if ([cards count]==0) {
		return 1;
	}
	
	return [cards count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setBackgroundColor:[Utils colorFromString:[Utils getValueForVar:kSearchCardListColor]]];
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]]];
        [cell setSelectedBackgroundView:bgColorView];
        [bgColorView release];
	}
    
	if ([cards count]==0) {
		cell.textLabel.text = @"No Search Result Found!";
		cell.textLabel.font = [UIFont systemFontOfSize:14];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}else {
		FlashCard* card=(FlashCard*)[cards objectAtIndex:indexPath.row];
		NSString *cellValue = [card cardName];
		
		cell.textLabel.text = cellValue;
		//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		UIImage* myImage=[UIImage imageNamed:@"arrow.png"];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
		[cell setAccessoryView:imageView];		
		cell.textLabel.font = [UIFont systemFontOfSize:16];
		//This allows for multiple lines
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
		/*
		CGSize maximumSize = CGSizeMake(1000, 9999);
		CGSize myStringSize = [cellValue sizeWithFont:cell.textLabel.font 
								   constrainedToSize:maximumSize 
										lineBreakMode:UILineBreakModeClip];
		NSLog(@"String - %@, Height - %f, Width - %f",cellValue,myStringSize.height,myStringSize.width);
		 */
	}

	
	
    return cell;
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	CGSize labelSize = CGSizeMake(272.0f, 20.0);
	if ([cards count]!=0) {
		FlashCard* card=(FlashCard*)[cards objectAtIndex:indexPath.row];
		NSString * strCardName = [card cardName];
		if ([strCardName length] > 0)
			labelSize = [strCardName sizeWithFont: [UIFont systemFontOfSize: 16.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
	}
	return 24.0 + labelSize.height;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	int iQuotient = 0;
	CGSize myStringSize;
	CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width;

	if([cards count] != 0)
	{
		CGSize maximumSize = CGSizeMake(300, 9999);
		FlashCard* card=(FlashCard*)[cards objectAtIndex:indexPath.row];
		NSString * strCardName = [card cardName];
		myStringSize = [strCardName sizeWithFont:[UIFont systemFontOfSize:18] 
								  constrainedToSize:maximumSize 
									  lineBreakMode:UILineBreakModeWordWrap];
		//iQuotient = (myStringSize.width / 270);
//		float iRemainder = (myStringSize.width/270) - iQuotient;
//		if (iQuotient > 0 && iRemainder > 0.7) {
//			iQuotient++;
//		}
//NSLog(@"String - %@, Width - %f, Multiple - %f, Adder - %d",strCardName,myStringSize.width,(myStringSize.width / 270),iQuotient);
	}
	return myStringSize.height+20;
		//return 40 + (iQuotient * 20);
}
 */

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if ([cards count]==0) {
		return;
	}
	
	CardDetails_iPhone* detail = [[CardDetails_iPhone alloc] initWithNibName:@"CardDetails_iPhone" bundle:nil];
     detail.arrCards=cards;
    detail._selectedCardIndex=indexPath.row;
	detail._searchText=[_searchBar text];
	[self.navigationController pushViewController:detail animated:YES];
	
	
	//[detail loadArrayOfCards:cards];
	[detail release];

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

