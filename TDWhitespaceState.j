
@import "TDTokenizerState.j"

@implementation TDWhitespaceState : TDTokenizerState 
{
    CPArray     whitespaceChars;
    BOOL        reportsWhitespaceTokens;
}

- (id)init 
{
    if (self = [super init]) 
    {
        whitespaceChars = [];

        for (var i=0, len=255; i <= len; i++) {
            [whitespaceChars addObject:NO];
        }
        
        [self setWhitespaceChars:YES from:0 to:255];
    }

    return self;
}

- (void)setWhitespaceChars:(BOOL)yn from:(unsigned)start to:(unsigned)end 
{
    var len = whitespaceChars.length;
    if (start > len || end > len || start < 0 || end < 0)
        [CPException raise:@"TDWhitespaceStateNotSupportedException" reason:@"TDWhitespaceState only supports setting word chars for chars in the latin1 set (under 256)"];

    for (var i=start ; i <= end; i++) {
        [whitespaceChars replaceObjectAtIndex:i withObject:yn];
    }
}

- (BOOL)isWhitespaceChar:(unsigned)cin 
{
    if (cin < 0 || cin > whitespaceChars.length - 1)
        return NO;

    return !![whitespaceChars objectAtIndex:cin];
}

- (TDToken)nextTokenFromReader:(TDReader)r startingWith:(unsigned)cin tokenizer:(TDTokenizer)t 
{
    if (reportsWhitespaceTokens)
        [self reset];
    
    var c = cin;
    while ([self isWhitespaceChar:c]) {
        if (reportsWhitespaceTokens)
            [self append:c];

        c = [r read];
    }

    if (-1 != c)
        [r unread];
    
    if (reportsWhitespaceTokens)
        return [TDToken tokenWithTokenType:TDTokenTypeWhitespace stringValue:[self bufferedString] floatValue:0.0];
    else
        return [t nextToken];
}

@end
