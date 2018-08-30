//
//  DeckCell.m
//  FlashCardDB
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlashCard.h"

#import "DeckCell_iPhone.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>

@implementation DeckCell_iPhone

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
	UILabel* label = [[UILabel alloc] initWithFrame:rect];
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:fontSize];

	[view addSubview:label];

	return [label autorelease];
}

+ (DeckCell_iPhone*) creatCellViewWithFlashCardDeck:(FlashCardDeck*) deck withTextColor:(UIColor*) textColor
{
	DeckCell_iPhone* cell = [[DeckCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil
										flashCardDeck:deck];
	
	UILabel* label = [DeckCell_iPhone createLabelWithRect:CGRectMake(50, 0, 230, 50) withFontSize:14 onView:cell];
	label.text = deck.deckTitle;
	label.textColor = textColor;
    label.numberOfLines = 0;
	label.lineBreakMode = UILineBreakModeWordWrap;
	/*label = [DeckCell_iPhone createLabelWithRect:CGRectMake(50, 25, 125, 25) withFontSize:12 onView:cell];
	label.text = [NSString stringWithFormat:@"%d Cards", deck.cardCount];
	label.textColor = textColor;*/
    if([[[Utils getValueForVar:kProficiencyEnable] lowercaseString] isEqualToString:@"yes"])
    {
	label = [DeckCell_iPhone createLabelWithRect:CGRectMake(155, 25, 125, 25) withFontSize:12 onView:cell];
	label.text = [NSString stringWithFormat:@"Proficiency: %0.2f%@", deck.proficiency, @"%"];
	label.textColor = textColor;
    }
    
	UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:deck.deckImage]];
	imgView.frame = CGRectMake(15, 10, 30, 28);
	[cell addSubview:imgView];
	
	cell.accessoryView = [[[UIImageView alloc] initWithImage:
									   [UIImage imageNamed:@"arrow.png"]] autorelease];

	cell.backgroundColor = deck.deckColor;
	
	//cell.selectionStyle = UITableViewCellSelectionStyleNone;
  /*  UIView *bgColorView = [[UIView alloc] init];
    bgColorView.layer.cornerRadius = 10;
    [bgColorView setBackgroundColor:[Utils colorFromString:[Utils getValueForVar:kSelectedDeckColor]]];
    [cell setSelectedBackgroundView:bgColorView];
    [bgColorView release];*/
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
