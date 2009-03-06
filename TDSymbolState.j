
@import "TDTokenizerState.j"

@implementation TDSymbolState : TDTokenizerState 
{
    TDSymbolRootNode    rootNode;
    CPArray             addedSymbols;
}

- (id)init 
{
    self = [super init];
    if (self) {
        rootNode = [[TDSymbolRootNode alloc] init];
        addedSymbols = [];
    }
    return self;
}

- (TDToken)nextTokenFromReader:(TDReader)r startingWith:(int)cin tokenizer:(TDTokenizer)t 
{
    var symbol = [rootNode nextSymbol:r startingWith:cin],
        len = symbol.length;

    if (0 == len || (len > 1 && [addedSymbols containsObject:symbol])) {
        return [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:symbol floatValue:0.0];
    } else {
        for (var i=0 ; i < len - 1; i++) {
            [r unread];
        }
        return [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:[CPString stringWithFormat:@"%C", cin] floatValue:0.0];
    }
}

- (void)add:(CPString)s 
{
    [rootNode add:s];
    [addedSymbols addObject:s];
}

- (void)remove:(CPString)s 
{
    [rootNode remove:s];
    [addedSymbols removeObject:s];
}

@end
