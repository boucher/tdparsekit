
@import "TDWord.j"

@implementation TDLowercaseWord : TDWord 
{
}

- (BOOL)qualifies:(id)obj 
{
    if (!obj.isWord)
        return NO;
    
    var s = obj.stringValue;
    return s.length && s.charAt(0) === s.charAt(0).toLowerCase();
}

@end

@implementation TDUppercaseWord : TDWord 
{
}

- (BOOL)qualifies:(id)obj 
{
    if (!obj.isWord)
        return NO;
    
    var s = obj.stringValue;
    return s.length && s.charAt(0) === s.charAt(0).toUpperCase();
}

@end

var sTDReservedWords = nil;

@implementation TDReservedWord : TDWord 
{
}

+ (CPArray)reservedWords 
{
    return sTDReservedWords;
}

+ (void)setReservedWords:(CPArray)inWords 
{
    if (inWords !== sTDReservedWords) {
        sTDReservedWords = [inWords copy];
    }
}

- (BOOL)qualifies:(id)obj 
{
    if (!obj.isWord)
        return NO;
    
    var s = obj.stringValue;
    return s.length && [[TDReservedWord reservedWords] containsObject:s];
}

@end

@implementation TDNonReservedWord : TDWord 
{
}

- (BOOL)qualifies:(id)obj 
{
    if (!obj.isWord)
        return NO;
    
    var s = obj.stringValue;
    return s.length && ![[TDReservedWord reservedWords] containsObject:s];
}

@end
