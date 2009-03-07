
@import "TDTokenizerState.j"

@implementation TDWordState : TDTokenizerState 
{
    CPArray wordChars;
}

- (id)init 
{
    if (self = [super init]) 
    {
        wordChars = [];

        for (var i=0, len=255 ; i <= len; i++) {
            [wordChars addObject:NO];
        }
        
        [self setWordChars:YES from: 'a' to: 'z'];
        [self setWordChars:YES from: 'A' to: 'Z'];
        [self setWordChars:YES from: '0' to: '9'];
        [self setWordChars:YES from: '-' to: '-'];
        [self setWordChars:YES from: '_' to: '_'];
        [self setWordChars:YES from:'\'' to:'\''];
        [self setWordChars:YES from: 192 to: 255];
    }

    return self;
}

- (void)setWordChars:(BOOL)yn from:(unsigned)start to:(unsigned)end 
{
    var len = wordChars.length;
    if (start > len || end > len || start < 0 || end < 0) {
        [CPException raise:@"TDWordStateNotSupportedException" reason:@"TDWordState only supports setting word chars for chars in the latin1 set (under 256)"];
    }
    
    for (var i=start ; i <= end; i++) {
        [wordChars replaceObjectAtIndex:i withObject:yn];
    }
}

- (BOOL)isWordChar:(unsigned)c 
{    
    if (c > -1 && c < wordChars.length - 1) {
        return (!![wordChars objectAtIndex:c]);
    }

    if (c >= 0x2000 && c <= 0x2BFF) { // various symbols
        return NO;
    } else if (c >= 0xFE30 && c <= 0xFE6F) { // general punctuation
        return NO;
    } else if (c >= 0xFE30 && c <= 0xFE6F) { // western musical symbols
        return NO;
    } else if (c >= 0xFF00 && c <= 0xFF65) { // symbols within Hiragana & Katakana
        return NO;            
    } else if (c >= 0xFFF0 && c <= 0xFFFF) { // specials
        return NO;        
    } else if (c < 0) {
        return NO;
    } else {
        return YES;
    }
}

- (TDToken)nextTokenFromReader:(TDReader)r startingWith:(unsigned)cin tokenizer:(TDTokenizer)t 
{
    [self reset];
    
    var c = cin;
    do {
        [self append:c];
        c = [r read];
    } while ([self isWordChar:c]);
    
    if (-1 != c)
        [r unread];
    
    return [TDToken tokenWithTokenType:TDTokenTypeWord stringValue:[self bufferedString] floatValue:0.0];
}

@end
