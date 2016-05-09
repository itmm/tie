#import <Cocoa/Cocoa.h>

#import "EscapableTextView.h"

@interface NavigationView : NSView <NSTextViewDelegate>

@property (nonatomic) IBOutlet EscapableTextView *textView;

@end
