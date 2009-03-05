
@import <Foundation/Foundation.j>

@implementation TDReader : CPObject 
{
    CPString string;
    unsigned cursor;
    unsigned length;
}

- (id)init 
{
    return [self initWithString:nil];
}

- (id)initWithString:(CPString)s 
{
    if (self = [super init]) {
        [self setString:s];
    }
    
    return self;
}

- (CPString)string 
{
    return string;
}

- (void)setString:(CPString)s 
{
    if (string !== s) {
        string = s;
        length = string ? string.length : 0;
    }
    
    // reset cursor
    cursor = 0;
}

- (unsigned)read 
{
    if (0 === length || cursor > length - 1) {
        return -1;
    }
    
    return string.charAt(cursor++);
}

- (void)unread 
{
    cursor = (0 === cursor) ? 0 : cursor - 1;
}

@end
