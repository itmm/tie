#import "Node.h"

@interface Node ()

    - (NSAttributedString *) evaluateFrom: (const char *) begin end: (const char *) end;

@end

@implementation Node

    - (void)setSource:(NSString *)source {
        NSLog(@"setting source from %@ to %@", _source, source);
        _source = source;
    }

    - (NSAttributedString *) interpretFrom: (const char *) begin end: (const char *) end {
        if (memcmp("bold ", begin, 5) == 0) {
            NSAttributedString *sub = [self evaluateFrom: begin + 5 end: end];
            NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithAttributedString: sub];
            [result addAttribute: NSFontAttributeName value: [NSFont boldSystemFontOfSize: 12] range: NSMakeRange(0, sub.length)];
            return result;
        }
        return NSAttributedString.new;
    }

    - (NSAttributedString *) evaluateFrom: (const char *) begin end: (const char *) end {
    
        if (begin == end) { return NSAttributedString.new; }
        
        const char *cur;
        NSMutableAttributedString *result = NSMutableAttributedString.new;
        while (begin != end) {
            for (cur = begin; cur != end  && *cur != '{'; ++cur) {}
            if (cur != begin) {
                NSString *str = [[NSString alloc] initWithBytes:begin length: cur - begin encoding:NSUTF8StringEncoding];
                [result appendAttributedString: [[NSAttributedString alloc] initWithString: str]];
                begin = cur;
            }
            
            if (begin != end && *begin == '{') {
                const char *start = ++begin;
                for (int count = 1; begin != end && count; ++begin) {
                    switch (*begin) {
                        case '{': ++count; break;
                        case '}': --count; break;
                    }
                }
                [result appendAttributedString: [self interpretFrom: start end:begin - 1]];
            }
        }
        return result;
    }

    - (NSAttributedString *) evaluated {
        const char *begin = self.source.UTF8String;
        const char *end = begin + strlen(begin);
        return [self evaluateFrom: begin end: end];
    }

@end
