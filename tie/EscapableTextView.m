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
    if (event.keyCode == 53) {
        self.editable = NO;
        self.node.source = [NSString stringWithString: self.string];
        [self.textStorage replaceCharactersInRange:NSMakeRange(0, self.string.length) withAttributedString:self.node.evaluated];
    } else {
        [super keyDown: event];
    }
}

@end
