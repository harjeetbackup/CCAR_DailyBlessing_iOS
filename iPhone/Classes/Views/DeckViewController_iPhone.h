//
//  DeckViewController.h
//  FlashCardDB
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FlashCardDeckList;

@interface DeckViewController_iPhone : UIViewController <UITableViewDelegate, 
												UITableViewDataSource, 
												UINavigationControllerDelegate,
												UIActionSheetDelegate>
{
	IBOutlet UITableView*	_tableView;
	FlashCardDeckList*		_cardDecks;

}

@property (nonatomic, retain) FlashCardDeckList*	cardDecks;

@property (retain, nonatomic) IBOutlet UIImageView *dailyBlessingImgView;
@property (retain, nonatomic) IBOutlet CustomToolBar *dailyBlessingToolBar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *indexButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *settingButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *helpButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *infoButton;
@property (retain, nonatomic) IBOutlet UILabel *coprrightLabel;
@property (retain, nonatomic) IBOutlet UITableView *blessingTable;
@property (retain, nonatomic) IBOutlet UIImageView *dailyBlessingImg;
@property (retain, nonatomic) IBOutlet UILabel *myLabelSeven;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *dailyBlessingsToolBarHeight;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *topSpaceForTitleView;

- (IBAction)displaySettings;
- (IBAction)displayHelp;
- (IBAction)displayInfo;
- (IBAction)showActionSheet;
- (IBAction)searchCards;
- (IBAction)cardIndex;

- (void)updateInfo;
- (void) publishToFacebook;
- (void) publishToTwitter;
- (void) myComments;
- (void) myVoiceNotes;

@end
