//
//  EscapableTextView.m
//  tie
//
//  Created by Timm on 07.05.16.
//  Copyright © 2016 Timm Knape Softwaretechnik. All rights reserved.
//

#import "EscapableTextView.h"

@implementation EscapableTextView

- (void) keyDown: (NSEvent *) event {
    if (self.editable && event.keyCode == 53) {
        self.editable = NO;
        self.node.source = [NSString stringWithString: self.string];
        [self.textStorage replaceCharactersInRange:NSMakeRange(0, self.string.length) withAttributedString:self.node.evaluated];
    } else if (self.editable && event.keyCode == 36 && self.selectedRange.length > 0) {
        NSString *selected = [self attributedSubstringForProposedRange:self.selectedRange actualRange:nil].string;
        Node *nd = Node.new;
        nd.source = selected;
        NSAttributedString *replacement = [[NSAttributedString alloc] initWithString: nd.evaluated.string];
        [self.textStorage replaceCharactersInRange:self.selectedRange withAttributedString: replacement];
    } else {
        [super keyDown: event];
    }
}

@end
