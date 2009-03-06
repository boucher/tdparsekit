
@import "TDTerminal.j"

@implementation TDWord : TDTerminal 
{
}

+ (id)word 
{
    return [[self alloc] initWithString:nil];
}

- (BOOL)qualifies:(id)obj 
{
    return obj.isWord;
}

@end

@implementation TDQuotedString : TDTerminal 
{
}

+ (id)quotedString 
{
    return [[self alloc] initWithString:nil];
}

- (BOOL)qualifies:(id)obj 
{
    return obj.isQuotedString;
}

@end

@implementation TDNum : TDTerminal 
{
}

+ (id)num 
{
    return [[self alloc] initWithString:nil];
}

- (BOOL)qualifies:(id)obj 
{
    return obj.isNumber;
}

@end

@implementation TDSymbol : TDTerminal 
{
    TDToken symbol;
}

+ (id)symbol 
{
    return [[self alloc] initWithString:nil];
}

+ (id)symbolWithString:(CPString)s 
{
    return [[self alloc] initWithString:s];
}

- (id)initWithString:(CPString)s 
{
    self = [super initWithString:s];
    if (self) {
        if (s.length) {
            self.symbol = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:s floatValue:0.0];
        }
    }
    return self;
}

- (BOOL)qualifies:(id)obj 
{
    if (symbol) {
        return [symbol isEqual:obj];
    } else {
        return obj.isSymbol;
    }
}

- (CPString)description 
{
    var className = [[self className] substringFromIndex:2];
    if (name.length) {
        if (symbol) {
            return [CPString stringWithFormat:@"%@ (%@) %@", className, name, symbol.stringValue];
        } else {
            return [CPString stringWithFormat:@"%@ (%@)", className, name];
        }
    } else {
        if (symbol) {
            return [CPString stringWithFormat:@"%@ %@", className, symbol.stringValue];
        } else {
            return [CPString stringWithFormat:@"%@", className];
        }
    }
}

@end

@implementation TDComment : TDTerminal 
{
}

+ (id)comment 
{
    return [[self alloc] initWithString:nil];
}


- (BOOL)qualifies:(id)obj 
{
    return obj.isComment;
}

@end


@implementation TDLiteral : TDTerminal 
{
    TDToken literal;
}

+ (id)literalWithString:(CPString)s 
{
    return [[self alloc] initWithString:s];
}


- (id)initWithString:(CPString)s 
{
    self = [super initWithString:s];
    if (self) {
        self.literal = [TDToken tokenWithTokenType:TDTokenTypeWord stringValue:s floatValue:0.0];
    }
    return self;
}

- (BOOL)qualifies:(id)obj 
{
    return [literal.stringValue isEqualToString:[obj stringValue]];
    //return [literal isEqual:obj];
}

- (CPString)description 
{
    var className = [[self className] substringFromIndex:2];
    if (name.length) {
        return [CPString stringWithFormat:@"%@ (%@) %@", className, name, literal.stringValue];
    } else {
        return [CPString stringWithFormat:@"%@ %@", className, literal.stringValue];
    }
}

@end

@implementation TDCaseInsensitiveLiteral : TDLiteral 
{
}

- (BOOL)qualifies:(id)obj 
{
    return CPOrderedSame == [literal.stringValue caseInsensitiveCompare:[obj stringValue]];
}

@end

@implementation TDAny : TDTerminal 
{
}

+ (id)any 
{
    return [[self alloc] initWithString:nil];
}

- (BOOL)qualifies:(id)obj 
{
    return [obj isKindOfClass:[TDToken class]];
}

@end
