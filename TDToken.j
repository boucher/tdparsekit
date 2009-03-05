
//TDTokenType

TDTokenTypeEOF          = 0;
TDTokenTypeNumber       = 1;
TDTokenTypeQuotedString = 2;
TDTokenTypeSymbol       = 3;
TDTokenTypeWord         = 4;
TDTokenTypeWhitespace   = 5;
TDTokenTypeComment      = 6;

@implementation TDToken : CPObject 
{
    float       floatValue;
    CPString    stringValue;
    TDTokenType tokenType;
    
    BOOL        number;
    BOOL        quotedString;
    BOOL        symbol;
    BOOL        word;
    BOOL        whitespace;
    BOOL        comment;
    
    id          value;
}

+ (TDToken)EOFToken 
{
    return [TDTokenEOF instance];
}

+ (id)tokenWithTokenType:(TDTokenType)t stringValue:(CPString)s floatValue:(float)n 
{
    return [[self alloc] initWithTokenType:t stringValue:s floatValue:n];
}

// designated initializer
- (id)initWithTokenType:(TDTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n 
{
    if (self = [super init]) {
        tokenType = t;
        stringValue = s;
        floatValue = n;
        
        number = (TDTokenTypeNumber == t);
        quotedString = (TDTokenTypeQuotedString == t);
        symbol = (TDTokenTypeSymbol == t);
        word = (TDTokenTypeWord == t);
        whitespace = (TDTokenTypeWhitespace == t);
        comment = (TDTokenTypeComment == t);
    }
    
    return self;
}

- (unsigned)hash 
{
    return [stringValue hash];
}


- (BOOL)isEqual:(id)rhv 
{
    return [self isEqual:rhv ignoringCase:NO];
}


- (BOOL)isEqualIgnoringCase:(id)rhv 
{
    return [self isEqual:rhv ignoringCase:YES];
}

- (BOOL)isEqual:(id)rhv ignoringCase:(BOOL)ignoringCase 
{
    if (![rhv isMemberOfClass:[TDToken class]])
        return NO;
    
    var tok = rhv;
    if (tokenType != tok.tokenType)
        return NO;
    
    if (number)
        return floatValue == tok.floatValue;
    else 
    {
        if (ignoringCase)
            return CPOrderedSame == [stringValue caseInsensitiveCompare:tok.stringValue];
        else
            return stringValue === tok.stringValue;
    }
}

- (id)value 
{
    if (!value) 
    {
        if (number)
            value = floatValue;
        else
            value = stringValue;
    }

    return value;
}

- (CPString)debugDescription
{
    /*
    var typeString = nil;
    if (self.isNumber) {
        typeString = @"Number";
    } else if (self.isQuotedString) {
        typeString = @"Quoted String";
    } else if (self.isSymbol) {
        typeString = @"Symbol";
    } else if (self.isWord) {
        typeString = @"Word";
    } else if (self.isWhitespace) {
        typeString = @"Whitespace";
    } else if (self.isComment) {
        typeString = @"Comment";
    }
    return [NSString stringWithFormat:@"<%@ %C%@%C>", typeString, 0x00AB, self.value, 0x00BB];
    */
    return [self description];
}

- (CPString)description
{
    return stringValue;
}

@end

EOFToken = nil;

@implementation TDTokenEOF : TDToken 
{
}

+ (TDTokenEOF)instance 
{
    if (!EOFToken)
        EOFToken = [[self alloc] init]; 

    return EOFToken;
}

- (id)copy 
{
    return self;
}

- (CPString)description 
{
    return [CPString stringWithFormat:@"<TDTokenEOF %p>", self];
}

- (CPString)debugDescription
{
    return [self description];
}

@end
