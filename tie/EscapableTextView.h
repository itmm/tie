//
//  EscapableTextView.h
//  tie
//
//  Created by Timm on 07.05.16.
//  Copyright © 2016 Timm Knape Softwaretechnik. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Node.h"

@interface EscapableTextView : NSTextView

    @property (nonatomic) Node *node;
    
@end
