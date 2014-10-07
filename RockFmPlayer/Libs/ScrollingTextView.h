#import <Cocoa/Cocoa.h>

#define kSpacing 20

@interface ScrollingTextView : NSView {
    NSTimer * scroller;
    NSPoint point;
    NSString * text;
    NSTimeInterval speed;
    CGFloat stringWidth;
}

@property (nonatomic, copy) NSString * text;
@property (nonatomic) NSTimeInterval speed;

@end