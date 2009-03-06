
@import "TDTerminal.j"

@implementation TDChar : TDTerminal 
{
}

+ (id)char 
{
    return [[self alloc] initWithString:nil];
}

- (BOOL)qualifies:(id)obj 
{
    return YES;
}

@end

@implementation TDDigit : TDTerminal 
{
}

+ (id)digit 
{
    return [[self alloc] initWithString:nil];
}

- (BOOL)qualifies:(id)obj 
{
    var c = [obj integerValue];
    return String(c).match(/[0-9]/g);
}

@end

@implementation TDLetter : TDTerminal 
{
}

+ (id)letter
{
    return [[self alloc] initWithString:nil];
}

- (BOOL)qualifies:(id)obj 
{
    var c = [obj intValue];
    return (c > 65 && c < 91) || (c > 97 && c < 123);
}

@end

@implementation TDSpecificChar : TDTerminal 
{
}

+ (id)specificCharWithChar:(int)c 
{
    return [[self alloc] initWithSpecificChar:c];
}

- (id)initWithSpecificChar:(int)c 
{
    return [super initWithString:[CPString stringWithFormat:@"%C", c]];
}

- (BOOL)qualifies:(id)obj 
{
    var c = [obj integerValue];
    return c == [string characterAtIndex:0];
}

@end
