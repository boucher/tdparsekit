
@import "TDTokenizerState.j"

@implementation TDQuoteState : TDTokenizerState 
{
    BOOL balancesEOFTerminatedQuotes;
}

- (TDToken)nextTokenFromReader:(TDReader)r startingWith:(unsigned)cin tokenizer:(TDTokenizer)t 
{
    [self reset];
    [self append:cin];

    var c;
    do {
        c = [r read];
        if (-1 === c) {
            c = cin;
            if (balancesEOFTerminatedQuotes) {
                [self append:c];
            }
        } else {
            [self append:c];
        }
        
    } while (c !== cin);
    
    return [TDToken tokenWithTokenType:TDTokenTypeQuotedString stringValue:[self bufferedString] floatValue:0.0];
}

@end
