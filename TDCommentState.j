
@import "TDTokenizerState.j"
@import "TDToken.j"
@import "TDReader.j"
@import "TDSymbolRootNode.j"
@import "TDMultiLineCommentState.j"
@import "TDSingleLineCommentState.j"

@implementation TDCommentState : TDTokenizerState 
{
    TDSymbolRootNode            rootNode;
    TDSingleLineCommentState    singleLineState;
    TDMultiLineCommentState     multiLineState;
    
    BOOL reportsCommentTokens;
    BOOL balancesEOFTerminatedComments;
}

- (id)init 
{
    self = [super init];
    if (self) {
        rootNode = [[TDSymbolRootNode alloc] init];
        singleLineState = [[TDSingleLineCommentState alloc] init];
        multiLineState = [[TDMultiLineCommentState alloc] init];
    }
    return self;
}

- (void)addSingleLineStartSymbol:(CPString)start 
{
    [rootNode add:start];
    [singleLineState addStartSymbol:start];
}

- (void)removeSingleLineStartSymbol:(CPString)start 
{
    [rootNode remove:start];
    [singleLineState removeStartSymbol:start];
}

- (void)addMultiLineStartSymbol:(CPString)start endSymbol:(CPString)end 
{
    [rootNode add:start];
    [rootNode add:end];
    [multiLineState addStartSymbol:start endSymbol:end];
}

- (void)removeMultiLineStartSymbol:(CPString)start 
{
    [rootNode remove:start];
    [multiLineState removeStartSymbol:start];
}

- (TDToken)nextTokenFromReader:(TDReader)r startingWith:(int)cin tokenizer:(TDTokenizer)t 
{
    var symbol = [rootNode nextSymbol:r startingWith:cin];

    if ([multiLineState.startSymbols containsObject:symbol]) {
        multiLineState.currentStartSymbol = symbol;
        return [multiLineState nextTokenFromReader:r startingWith:cin tokenizer:t];
    } else if ([singleLineState.startSymbols containsObject:symbol]) {
        singleLineState.currentStartSymbol = symbol;
        return [singleLineState nextTokenFromReader:r startingWith:cin tokenizer:t];
    } else {
        for (var i=0, length = symbol.length ; i < symbol.length - 1; i++) {
            [r unread];
        }
        return [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:[CPString stringWithFormat:@"%C", cin] floatValue:0.0];
    }
}

@end
