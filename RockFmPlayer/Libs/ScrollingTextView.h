#import <Cocoa/Cocoa.h>
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