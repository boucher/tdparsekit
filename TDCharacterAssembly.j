
@import "TDAssembly.j"

@implementation TDCharacterAssembly : TDAssembly 
{
}

- (id)init 
{
    return [self initWithString:nil];
}

- (id)initWithString:(CPString)s 
{
    self = [super initWithString:s];
    if (self) {
        defaultDelimiter = @"";
    }
    return self;
}

- (id)peek 
{
    if (index >= string.length) {
        return nil;
    }

    return [string characterAtIndex:index];
}

- (id)next 
{
    var obj = [self peek];
    if (obj !== nil && obj !== undefined) {
        index++;
    }
    return obj;
}

- (BOOL)hasMore 
{
    return (index < string.length);
}

- (int)length 
{
    return string.length;
} 

- (int)objectsConsumed 
{
    return index;
}

- (int)objectsRemaining 
{
    return (string.length - index);
}

- (CPString)consumedObjectsJoinedByString:(CPString)delimiter 
{
    return [string substringToIndex:self.objectsConsumed];
}

- (CPString)remainingObjectsJoinedByString:(CPString)delimiter 
{
    return [string substringFromIndex:self.objectsConsumed];
}

// overriding simply to print NSNumber objects as their unichar values
- (CPString)description 
{
    var s = "[";
    
    var i = 0,
        len = stack.length;
    
    for (; i<len; i++) {
        if ([obj isKindOfClass:[CPNumber class]]) { // ***this is needed for Char Assemblies
            s += sprintf(@"%C", [obj integerValue]);
        } else {
            s += [obj description];
        }
        if (len - 1 != i++) {
            s += ", ";
        }
    }

    s += "]";
    
    s += [self consumedObjectsJoinedByString:self.defaultDelimiter];
    s += @"^";
    s += [self remainingObjectsJoinedByString:self.defaultDelimiter];
    
    return s;
}

@end
