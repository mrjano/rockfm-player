//
//  RockFMWindowController.h
//  RockFmPlayer
//
//  Created by Jano A. on 02/10/14.
//  Copyright (c) 2014 RotR. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ScrollingTextView.h"

@interface RockFMWindowController : NSWindowController
@property (strong) IBOutlet NSWindow *playerWindow;

@property (weak) IBOutlet NSButton *btnMedia;
@property (weak) IBOutlet NSButton *btnMediaLT;
@property (weak) IBOutlet NSSlider *sliderVolume;
@property (weak) IBOutlet NSSlider *sliderVolumeLT;
@property (weak) IBOutlet ScrollingTextView *txtTitle;
@property (weak) IBOutlet ScrollingTextView *txtTitleLT;
@property (strong) IBOutlet NSMenu *topBarMenu;
@property (strong, nonatomic) NSStatusItem *statusBar;



@property (strong) IBOutlet NSTextField *songList;


- (IBAction)btnMute:(id)sender;

- (IBAction)addSong:(id)sender;




@end
