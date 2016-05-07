//
//  NavigationView.h
//  tie
//
//  Created by Timm on 07.05.16.
//  Copyright © 2016 Timm Knape Softwaretechnik. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "EscapableTextView.h"

@interface NavigationView : NSView <NSTextViewDelegate>

@property (nonatomic) IBOutlet EscapableTextView *textView;

@end
