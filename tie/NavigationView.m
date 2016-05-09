#import "NavigationView.h"

@implementation NavigationView

- (void) keyUp: (NSEvent *) event {
    if (!self.textView.editable && [event.characters isEqualToString: @"e"]) {
        if (!self.textView.node) {
            self.textView.node = Node.new;
            self.textView.node.source = @"";
        }
        self.textView.editable = YES;
        [self.textView.textStorage replaceCharactersInRange: NSMakeRange(0, self.textView.string.length) withAttributedString:[NSAttributedString.alloc initWithString: self.textView.node.source]];
        [self.window makeFirstResponder: self.textView];
    }
}

@end
