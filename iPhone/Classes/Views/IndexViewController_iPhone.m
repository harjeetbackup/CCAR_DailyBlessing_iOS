//
//  IndexViewController.m
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 10/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import "IndexViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "FlashCard.h"
#import "CardDetails_iPhone.h"
#import "DBAccess.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation IndexViewController_iPhone

@synthesize _tableView;
@synthesize cards;
@synthesize indices;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title=@"Blessings Index";
	
	UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 30)];
	[leftButtonImg setImage:[UIImage imageNamed:@"back_btn_iPhone.png"] forState:UIControlStateNormal];
	[leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
	self.navigationItem.leftBarButtonItem=leftButton;
    }
	
	_tableView.backgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease];
	
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	cards=[db getCardsByAlphabets];
	indices=[[NSMutableArray alloc] init];
	
	for(int i=0;i<[cards count];i++){
		
		char alphabet = [[cards objectAtIndex:i] characterAtIndex:0];
		NSString *uniChar = [NSString stringWithFormat:@"%c", alphabet];
		if (![indices containsObject:uniChar.uppercaseString])
        {            
            [indices addObject:uniChar.uppercaseString];
        } 
	}
	
}


- (void)popView{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source
NSArray *flashCards1;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [indices count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	NSString *alphabet = [indices objectAtIndex:section];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
    flashCards1 = [cards filteredArrayUsingPredicate:predicate];
	
	//DBAccess* db=[AppDelegate_iPhone getDBAccess];
	//NSMutableArray *flashCards=[db getCardsByAlphabet:alphabet];
	NSLog(@"Alphabet : %@, Section : %d, Rows : %d",alphabet, section,[flashCards1 count]);
    return [flashCards1 count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [indices objectAtIndex:section];
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:CellIdentifier] autorelease];
		
		//cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.929 blue:0.592 alpha:1.0];
		cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kIndexRowColor]];
		/*cell.backgroundView  = [[[UIImageView alloc] 
								 initWithImage:[UIImage imageNamed:@"all_cards_bg.png"]] autorelease];*/
		
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]]];
        [cell setSelectedBackgroundView:bgColorView];
        [bgColorView release];
		UIImage* myImage=[UIImage imageNamed:@"arrow.png"];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
		cell.textLabel.font = [UIFont systemFontOfSize:16];
		[cell setAccessoryView:imageView];
		
	}

	NSString *alphabet = [indices objectAtIndex:[indexPath section]];
	
	
    //---get all states beginning with the letter---
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
    flashCards = [cards filteredArrayUsingPredicate:predicate];
    NSLog(@"For alphabet %@, no. of cards : %d",alphabet,[flashCards count]);
	if ([flashCards count]>0) {
		//---extract the relevant state from the states object---
        NSString *cellValue = [flashCards objectAtIndex:indexPath.row];
        cell.textLabel.text = cellValue;
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
		//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
	
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	//NSString *alphabet = [indices objectAtIndex:[indexPath section]];
    //---get all states beginning with the letter---
	//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
    //NSArray *flashCards = [cards filteredArrayUsingPredicate:predicate];
	CGSize labelSize = CGSizeMake(195.0f, 20.0);
	if([flashCards1 count] > 0)
	{
		NSString * strCardName = [flashCards1 objectAtIndex:indexPath.row];
		if ([strCardName length] > 0)
			labelSize = [strCardName sizeWithFont: [UIFont systemFontOfSize: 16.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];		
	}
	return 24.0 + labelSize.height;
}



//---set the index for the table---
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return indices;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	NSMutableArray* deckArray=[db getFlashCardForQuery:SELECT_Alphabetical_DECK_CARD_QUERY];
	CardDetails_iPhone* detail = [[CardDetails_iPhone alloc] initWithNibName:@"CardDetails_iPhone" bundle:nil];
	 detail.arrCards=deckArray;
	// Calculate Row index.
	NSUInteger row = 0;
	 NSUInteger sect = indexPath.section;
	 for (NSUInteger i = 0; i < sect; ++ i)
	 {
		 NSLog(@"No. of rows in section %d is %d",i,[_tableView numberOfRowsInSection:i]);
		row += [_tableView numberOfRowsInSection:i];
	 }
    row += indexPath.row;
	detail._selectedCardIndex=row;
	[self.navigationController pushViewController:detail animated:YES];
	//[detail loadArrayOfCards:deckArray];
	[detail release];
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[super dealloc];
}


@end

