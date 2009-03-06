
@import "TDTokenizerState.j"
@import "TDCommentState.j"
@import "TDToken.j"
@import "TDReader.j"

@implementation TDSingleLineCommentState : TDTokenizerState 
{
    CPArray     startSymbols;
    CPString    currentStartSymbol;
}

- (id)init 
{
    if (self = [super init]) {
        startSymbols = [];
    }

    return self;
}

- (void)addStartSymbol:(CPString)start 
{
    [startSymbols addObject:start];
}


- (void)removeStartSymbol:(CPString)start 
{
    [startSymbols removeObject:start];
}


- (TDToken)nextTokenFromReader:(TDReader)r startingWith:(int)cin tokenizer:(TDTokenizer)t 
{
    var reportTokens = t.commentState.reportsCommentTokens;

    if (reportTokens) {
        [self reset];
        if (currentStartSymbol.length > 1) {
            [self appendString:currentStartSymbol];
        }
    }
    
    var c;
    while (1) {
        c = [r read];
        if ('\n' == c || '\r' == c || -1 == c) {
            break;
        }
        if (reportTokens) {
            [self append:c];
        }
    }
    
    if (-1 != c) {
        [r unread];
    }
    
    currentStartSymbol = nil;
    
    if (reportTokens) {
        return [TDToken tokenWithTokenType:TDTokenTypeComment stringValue:[self bufferedString] floatValue:0.0];
    } else {
        return [t nextToken];
    }
}

@end
