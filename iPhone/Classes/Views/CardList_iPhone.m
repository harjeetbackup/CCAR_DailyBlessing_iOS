//
//  CardList.m
//  SchlossExtra
//
//  Created by Chandan Kumar on 16/08/11.
//  Copyright 2011 Interglobe Technologies. All rights reserved.
//

#import "CardList_iPhone.h"
#import "CardDetails_iPhone.h"
#import "FlashCard.h"
#import "DBAccess.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation CardListIPhone
{
    UILabel *lblDeckName ;
    FlashCardDeck* objFlashCardDeck;
}
@synthesize arrCards;
@synthesize tblCardNames;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
    view.backgroundColor = [UIColor whiteColor];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    if ([arrCards count]==0) {
		[self popView];
	}
    
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void) showCardsForDeck:(int) iDeckId
{
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	objFlashCardDeck = [db getFlashCardDeckByDeckId:iDeckId];
	lblDeckName = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 30)];
	[lblDeckName setTextAlignment:UITextAlignmentCenter];
	[lblDeckName setBackgroundColor:[UIColor clearColor]];
	[lblDeckName setTextColor:[UIColor whiteColor]];
	lblDeckName.font = [UIFont systemFontOfSize:12];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        lblDeckName.textColor = [UIColor whiteColor];
    }
    else
    {
        lblDeckName.textColor = [UIColor colorWithRed:54.0/255 green:95.0/255 blue:145.0/255 alpha:1];
        [lblDeckName setFont:[UIFont fontWithName:@"Arial-BoldMT" size:10]];
    }
	lblDeckName.text = objFlashCardDeck.deckTitle;
	self.navigationItem.titleView = lblDeckName;
	[lblDeckName release];
	
	UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 30)];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [leftButtonImg setImage:[UIImage imageNamed:@"back_btn_iPhone.png"] forState:UIControlStateNormal];
        
    }
	[leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        self.navigationItem.leftBarButtonItem=leftButton;
    }
	
	//self.navigationItem.title = objFlashCardDeck.deckTitle;
	arrCards = [[db getCardListForDeckType:kCardDeckTypeAlfabaticallly withId:iDeckId] retain];
	if([AppDelegate_iPhone delegate].isRandomCard == 1)
	{
		[Utils randomizeArray:arrCards];
	}
	
}
- (void) showAllCards
{
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	
	lblDeckName = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 30)];
	[lblDeckName setTextAlignment:UITextAlignmentCenter];
	[lblDeckName setBackgroundColor:[UIColor clearColor]];
	[lblDeckName setTextColor:[UIColor whiteColor]];
	lblDeckName.font = [UIFont systemFontOfSize:18];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        lblDeckName.textColor = [UIColor whiteColor];
    }
    else
    {
        lblDeckName.textColor = [UIColor blackColor];
    }
    
	lblDeckName.text = @"All Blessings";
	self.navigationItem.titleView = lblDeckName;
	[lblDeckName release];
	
	UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 30)];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [leftButtonImg setImage:[UIImage imageNamed:@"back_btn_iPhone.png"] forState:UIControlStateNormal];
    }
	[leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        self.navigationItem.leftBarButtonItem=leftButton;
    }
    
	
	//self.navigationItem.title = objFlashCardDeck.deckTitle;
	arrCards = [[db getCardListForDeckType:kCardDeckTypeAll withId:0] retain];
	if([AppDelegate_iPhone delegate].isRandomCard == 1)
	{
		[Utils randomizeArray:arrCards];
	}
	
}

- (void) showBookmarkCards
{
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
    
	lblDeckName = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 30)];
	[lblDeckName setTextAlignment:UITextAlignmentCenter];
	[lblDeckName setBackgroundColor:[UIColor clearColor]];
	[lblDeckName setTextColor:[UIColor whiteColor]];
	lblDeckName.font = [UIFont systemFontOfSize:18];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        
        lblDeckName.textColor = [UIColor whiteColor];
    }
    else
    {
        lblDeckName.textColor = [UIColor blackColor];
    }
    
	lblDeckName.text = @"Bookmarked Blessings";
	self.navigationItem.titleView = lblDeckName;
	[lblDeckName release];
	
	UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 30)];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [leftButtonImg setImage:[UIImage imageNamed:@"back_btn_iPhone.png"] forState:UIControlStateNormal];
    }
	[leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        self.navigationItem.leftBarButtonItem=leftButton;
    }
	
	//self.navigationItem.title = objFlashCardDeck.deckTitle;
	arrCards = [[db getCardListForDeckType:kCardDeckTypeBookMark withId:0] retain];
	if([AppDelegate_iPhone delegate].isRandomCard == 1)
	{
		[Utils randomizeArray:arrCards];
	}
	
}

- (void)popView{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	// Return the number of rows in the section.
    if ([arrCards count]==0) {
		return 1;
	}
	
	return [arrCards count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
      //  cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kCardListColor]];
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]]];
        [cell setSelectedBackgroundView:bgColorView];
        [bgColorView release];
	}
    
	FlashCard* card=(FlashCard*)[arrCards objectAtIndex:indexPath.row];
    	NSString *cellValue = [card cardName];
    
	cell.textLabel.text = cellValue;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        UIImage* myImage=[UIImage imageNamed:@"arrow.png"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
        
        [cell setAccessoryView:imageView];
    }
    else
    {
        UIImage* myImage=[UIImage imageNamed:@"arrow.png"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
        

        [cell setAccessoryView:imageView];
       // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
	cell.textLabel.font = [UIFont systemFontOfSize:16];
	//This allows for multiple lines
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
   // int a = arrCards.count;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        
        
     if ([lblDeckName.text  isEqual:@"All Blessings"])
     {
        cell.backgroundColor = [UIColor colorWithRed:211.0/255 green:243.0/255 blue:255.0/255 alpha:1];
         [self.tblCardNames setBackgroundColor:[UIColor colorWithRed:211.0/255 green:243.0/255 blue:255.0/255 alpha:1]];
     }
    else if  ([lblDeckName.text  isEqual:@"Bookmarked Blessings"])
        
    {
        cell.backgroundColor = [UIColor colorWithRed:211.0/255 green:243.0/255 blue:255.0/255 alpha:1];
        [self.tblCardNames setBackgroundColor:[UIColor colorWithRed:211.0/255 green:243.0/255 blue:255.0/255 alpha:1]];

    }
    
    else if ([lblDeckName.text isEqual:@"ENCOUNTERING NATURE"])
    {
        cell.backgroundColor = [UIColor colorWithRed:220.0/255 green:249.0/255 blue:189.0/255 alpha:1];
       // self.view.backgroundColor =[UIColor redColor];
       // self.listView. = [UIColor redColor];
        //[self.listView setBackgroundColor:[UIColor greenColor]];
        [self.tblCardNames setBackgroundColor:[UIColor colorWithRed:220.0/255 green:249.0/255 blue:189.0/255 alpha:1]];
    }
    else if ([lblDeckName.text isEqual:@"EXPERIENCING GRATITUDE AND JOY"])
    {
        cell.backgroundColor = [UIColor colorWithRed:253.0/255 green:191.0/255 blue:218.0/255 alpha:1];
        self.view.backgroundColor =[UIColor colorWithRed:240.0/255 green:220.0/255 blue:229.0/255 alpha:1];
        [self.tblCardNames setBackgroundColor:[UIColor colorWithRed:253.0/255 green:191.0/255 blue:218.0/255 alpha:1]];
    }
    else if ([lblDeckName.text isEqual:@"PARTICIPATING IN THE WORLD AROUND US"])
    {
        cell.backgroundColor = [UIColor colorWithRed:191.0/255 green:242.0/255 blue:239.0/255 alpha:1];
        self.view.backgroundColor =[UIColor colorWithRed:210.0/255 green:230.0/255 blue:229.0/255 alpha:1];
        [self.tblCardNames setBackgroundColor:[UIColor colorWithRed:191.0/255 green:242.0/255 blue:239.0/255 alpha:1]];
    }
    else if ([lblDeckName.text isEqual:@"MEETING NOTABLES"])
    {
        cell.backgroundColor = [UIColor colorWithRed:245.0/255 green:191.0/255 blue:233.0/255 alpha:1];
        self.view.backgroundColor =[UIColor colorWithRed:241.0/255 green:218.0/255 blue:238.0/255 alpha:1];
        [self.tblCardNames setBackgroundColor:[UIColor colorWithRed:245.0/255 green:191.0/255 blue:233.0/255 alpha:1]];
         }
    else if ([lblDeckName.text isEqual:@"CELEBRATING SIGNIFICANT OCCASIONS"])
    {
        cell.backgroundColor = [UIColor colorWithRed:255.0/255 green:191.0/255 blue:192.0/255 alpha:1];
        self.view.backgroundColor =[UIColor colorWithRed:237.0/255 green:202.0/255 blue:196.0/255 alpha:1];
        [self.tblCardNames setBackgroundColor:[UIColor colorWithRed:255.0/255 green:191.0/255 blue:192.0/255 alpha:1]];
    }
    else if ([lblDeckName.text isEqual:@"REPAIRING THE WORLD - TIKKUN OLAM"])
    {
        cell.backgroundColor = [UIColor colorWithRed:155.0/255 green:158.0/255 blue:212.0/255 alpha:1];
        self.view.backgroundColor =[UIColor colorWithRed:231.0/255 green:241.0/255 blue:254.0/255 alpha:1];
        [self.tblCardNames setBackgroundColor:[UIColor colorWithRed:155.0/255 green:158.0/255 blue:212.0/255 alpha:1]];
    }
    else if ([lblDeckName.text isEqual:@"BLESSINGS BEFORE EATING"])
    {
        cell.backgroundColor = [UIColor colorWithRed:236.0/255 green:215.0/255 blue:195.0/255 alpha:1];
        self.view.backgroundColor =[UIColor colorWithRed:253.0/255 green:234.0/255 blue:216.0/255 alpha:1];
        [self.tblCardNames setBackgroundColor:[UIColor colorWithRed:236.0/255 green:215.0/255 blue:195.0/255 alpha:1]];
    }
    else if ([lblDeckName.text isEqual:@"BLESSINGS AFTER EATING"])
    {
        cell.backgroundColor = [UIColor colorWithRed:192.0/255 green:229.0/255 blue:203.0/255 alpha:1];
        self.view.backgroundColor =[UIColor colorWithRed:202.0/255 green:203.0/255 blue:212.0/255 alpha:1];
        [self.tblCardNames setBackgroundColor:[UIColor colorWithRed:192.0/255 green:229.0/255 blue:203.0/255 alpha:1]];
    }
    else if ([lblDeckName.text isEqual:@"TRAVELER’S PRAYER"])
    {
        cell.backgroundColor = [UIColor colorWithRed:235.0/255 green:230.0/255 blue:203.0/255 alpha:1];
        self.view.backgroundColor =[UIColor colorWithRed:253.0/255 green:248.0/255 blue:225.0/255 alpha:1];
        [self.tblCardNames setBackgroundColor:[UIColor colorWithRed:235.0/255 green:230.0/255 blue:203.0/255 alpha:1]];
    }
   
    }
    
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    
    /* if ([arrCards objectAtIndex:2])
    {
        cell.backgroundColor = [UIColor redColor];
        }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }*/   // if (indexPath.section == 0 ) {
        //cell.backgroundColor = [UIColor whiteColor];
   // }
  //  else{
   // cell.backgroundColor = [UIColor whiteColor];
   // }
    return cell;
}
- (CGFloat) tableView: (UITableView *) tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	CGSize labelSize = CGSizeMake(272.0f, 20.0);
	FlashCard* card=(FlashCard*)[arrCards objectAtIndex:indexPath.row];
	
	NSString * strCardName = [card cardName];
	if ([strCardName length] > 0)
		labelSize = [strCardName sizeWithFont: [UIFont systemFontOfSize: 16.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
	return 24.0 + labelSize.height;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if ([arrCards count]==0) {
		return;
	}
	
	CardDetails_iPhone* detail = [[CardDetails_iPhone alloc] initWithNibName:@"CardDetails_iPhone" bundle:nil];
     detail.arrCards=arrCards;
    detail._selectedCardIndex=indexPath.row;
	[self.navigationController pushViewController:detail animated:YES];
	
	//detail._selectedCardIndex=indexPath.row;
   
	//[detail loadArrayOfCards:arrCards];
	[detail release];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setListView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [_listView release];
	[super dealloc];
}


@end
