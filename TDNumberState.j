
@import "TDTokenizerState.j"

@implementation TDNumberState : TDTokenizerState 
{
    BOOL    allowsTrailingDot;
    BOOL    gotADigit;
    BOOL    negative;
    int     c;
    float   floatValue;
}

- (TDToken)nextTokenFromReader:(TDReader)r startingWith:(int)cin tokenizer:(TDTokenizer)t 
{
    [self reset];

    negative = NO;
    
    var originalCin = cin;
    
    if ('-' == cin) {
        negative = YES;
        cin = [r read];
        [self append:'-'];
    } else if ('+' == cin) {
        cin = [r read];
        [self append:'+'];
    }
    
    [self reset:cin];
    
    if ('.' == c) {
        [self parseRightSideFromReader:r];
    } else {
        [self parseLeftSideFromReader:r];
        [self parseRightSideFromReader:r];
    }
    
    // erroneous ., +, or -
    if (!gotADigit) {
        if (negative && -1 != c) { // ??
            [r unread];
        }
        return [t.symbolState nextTokenFromReader:r startingWith:originalCin tokenizer:t];
    }
    
    if (-1 != c) {
        [r unread];
    }

    if (negative) {
        floatValue = -floatValue;
    }
    
    return [TDToken tokenWithTokenType:TDTokenTypeNumber stringValue:[self bufferedString] floatValue:[self value]];
}

- (float)value 
{
    return floatValue;
}

- (float)absorbDigitsFromReader:(TDReader)r isFraction:(BOOL)isFraction 
{
    var divideBy = 1.0,
        v = 0.0;
    
    while (1) {
        if (isdigit(c)) {
            [self append:c];
            gotADigit = YES;
            v = v * 10.0 + (c - '0');
            c = [r read];
            if (isFraction) {
                divideBy *= 10.0;
            }
        } else {
            break;
        }
    }
    
    if (isFraction) {
        v = v / divideBy;
    }

    return v;
}

- (void)parseLeftSideFromReader:(TDReader)r 
{
    floatValue = [self absorbDigitsFromReader:r isFraction:NO];
}


- (void)parseRightSideFromReader:(TDReader)r 
{
    if ('.' == c) 
    {
        var n = [r read],
            nextIsDigit = isdigit(n);

        if (-1 != n)
            [r unread];

        if (nextIsDigit || allowsTrailingDot) {
            [self append:'.'];
            if (nextIsDigit) {
                c = [r read];
                floatValue += [self absorbDigitsFromReader:r isFraction:YES];
            }
        }
    }
}

- (void)reset:(int)cin 
{
    gotADigit = NO;
    floatValue = 0.0;
    c = cin;
}

@end
