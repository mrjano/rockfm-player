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
@property (weak) IBOutlet NSButton *btnMedia;
@property (weak) IBOutlet NSSlider *sliderVolume;
@property (weak) IBOutlet ScrollingTextView *txtTitle;

@end
