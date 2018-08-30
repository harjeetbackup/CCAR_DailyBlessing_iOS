//
//  DeckCell.m
//  FlashCardDB
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlashCard.h"

#import "DeckCell.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
@implementation DeckCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
	  flashCardDeck:(FlashCardDeck*) deck
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
		_deck = deck;
    }
    return self;
}

+ (UILabel*) createLabelWithRect:(CGRect)rect  withFontSize:(NSUInteger)fontSize onView:(UIView*) view
{
	UILabel* label = [[[UILabel alloc] initWithFrame:rect] autorelease];
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:fontSize];
	
	[view addSubview:label];
	
	return label;
}

+ (DeckCell*) creatCellViewWithFlashCardDeck:(FlashCardDeck*) deck withTextColor:(UIColor*) textColor
{
	DeckCell* cell = [[[DeckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil
									   flashCardDeck:deck] autorelease];
	
	UILabel* label = [DeckCell createLabelWithRect:CGRectMake(50, 6, 290, 40) withFontSize:14 onView:cell];
	label.text = deck.deckTitle;
	label.textColor = textColor;
	
	/*label = [DeckCell createLabelWithRect:CGRectMake(50, 25, 125, 25) withFontSize:12 onView:cell];
	label.text = [NSString stringWithFormat:@"%d Cards", deck.cardCount];
	label.textColor = textColor;*/
	if([[[Utils getValueForVar:kProficiencyEnable] lowercaseString] isEqualToString: @"yes"])
    {
	label = [DeckCell createLabelWithRect:CGRectMake(215, 25, 125, 25) withFontSize:12 onView:cell];
	label.text = [NSString stringWithFormat:@"Proficiency: %0.2f%@", deck.proficiency, @"%"];
	label.textColor = textColor;
	}
	UIImageView* imgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:deck.deckImage]] autorelease];
	imgView.frame = CGRectMake(15, 10, 30, 30);
	[cell addSubview:imgView];
	
	cell.accessoryView = [[[UIImageView alloc] initWithImage:
						   [UIImage imageNamed:@"arrow.png"]] autorelease];
	
	cell.backgroundColor= deck.deckColor;
	
	//cell.selectionStyle = UITableViewCellSelectionStyleNone;
  /*  UIView *bgColorView = [[[UIView alloc] init] autorelease];
    bgColorView.layer.cornerRadius = 10;
    [bgColorView setBackgroundColor:[Utils colorFromString:[Utils getValueForVar:kSelectedDeckColor]]];
    [cell setSelectedBackgroundView:bgColorView];*/
    
     
	return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];    
}


- (void)dealloc 
{
    [super dealloc];
}


@end
