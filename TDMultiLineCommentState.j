
@import "TDTokenizerState.j"
@import "TDCommentState.j"
@import "TDToken.j"
@import "TDReader.j"

@implementation TDMultiLineCommentState : TDTokenizerState 
{
    CPArray  startSymbols;
    CPArray  endSymbols;
    CPString currentStartSymbol;
}

- (id)init 
{
    self = [super init];
    if (self) {
        startSymbols = [];
        endSymbols = [];
    }
    return self;
}

- (void)addStartSymbol:(CPString)start endSymbol:(CPString)end 
{
    [startSymbols addObject:start];
    [endSymbols addObject:end];
}

- (void)removeStartSymbol:(CPString)start 
{
    var i = [startSymbols indexOfObject:start];
    if (CPNotFound != i) {
        [startSymbols removeObject:start];
        [endSymbols removeObjectAtIndex:i]; // this should always be in range.
    }
}


- (void)unreadSymbol:(CPString)s fromReader:(TDReader)r 
{
    for (var i=0, len = s.length; i < len - 1; i++) {
        [r unread];
    }
}

- (TDToken)nextTokenFromReader:(TDReader)r startingWith:(int)cin tokenizer:(TDTokenizer)t 
{    
    var balanceEOF = t.commentState.balancesEOFTerminatedComments,
        reportTokens = t.commentState.reportsCommentTokens;

    if (reportTokens) {
        [self reset];
        [self appendString:currentStartSymbol];
    }
    
    var i = [startSymbols indexOfObject:currentStartSymbol],
        currentEndSymbol = [endSymbols objectAtIndex:i],
        e = [currentEndSymbol characterAtIndex:0];
    
    // get the definitions of all multi-char comment start and end symbols from the commentState
    var rootNode = t.commentState.rootNode, 
        c;

    while (1) {
        c = [r read];
        if (-1 == c) {
            if (balanceEOF) {
                [self appendString:currentEndSymbol];
            }
            break;
        }
        
        if (e == c) {
            var peek = [rootNode nextSymbol:r startingWith:e];
            if ([currentEndSymbol isEqualToString:peek]) {
                if (reportTokens) {
                    [self appendString:currentEndSymbol];
                }
                c = [r read];
                break;
            } else {
                [self unreadSymbol:peek fromReader:r];
                if (e != [peek characterAtIndex:0]) {
                    if (reportTokens) {
                        [self append:c];
                    }
                    c = [r read];
                }
            }
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
