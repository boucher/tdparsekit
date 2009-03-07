
@import "TDSymbolNode.j"

@implementation TDSymbolRootNode : TDSymbolNode 
{
}

- (id)init 
{
    return self = [super initWithParent:nil character:-1];
}

- (void)add:(CPString)s 
{
    if (s.length < 2) return;
    
    [self addWithFirst:[s characterAtIndex:0] rest:[s substringFromIndex:1] parent:self];
}

- (void)remove:(CPString)s 
{
    if (s.length < 2) return;
    
    [self removeWithFirst:[s characterAtIndex:0] rest:[s substringFromIndex:1] parent:self];
}

- (void)addWithFirst:(int)c rest:(CPString)s parent:(TDSymbolNode)p 
{
    var key = c,
        child = [p.children objectForKey:key];

    if (!child) {
        child = [[TDSymbolNode alloc] initWithParent:p character:c];
        [p.children setObject:child forKey:key];
    }

    var rest = nil;
    
    if (0 == s.length) {
        return;
    } else if (s.length > 1) {
        rest = [s substringFromIndex:1];
    }
    
    [self addWithFirst:[s characterAtIndex:0] rest:rest parent:child];
}

- (void)removeWithFirst:(int)c rest:(CPString)s parent:(TDSymbolNode)p 
{
    var key = c,
        child = [p.children objectForKey:key];

    if (child) {
        var rest = nil;
        
        if (0 == s.length) {
            return;
        } else if (s.length > 1) {
            rest = [s substringFromIndex:1];
            [self removeWithFirst:[s characterAtIndex:0] rest:rest parent:child];
        }
        
        [p.children removeObjectForKey:key];
    }
}

- (CPString)nextSymbol:(TDReader)r startingWith:(int)cin 
{
    return [self nextWithFirst:cin rest:r parent:self];
}


- (CPString)nextWithFirst:(int)c rest:(TDReader)r parent:(TDSymbolNode)p 
{
    var result = [CPString stringWithFormat:@"%C", c];

    // this also works.
//    NSString *result = [[[NSString alloc] initWithCharacters:(const unichar *)&c length:1] autorelease];
    
    // none of these work.
    //NSString *result = [[[NSString alloc] initWithBytes:&c length:1 encoding:NSUTF8StringEncoding] autorelease];

//    NSLog(@"c: %d", c);
//    NSLog(@"string for c: %@", result);
//    NSString *chars = [[[NSString alloc] initWithCharacters:(const unichar *)&c length:1] autorelease];
//    NSString *utfs  = [[[NSString alloc] initWithUTF8String:(const char *)&c] autorelease];
//    NSString *utf8  = [[[NSString alloc] initWithBytes:&c length:1 encoding:NSUTF8StringEncoding] autorelease];
//    NSString *utf16 = [[[NSString alloc] initWithBytes:&c length:1 encoding:NSUTF16StringEncoding] autorelease];
//    NSString *ascii = [[[NSString alloc] initWithBytes:&c length:1 encoding:NSASCIIStringEncoding] autorelease];
//    NSString *iso   = [[[NSString alloc] initWithBytes:&c length:1 encoding:NSISOLatin1StringEncoding] autorelease];
//
//    NSLog(@"chars: '%@'", chars);
//    NSLog(@"utfs: '%@'", utfs);
//    NSLog(@"utf8: '%@'", utf8);
//    NSLog(@"utf16: '%@'", utf16);
//    NSLog(@"ascii: '%@'", ascii);
//    NSLog(@"iso: '%@'", iso);
    
    var key = c,
        child = [p.children objectForKey:key];
    
    if (!child) {
        if (p == self) {
            return result;
        } else {
            [r unread];
            return @"";
        }
    } 
    
    c = [r read];
    if (-1 == c) {
        return result;
    }
    
    return [result stringByAppendingString:[self nextWithFirst:c rest:r parent:child]];
}

- (CPString)description 
{
    return @"<TDSymbolRootNode>";
}

@end
