
@import "TDParser.j"
@import "TDToken.j"
@improt "TDAssembly.j"

@implementation TDTerminal : TDParser 
{
    CPString    string;
    BOOL        discardFlag;
}

- (id)init 
{
    return [self initWithString:nil];
}

- (id)initWithString:(CPString)s 
{
    if (self = [super init]) {
        string = s;
    }
    
    return self;
}

- (CPSet)allMatchesFor:(CPSet)inAssemblies 
{
    var outAssemblies = [CPSet set],
        values = [inAssemblies allValues];
    
    for (var i=0, count=[values count]; i<count; i++)
    {
        var a = values[i],
            b = [self matchOneAssembly:a];
    
        if (b)
            [outAssemblies addObject:b]
    }
    
    return outAssemblies;
}

- (TDAssembly)matchOneAssembly:(TDAssembly)inAssembly 
{
    if (![inAssembly hasMore])
        return nil;
    
    var outAssembly = nil;
    
    if ([self qualifies:[inAssembly peek]]) {
        outAssembly = [inAssembly copy];
        
        var obj = [outAssembly next];
        if (!discardFlag)
            [outAssembly push:obj];
    }
    
    return outAssembly;
}

- (BOOL)qualifies:(id)obj 
{
    //NSAssert1(0, @"-[TDTerminal %s] must be overriden", _cmd);
    return NO;
}

- (TDTerminal)discard 
{
    discardFlag = YES;
    return self;
}

@end
