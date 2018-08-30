//
//  IndexViewController.m
//  LeekIPhoneFC
//
//  Created by Ravindra Patel on 10/05/11.
//  Copyright 2011 HCL Technologies. All rights reserved.
//

#import "IndexViewController.h"
#import "AppDelegate_iPad.h"
#import "FlashCard.h"
#import "CardDetails.h"
#import "DBAccess.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@implementation IndexViewController
{
    UILabel* lblHeader ;
}
@synthesize _tableView;
@synthesize cards;
@synthesize indices;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forDeck:(FlashCardDeck *)objDeck 
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	// Create a transparent label for showing the header
	lblHeader = [[[UILabel alloc] initWithFrame:CGRectMake(66, 8, 500, 25)] autorelease];
	lblHeader.backgroundColor = [UIColor clearColor];
	[lblHeader setTextAlignment:UITextAlignmentCenter];
    lblHeader.font =[UIFont systemFontOfSize:18];
	
	// Check whether the call has been made from the index button on deck view controller or the click of the card deck
	if (objDeck != nil) {
		// Set the label text to the title of the deck and also get the list of cards for that deck
		lblHeader.text= objDeck.deckTitle;
		cards = [[objDeck getCardsList] retain];
		if([AppDelegate_iPad delegate].isRandomCard == 1)
		{
			[Utils randomizeArray:cards];
		}
		_source = @"DeckCard";
		indices = [[NSMutableArray alloc] initWithObjects:@"   ",nil];
	}
	else 
	{
		// Header is set and 
		lblHeader.text=@"Blessings Index";
        [lblHeader setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];

		_tableView.backgroundView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease];
		cards=[[AppDelegate_iPad getDBAccess] getCardsByAlphabets];
		indices=[[NSMutableArray alloc] init];
		char alphabet;
        NSString *uniChar;
		for(int i=0;i<[cards count];i++)
		{
			alphabet = [[cards objectAtIndex:i] characterAtIndex:0];
			uniChar = [NSString stringWithFormat:@"%c", alphabet];
			if (![indices containsObject:uniChar.uppercaseString])
			{            
				[indices addObject:uniChar.uppercaseString];
			}
               
		}
    [indices addObject:@""];
    [indices addObject:@""];
	}
   lblHeader.tag = 1;
    if([self.view viewWithTag:1]!=nil)
    {
        [[self.view viewWithTag:1] removeFromSuperview];
    }
	[self.view addSubview:lblHeader];

	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
      [self.myButton setImage:[UIImage imageNamed:@"backNew_1.png"] forState:UIControlStateNormal];
        
        /*CGRect myFrameTableHeight = _tableView.frame;
        myFrameTableHeight.size.height = 500;
        _tableView.frame = myFrameTableHeight;*/
       // CGRect myFrameImg = _tableView.frame;
        // myFrame.origin.x = 634;
      //  myFrameImg.origin.y = -500;
       // myFrameImg.size.height = 200;
        //_tableView.frame=CGRectMake(0, 0, 700, 700);

    }
    else
    {
        [self.myButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    }
    
}


-(void) setParentViewCtrl:(DeckViewController*) parentView{
	_parentView=parentView;
}


-(IBAction) closeIndex:(id)sender{
	[self.view removeFromSuperview];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	int iSectionCount = -1;
	if ([_source isEqualToString:@"DeckCard"]) 
	{
		iSectionCount = 1;
	}
	else {
		iSectionCount = [indices count];
	}

	return iSectionCount;
}

//declaring all the variables for table view
NSString *alphabet;
NSPredicate *predicate;
NSArray *flashCards ;
NSString * strCardName;
CGSize labelSize;
NSString* strHeaderTitle = @"";
CGRect tableRect;
Card* card;
//==============================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int iRowSCount = -1;
    if ([_source isEqualToString:@"DeckCard"]) {
		iRowSCount = [cards count];
	}
	else {
		alphabet = [indices objectAtIndex:section];
		predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
		flashCards = [cards filteredArrayUsingPredicate:predicate];
		iRowSCount = [flashCards count];
	}
    return iRowSCount;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	//NSArray *flashCards;
	labelSize = CGSizeMake(450.0f, 20.0);
	if ([_source isEqualToString:@"DeckCard"]) {
		if([cards count] > 0)
		{
			card =  (Card *)[[cards objectAtIndex:indexPath.row] getCardOfType: kCardTypeFront];
			strCardName = card.cardName;
			if ([strCardName length] > 0)
				labelSize = [strCardName sizeWithFont: [UIFont systemFontOfSize: 18.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
        }
	}
	else
	{
		//NSString *alphabet = [indices objectAtIndex:[indexPath section]];
		//---get all states beginning with the letter---
		//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
        
		//flashCards = [cards filteredArrayUsingPredicate:predicate];
        
		if([flashCards count] > 0)
		{
			strCardName = [flashCards objectAtIndex:indexPath.row];
			if ([strCardName length] > 0)
				labelSize = [strCardName sizeWithFont: [UIFont systemFontOfSize: 18.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
            
		}
	}
	return 24.0 + labelSize.height;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {	
	
	if ([_source isEqualToString:@"DeckCard"]) {
		strHeaderTitle = @"";
	}
	else {
		strHeaderTitle = [indices objectAtIndex:section];
	}

	return strHeaderTitle;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableRect = self.view.frame;
	tableRect.origin.x = 0;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        tableRect.origin.y = 20;
        
    }
	tableView.frame = tableRect;
   
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIImage* myImage;
    UIImageView *imageView;
     UIView *bgColorView = [[[UIView alloc] init] autorelease];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:CellIdentifier] autorelease];
		
        //cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kIndexRowColor]];
       
        [bgColorView setBackgroundColor:[Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]]];
        [cell setSelectedBackgroundView:bgColorView];
        
		cell.textLabel.font = [UIFont systemFontOfSize:16];
		
		myImage=[UIImage imageNamed:@"arrow.png"];
		
		imageView = [[[UIImageView alloc] initWithImage:myImage] autorelease];
		[cell setAccessoryView:imageView];
		
     
	}
	
	if ([_source isEqualToString:@"DeckCard"]) {
		Card* card = (Card *)[[cards objectAtIndex:indexPath.row] getCardOfType: kCardTypeFront] ;
		NSString *cellValue = card.cardName;
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            
            if ([lblHeader.text  isEqual:@"All Blessings"]) {
                cell.backgroundColor = [UIColor colorWithRed:211.0/255 green:243.0/255 blue:255.0/255 alpha:1];
                _tableView.backgroundColor = [UIColor colorWithRed:211.0/255 green:243.0/255 blue:255.0/255 alpha:1];
            }
            else if  ([lblHeader.text  isEqual:@"Bookmarked Blessings"])
                
            {
                cell.backgroundColor = [UIColor colorWithRed:211.0/255 green:243.0/255 blue:255.0/255 alpha:1];
                _tableView.backgroundColor = [UIColor colorWithRed:211.0/255 green:243.0/255 blue:255.0/255 alpha:1];
            }
            
            else if ([lblHeader.text isEqual:@"ENCOUNTERING NATURE"])
            {
                cell.backgroundColor = [UIColor colorWithRed:220.0/255 green:249.0/255 blue:189.0/255 alpha:1];;
                _tableView.backgroundColor = [UIColor colorWithRed:220.0/255 green:249.0/255 blue:189.0/255 alpha:1];
            }
            else if ([lblHeader.text isEqual:@"EXPERIENCING GRATITUDE AND JOY"])
            {
                cell.backgroundColor = [UIColor colorWithRed:253.0/255 green:191.0/255 blue:218.0/255 alpha:1];
                _tableView.backgroundColor = [UIColor colorWithRed:253.0/255 green:191.0/255 blue:218.0/255 alpha:1];
            }
            else if ([lblHeader.text isEqual:@"PARTICIPATING IN THE WORLD AROUND US"])
            {
                cell.backgroundColor = [UIColor colorWithRed:191.0/255 green:242.0/255 blue:239.0/255 alpha:1];
                _tableView.backgroundColor =[UIColor colorWithRed:191.0/255 green:242.0/255 blue:239.0/255 alpha:1];
            }
            else if ([lblHeader.text isEqual:@"MEETING NOTABLES"])
            {
                cell.backgroundColor = [UIColor colorWithRed:245.0/255 green:191.0/255 blue:233.0/255 alpha:1];
                _tableView.backgroundColor = [UIColor colorWithRed:245.0/255 green:191.0/255 blue:233.0/255 alpha:1];
            }
            else if ([lblHeader.text isEqual:@"CELEBRATING SIGNIFICANT OCCASIONS"])
            {
                cell.backgroundColor = [UIColor colorWithRed:255.0/255 green:191.0/255 blue:192.0/255 alpha:1];
                _tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:191.0/255 blue:192.0/255 alpha:1];;
            }
            else if ([lblHeader.text   isEqual:@"REPAIRING THE WORLD - TIKKUN OLAM"])
            {
                cell.backgroundColor = [UIColor colorWithRed:155.0/255 green:158.0/255 blue:212.0/255 alpha:1];
                _tableView.backgroundColor =[UIColor colorWithRed:155.0/255 green:158.0/255 blue:212.0/255 alpha:1];
            }
            else if ([lblHeader.text isEqual:@"BLESSINGS BEFORE EATING"])
            {
                cell.backgroundColor = [UIColor colorWithRed:236.0/255 green:215.0/255 blue:195.0/255 alpha:1];
                _tableView.backgroundColor = [UIColor colorWithRed:236.0/255 green:215.0/255 blue:195.0/255 alpha:1];
            }
            else if ([lblHeader.text isEqual:@"BLESSINGS AFTER EATING"])
            {
                cell.backgroundColor = [UIColor colorWithRed:192.0/255 green:229.0/255 blue:203.0/255 alpha:1];
                _tableView.backgroundColor = [UIColor colorWithRed:192.0/255 green:229.0/255 blue:203.0/255 alpha:1];;
            }
            else if ([lblHeader.text isEqual:@"TRAVELER’S PRAYER"])
            {
                cell.backgroundColor = [UIColor colorWithRed:235.0/255 green:230.0/255 blue:203.0/255 alpha:1];
                _tableView.backgroundColor = [UIColor colorWithRed:235.0/255 green:230.0/255 blue:203.0/255 alpha:1];
            }
            
            
        }
        
        else
            cell.backgroundColor = [UIColor whiteColor];

        
        
        
        
        
        
      /*  if ([lblHeader.text isEqual:@"Bookmarked Blessings"]) {
            cell.backgroundColor = [UIColor redColor];
        }
        else if ([lblHeader.text isEqual:@"All Blessings"])
        {
            cell.backgroundColor = [UIColor greenColor];
        }
        else if ([lblHeader.text isEqual:@"ENCOUNTERING NATURE"])
        {
            cell.backgroundColor = [UIColor grayColor];
        }
        else
        {
            cell.backgroundColor = [UIColor blueColor];
        }*/
        
        
        cell.textLabel.text = cellValue;
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellValue=nil;
	}
	else
	{
		alphabet = [indices objectAtIndex:[indexPath section]];
		
		//---get all states beginning with the letter---
		predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
        flashCards = [cards filteredArrayUsingPredicate:predicate];
		
		if ([flashCards count]>0) {
			//---extract the relevant state from the states object---
			NSString *cellValue = [flashCards objectAtIndex:indexPath.row];
			cell.textLabel.text = cellValue;
			cell.textLabel.numberOfLines = 0;
			cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;        
           
		}
	}

    return cell;
}



//---set the index for the table---
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return indices;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableArray* deckArray;
	NSUInteger row = 0;
	if ([_source isEqualToString:@"DeckCard"]) {
		deckArray = [cards retain];
		row = indexPath.row;
        [cards release];
        }
    
	else
	{
		deckArray=[[AppDelegate_iPad getDBAccess] getFlashCardForQuery:SELECT_Alphabetical_DECK_CARD_QUERY];
		// Calculate Row index.
		NSUInteger sect = indexPath.section;
		for (NSUInteger i = 0; i < sect; ++ i)
			row += [_tableView numberOfRowsInSection:i];
		row += indexPath.row;
	}
	[_parentView showDetailViewWithArray:deckArray cardIndex:row caller:@"index"];  	
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
    
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    [_myButton release];
	[super dealloc];  
}


- (void)viewDidUnload {
    [self setMyButton:nil];
    [super viewDidUnload];
}
@end

