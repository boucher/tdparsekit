
@import "TDToken.j"
@import "TDTokenizer.j"

@implementation TDTokenArraySource : CPObject 
{
    TDTokenizer tokenizer;
    CPString    delimiter;
    TDToken     nextToken;
}

- (id)init 
{
    return [self initWithTokenizer:nil delimiter:nil];
}

- (id)initWithTokenizer:(TDTokenizer)t delimiter:(CPString)s 
{
    if (self = [super init]) {
        tokenizer = t;
        delimiter = s;
    }
    return self;
}

- (BOOL)hasMore 
{
    if (!nextToken)
        nextToken = [tokenizer nextToken];

    return ([TDToken EOFToken] != nextToken);
}


- (CPArray)nextTokenArray 
{
    if (![self hasMore])
        return nil;
    
    var res = [nextToken],
        eof = [TDToken EOFToken],
        tok = nil;

    nextToken = nil;

    while ((tok = [tokenizer nextToken]) != eof) {
        if ([tok.stringValue isEqualToString:delimiter])
            break; // discard delimiter tok

        [res addObject:tok];
    }
    
    //return [[res copy] autorelease];
    return res; // optimization
}

@end
