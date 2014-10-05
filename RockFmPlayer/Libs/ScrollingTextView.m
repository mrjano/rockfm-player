#import "ScrollingTextView.h"

@implementation ScrollingTextView

@synthesize text;
@synthesize speed;

- (void) setText:(NSString *)newText {
    text = [newText copy];
    point = NSZeroPoint;
    
    stringWidth = [newText sizeWithAttributes:nil].width;
    
    if (scroller == nil && speed > 0 && text != nil) {
        scroller = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(moveText:) userInfo:nil repeats:YES];
    }
}

- (void) setSpeed:(NSTimeInterval)newSpeed {
    if (newSpeed != speed) {
        speed = newSpeed;
        
        [scroller invalidate];
        scroller = nil;
        if (speed > 0 && text != nil) {
            scroller = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(moveText:) userInfo:nil repeats:YES];
        }
    }
}

- (void) moveText:(NSTimer *)timer {
    point.x = point.x - 1.0f;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
    
    if (point.x + stringWidth < 0) {
        point.x += dirtyRect.size.width;
    }
    
    [text drawAtPoint:point withAttributes:nil];
    
    if (point.x < 0) {
        NSPoint otherPoint = point;
        otherPoint.x += dirtyRect.size.width;
        [text drawAtPoint:otherPoint withAttributes:nil];
    }
}

@end