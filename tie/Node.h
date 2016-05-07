#import <Cocoa/Cocoa.h>

@interface Node : NSObject

    @property (nonatomic) NSString *source;
    @property (nonatomic, readonly) NSAttributedString *evaluated;
    @property (nonatomic) NSMutableArray *childs;
    @property (nonatomic, weak) Node *parent;
    
@end
