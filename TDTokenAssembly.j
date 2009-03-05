
@import "TDAssembly.j"
@import "TDTokenizer.j"
@import "TDToken.j"

@implementation TDTokenAssembly : TDAssembly
{
    TDTokenizer     tokenizer;
    CPArray         tokens;
    BOOL            preservesWhitespaceTokens;
}

+ (id)assemblyWithTokenizer:(TDTokenizer)t 
{
    return [[self alloc] initWithTokenzier:t];
}

- (id)initWithTokenzier:(TDTokenizer)t 
{
    return [self initWithString:t.string tokenzier:t tokenArray:nil];
}

+ (id)assemblyWithTokenArray:(CPArray)a 
{
    return [[self alloc] initWithTokenArray:a];
}

- (id)initWithTokenArray:(CPArray)a 
{
    return [self initWithString:[a componentsJoinedByString:@""] tokenzier:nil tokenArray:a];
}

- (id)initWithString:(CPString)s 
{
    return [self initWithTokenzier:[[TDTokenizer alloc] initWithString:s]];
}

// designated initializer. this method is private and should not be called from other classes
- (id)initWithString:(CPString)s tokenzier:(TDTokenizer)t tokenArray:(CPArray)a 
{
    if (self = [super initWithString:s]) {
        if (t) 
            tokenizer = t;
        else 
            tokens = a;
    }

    return self;
}

- (id)copy 
{
    var a = [super copy];

    a.tokens = [[self tokens] copy];
    a.preservesWhitespaceTokens = preservesWhitespaceTokens;

    return a;
}

- (CPArray)tokens 
{
    if (!tokens)
        [self tokenize];

    return tokens;
}

- (id)peek 
{
    var tok = nil;
    
    while (1) 
    {
        if (index >= [[self tokens] count]) {
            tok = nil;
            break;
        }
        
        tok = [self tokens][index];
        if (!preservesWhitespaceTokens)
            break;

        if (TDTokenTypeWhitespace == tok.tokenType) {
            [self push:tok];
            index++;
        }
        else
            break;
    }
    
    return tok;
}

- (id)next 
{
    var tok = [self peek];

    if (tok)
        index++;

    return tok;
}

- (BOOL)hasMore 
{
    return (index < [[self tokens] count]);
}

- (unsigned)length 
{
    return [[self tokens] count];
} 

- (unsigned)objectsConsumed 
{
    return index;
}

- (unsigned)objectsRemaining 
{
    return ([[self tokens] count] - index);
}

- (CPString)consumedObjectsJoinedByString:(CPString)delimiter 
{
    return [self objectsFrom:0 to:[self objectsConsumed] separatedBy:delimiter];
}

- (CPString)remainingObjectsJoinedByString:(CPString)delimiter 
{
    return [self objectsFrom:[self objectsConsumed] to:[self length] separatedBy:delimiter];
}

- (void)tokenize 
{
    if (!tokenizer)
        return;
    
    var a = [],
        eof = [TDToken EOFToken],
        tok = nil;
    
    while ((tok = [tokenizer nextToken]) != eof) {
        [a addObject:tok];
    }

    tokens = a;
}


- (CPString)objectsFrom:(unsigned)start to:(unsigned)end separatedBy:(CPString)delimiter 
{
    var s = "",
        i = start;

    for ( ; i < end; i++) {
        var tok = [self tokens][i];
        s += [tok stringValue];

        if (end - 1 != i)
            s += delimiter;
    }

    return s;
}

@end
