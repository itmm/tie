#import "Node.h"

static void eat_whitespace(const char **begin, const char *end) {
    for (; *begin != end && **begin <= ' '; *begin += 1);
}

static NSInteger expression(const char **begin, const char *end);

static NSInteger factor(const char **begin, const char *end) {
    eat_whitespace(begin, end);
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
        eat_whitespace(begin, end);
        if (*begin != end && **begin == ')') { *begin += 1; }
        return result;
    }
    return 0;
}

static NSInteger term(const char **begin, const char *end) {
    NSInteger prod = factor(begin, end);
    while (*begin != end) {
        eat_whitespace(begin, end);
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

static NSInteger expression(const char **begin, const char *end) {
    NSInteger sum = term(begin, end);
    while (*begin != end) {
        eat_whitespace(begin, end);
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

static NSAttributedString *evaluate_text(const char **begin, const char *end);

static NSAttributedString *interpret_block(const char **begin, const char *end) {
    eat_whitespace(begin, end);
    if (*begin == end) { return NSAttributedString.new; }
    if (isdigit(**begin) || **begin == '-' || **begin == '(') {
        NSInteger result = expression(begin, end);
        NSNumber *number = [NSNumber numberWithInteger: result];
        NSNumberFormatter *formatter = NSNumberFormatter.new;
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:[formatter stringFromNumber: number]];
        eat_whitespace(begin, end);
        if (*begin != end && **begin == '}') { *begin += 1; }
        return attr;
    } else if (memcmp("bold ", *begin, 5) == 0) {
        *begin += 5;
        NSAttributedString *sub = evaluate_text(begin, end);
        NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithAttributedString: sub];
        [result addAttribute: NSFontAttributeName value: [NSFont boldSystemFontOfSize: 12] range: NSMakeRange(0, sub.length)];
        eat_whitespace(begin, end);
        if (*begin != end && **begin == '}') { *begin += 1; }
        return result;
    } else return NSAttributedString.new;
}

static NSAttributedString *evaluate_text(const char **begin, const char *end) {
    if (*begin == end) { return NSAttributedString.new; }
    
    const char *cur;
    NSMutableAttributedString *result = NSMutableAttributedString.new;
    while (*begin != end && **begin != '}') {
        for (cur = *begin; cur != end  && *cur != '{' && *cur != '}'; ++cur) {}
        if (cur != *begin) {
            NSString *str = [[NSString alloc] initWithBytes:*begin length: cur - *begin encoding:NSUTF8StringEncoding];
            [result appendAttributedString: [[NSAttributedString alloc] initWithString: str]];
            *begin = cur;
        }
        
        if (*begin != end && **begin == '{') {
            *begin += 1;
            [result appendAttributedString: interpret_block(begin, end)];
        }
    }
    return result;
}

@implementation Node

    - (void)setSource:(NSString *)source {
        _source = source;
    }

    - (NSAttributedString *) evaluated {
        const char *begin = self.source.UTF8String;
        const char *end = begin + strlen(begin);
        return evaluate_text(&begin, end);
    }

@end
