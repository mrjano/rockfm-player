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
#define METADATA_URL @"http://player.rockfm.fm/rdsrock.php"
#define DEFAULT_VOLUME 0.5
#define TEXT_SPEED 0.05

typedef enum
{
    BUTTON_LOADING = 0,
    BUTTON_PLAY,
    BUTTON_STOP
} MediaButtonState;

@interface RockFMWindowController () {
    AudioStreamer *streamer;
    MediaButtonState buttonStatus;
    NSTimer *metadataTimer;
}

@end

@implementation RockFMWindowController

- (id)init
{
    self = [super init];
    if (self) {
        buttonStatus = BUTTON_PLAY;
        metadataTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(getSongMetadata) userInfo:nil repeats:YES];
        [metadataTimer fire];
    }
    return self;
}

- (void) awakeFromNib {
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    //self.statusBar.title = @"G";
    
    // you can also set an image
    self.statusBar.image = [NSImage imageNamed:@"menubar_icon"];
    
    _statusBar.menu = _topBarMenu;
    self.statusBar.highlightMode = YES;
    
    [_btnMedia setEnabled:YES];
    [_sliderVolume setDoubleValue:DEFAULT_VOLUME*100];
}

-(void)startStreamer {
    if(streamer == nil) {
        streamer = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:URL]];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(playbackStateChanged:)
         name:ASStatusChangedNotification
         object:streamer];
        [streamer setVolume:DEFAULT_VOLUME];
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
        [_btnMedia setEnabled:NO];
    }
    else {
        [_btnMedia setEnabled:YES];
    }
}

- (void)getSongMetadata {
    NSURL *url = [NSURL URLWithString:METADATA_URL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error,%@", [error localizedDescription]);
        }
        else
        {
            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
            NSString* songName = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            songName = [songName componentsSeparatedByString:@"@"][0];
            songName = [songName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            songName = [[songName stringByReplacingOccurrencesOfString:@":" withString:@" -"] capitalizedString];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [_txtTitle setText:songName];
                [_txtTitle setSpeed:TEXT_SPEED];
            }];
        }
    }];
}

#pragma mark - IBAction

- (IBAction)mediaPressed:(id)sender {
    if(buttonStatus == BUTTON_PLAY) {
        [self startStreamer];
    }
    if(buttonStatus == BUTTON_STOP) {
        [self stopStreamer];
    }
}
- (IBAction)sliderVolumeValueChanged:(id)sender {
    if(streamer != nil) {
        NSSlider *slider = sender;
        [streamer setVolume:slider.doubleValue/100.0];
    }
}
- (IBAction)showPressed:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [_playerWindow makeKeyAndOrderFront:nil];
}

- (IBAction)quitPressed:(id)sender {
    [NSApp terminate:self];
}


@end
