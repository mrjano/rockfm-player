//
//  RockFMWindowController.m
//  RockFmPlayer
//
//  Created by Jano A. on 02/10/14.
//  Copyright (c) 2014 RotR. All rights reserved.
//

#import "RockFMWindowController.h"
#import "AudioStreamer.h"

#define URL @"http://c21livecdn001.cires21.com/playerrockandgol.mp3"

typedef enum
{
    BUTTON_LOADING = 0,
    BUTTON_PLAY,
    BUTTON_STOP
} MediaButtonState;

@interface RockFMWindowController () {
    AudioStreamer *streamer;
    MediaButtonState buttonStatus;
}

@end

@implementation RockFMWindowController

- (id)init
{
    self = [super init];
    if (self) {
        buttonStatus = BUTTON_PLAY;
        [_btnMedia setEnabled:YES];
    }
    return self;
}

-(void)startStreamer {
    if(streamer == nil) {
        streamer = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:URL]];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(playbackStateChanged:)
         name:ASStatusChangedNotification
         object:streamer];
    }
    [streamer start];
}

-(void)stopStreamer {
    [streamer stop];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:ASStatusChangedNotification
     object:streamer];
    streamer = nil;
    
}

- (void)playbackStateChanged:(NSNotification *)aNotification
{
    if ([streamer isWaiting] && buttonStatus != BUTTON_LOADING)
    {
        [self setButtonAsLoading:YES];
        buttonStatus = BUTTON_LOADING;
    }
    else if ([streamer isPlaying] && buttonStatus != BUTTON_STOP)
    {
        [_btnMedia setImage:[NSImage imageNamed:@"btn_stop"]];
        [self setButtonAsLoading:NO];
        buttonStatus = BUTTON_STOP;
    }
    else if ([streamer isIdle] && buttonStatus != BUTTON_PLAY)
    {
        [self stopStreamer];
        [_btnMedia setImage:[NSImage imageNamed:@"btn_play"]];
        [self setButtonAsLoading:NO];
        buttonStatus = BUTTON_PLAY;
    }
}

- (void)setButtonAsLoading:(BOOL)option {
    if(option) {
        [_btnMedia setAlphaValue:0];
    }
    else {
        [_btnMedia setAlphaValue:1];
    }
}

- (IBAction)mediaPressed:(id)sender {
    if(buttonStatus == BUTTON_PLAY) {
        [self startStreamer];
    }
    if(buttonStatus == BUTTON_STOP) {
        [self stopStreamer];
    }
}



@end
