#import "Node.h"

@interface Node ()

    - (NSAttributedString *) evaluateFrom: (const char *) begin end: (const char *) end;

@end

NSInteger expression(const char **begin, const char *end);

NSInteger factor(const char **begin, const char *end) {
    for (; *begin != end && **begin <= ' '; *begin += 1);
    if (*begin == end) { return 0; }
    if (isdigit(**begin) || **begin == '-') {
        int factor = 1;
        if (**begin == '-') { *begin += 1; factor = -1; }
        int num = 0;
        while (*begin != end && isdigit(**begin)) {
            num = num * 10 + (**begin - '0');
            *begin += 1;
        }
        return num * factor;
    } else if (**begin == ')') {
        *begin += 1;
        NSInteger result = expression(begin, end);
        if (*begin != end && **begin == ')') { *begin += 1; }
        return result;
    }
    return 0;
}

NSInteger term(const char **begin, const char *end) {
    NSInteger prod = factor(begin, end);
    while (*begin != end) {
        for (; *begin != end && **begin <= ' '; *begin += 1);
        if (*begin == end) { break; }
        char op = **begin;
        if (op != '*' && op != '/' && op != '%') { break; }
        *begin += 1;
        NSInteger next = factor(begin, end);
        switch (op) {
            case '*': prod *= next; break;
            case '/': if (next) { prod /= next; } break;
            case '%': if (next) { prod %= next; } break;
        }
    }
    return prod;
}

NSInteger expression(const char **begin, const char *end) {
    NSInteger sum = term(begin, end);
    while (*begin != end) {
        for (; *begin != end && **begin <= ' '; *begin += 1);
        if (*begin == end) { break; }
        char op = **begin;
        if (op != '+' && op != '-') { break; }
        *begin += 1;
        NSInteger next = term(begin, end);
        switch (op) {
            case '+': sum += next; break;
            case '-': sum -= next; break;
        }
    }
    return sum;
}

@implementation Node

    - (void)setSource:(NSString *)source {
        _source = source;
    }

    - (NSAttributedString *) interpretFrom: (const char *) begin end: (const char *) end {
        if (isdigit(*begin) || *begin == '-' || *begin == '(') {
            NSInteger result = expression(&begin, end);
            NSNumber *number = [NSNumber numberWithInteger: result];
            NSNumberFormatter *formatter = NSNumberFormatter.new;
            NSAttributedString *attr = [[NSAttributedString alloc] initWithString:[formatter stringFromNumber: number]];
            return attr;
        } else if (memcmp("bold ", begin, 5) == 0) {
            NSAttributedString *sub = [self evaluateFrom: begin + 5 end: end];
            NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithAttributedString: sub];
            [result addAttribute: NSFontAttributeName value: [NSFont boldSystemFontOfSize: 12] range: NSMakeRange(0, sub.length)];
            return result;
        } else return NSAttributedString.new;
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
