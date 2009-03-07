
@import "TDParseKit.j"

@implementation TDTokenizer : CPObject 
{
    CPString            string;
    TDReader            reader;
    
    CPArray             tokenizerStates;
    
    TDNumberState       numberState;
    TDQuoteState        quoteState;
    TDCommentState      commentState;
    TDSymbolState       symbolState;
    TDWhitespaceState   whitespaceState;
    TDWordState         wordState;
}

+ (id)tokenizer 
{
    return [self tokenizerWithString:nil];
}

+ (id)tokenizerWithString:(CPString)s 
{
    return [[self alloc] initWithString:s];
}

- (id)init 
{
    return [self initWithString:nil];
}

- (id)initWithString:(CPString)s 
{
    if (self = [super init]) 
    {
        string = s;
        [self setReader:[[TDReader alloc] init]];
        
        numberState = [[TDNumberState alloc] init];
        quoteState = [[TDQuoteState alloc] init];
        commentState = [[TDCommentState alloc] init];
        symbolState = [[TDSymbolState alloc] init];
        whitespaceState = [[TDWhitespaceState alloc] init];
        wordState = [[TDWordState alloc] init];
        
        [symbolState add:@"<="];
        [symbolState add:@">="];
        [symbolState add:@"!="];
        [symbolState add:@"=="];
        
        [commentState addSingleLineStartSymbol:@"//"];
        [commentState addMultiLineStartSymbol:@"/*" endSymbol:@"*/"];
        
        tokenizerStates = [];
        
        [self addTokenizerState:whitespaceState from:   0 to: ' ']; // From:  0 to: 32    From:0x00 to:0x20
        [self addTokenizerState:symbolState     from:  33 to:  33];
        [self addTokenizerState:quoteState      from: '"' to: '"']; // From: 34 to: 34    From:0x22 to:0x22
        [self addTokenizerState:symbolState     from:  35 to:  38];
        [self addTokenizerState:quoteState      from:'\'' to:'\'']; // From: 39 to: 39    From:0x27 to:0x27
        [self addTokenizerState:symbolState     from:  40 to:  42];
        [self addTokenizerState:symbolState     from: '+' to: '+']; // From: 43 to: 43    From:0x2B to:0x2B
        [self addTokenizerState:symbolState     from:  44 to:  44];
        [self addTokenizerState:numberState     from: '-' to: '-']; // From: 45 to: 45    From:0x2D to:0x2D
        [self addTokenizerState:numberState     from: '.' to: '.']; // From: 46 to: 46    From:0x2E to:0x2E
        [self addTokenizerState:commentState    from: '/' to: '/']; // From: 47 to: 47    From:0x2F to:0x2F
        [self addTokenizerState:numberState     from: '0' to: '9']; // From: 48 to: 57    From:0x30 to:0x39
        [self addTokenizerState:symbolState     from:  58 to:  64];
        [self addTokenizerState:wordState       from: 'A' to: 'Z']; // From: 65 to: 90    From:0x41 to:0x5A
        [self addTokenizerState:symbolState     from:  91 to:  96];
        [self addTokenizerState:wordState       from: 'a' to: 'z']; // From: 97 to:122    From:0x61 to:0x7A
        [self addTokenizerState:symbolState     from: 123 to: 191];
        [self addTokenizerState:wordState       from: 192 to: 255]; // From:192 to:255    From:0xC0 to:0xFF
    }

    return self;
}

- (TDToken)nextToken 
{
    var c = [reader read],
        result = nil;
    
    if (-1 === c)
        result = [TDToken EOFToken];
    else 
    {
        var state = [self tokenizerStateFor:c];
        
        if (state)
            result = [state nextTokenFromReader:reader startingWith:c tokenizer:self];
        else
            result = [TDToken EOFToken];
    }
    
    return result;
}

- (void)addTokenizerState:(TDTokenizerState)state from:(unsigned)start to:(unsigned)end 
{
    for (var i=start; i <= end; i++) {
        [tokenizerStates addObject:state];
        //addObject(tokenizerStates, @selector(addObject:), state);
    }
}

- (void)setTokenizerState:(TDTokenizerState)state from:(unsigned)start to:(unsigned)end 
{
    for (var i = start; i <= end; i++) {
        [tokenizerStates replaceObjectAtIndex:i withObject:state];
        //relaceObject(tokenizerStates, @selector(replaceObjectAtIndex:withObject:), i, state);
    }
}

- (TDReader)reader 
{
    return reader;
}

- (void)setReader:(TDReader)r 
{
    if (reader != r) {
        reader = r
        reader.string = string;
    }
}

- (CPString)string 
{
    return string;
}

- (void)setString:(CPString)s 
{
    string = s;
    reader.string = string;
}

- (TDTokenizerState)tokenizerStateFor:(unsigned)c 
{
    if (c < 0 || c > 255) {
        if (c >= 0x19E0 && c <= 0x19FF) { // khmer symbols
            return symbolState;
        } else if (c >= 0x2000 && c <= 0x2BFF) { // various symbols
            return symbolState;
        } else if (c >= 0x2E00 && c <= 0x2E7F) { // supplemental punctuation
            return symbolState;
        } else if (c >= 0x3000 && c <= 0x303F) { // cjk symbols & punctuation
            return symbolState;
        } else if (c >= 0x3200 && c <= 0x33FF) { // enclosed cjk letters and months, cjk compatibility
            return symbolState;
        } else if (c >= 0x4DC0 && c <= 0x4DFF) { // yijing hexagram symbols
            return symbolState;
        } else if (c >= 0xFE30 && c <= 0xFE6F) { // cjk compatibility forms, small form variants
            return symbolState;
        } else if (c >= 0xFF00 && c <= 0xFFFF) { // hiragana & katakana halfwitdh & fullwidth forms, Specials
            return symbolState;
        } else {
            return wordState;
        }
    }

    return tokenizerStates[c];
}

@end
