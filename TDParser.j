
@import <Foundation/Foundation.j>
@import "TDAssembly.j"

@implementation TDParser : CPObject 
{
    id          assembler;
    SEL         selector;
    CPString    name;
}

+ (id)parser 
{
    return [[self alloc] init];
}

- (id)init 
{
    return self = [super init];
}

- (void)setAssembler:(id)a selector:(SEL)sel 
{
    [self setAssembler:a];
    [self setSelector:sel];
}

- (TDParser)parserNamed:(CPString)s 
{
    if (name === s)
        return self;

    return nil;
}

- (CPSet)allMatchesFor:(CPSet)inAssemblies 
{
    //NSAssert1(0, @"-[TDParser %s] must be overriden", _cmd);
    return nil;
}

- (TDAssembly)bestMatchFor:(TDAssembly)a 
{
    var initialState = [CPSet setWithObject:a],
        finalState = [self matchAndAssemble:initialState];

    return [self best:finalState];
}

- (TDAssembly)completeMatchFor:(TDAssembly)a 
{
    var best = [self bestMatchFor:a];

    if (best && ![best hasMore])
        return best;

    return nil;
}

- (CPSet)matchAndAssemble:(CPSet)inAssemblies 
{
    var outAssemblies = [self allMatchesFor:inAssemblies];

    if (assembler) {
        //NSAssert2([assembler respondsToSelector:selector], @"provided assembler %@ should respond to %s", assembler, selector);
        var values = [outAssemblies allValues],
            length = [values count];

        for (var i=0; i<length; i++) {
            [assembler performSelector:selector withObject:values[i]];
        }
    }

    return outAssemblies;
}

- (TDAssembly)best:(CPSet)inAssemblies 
{
    var best = nil,
        values = [inAssemblies allValues],
        length = [values count];
    
    for (var i=0; i<length; i++) {
        var a = values[i];
        
        if (![a hasMore]) {
            best = a;
            break;
        }
        
        if (!best || a.objectsConsumed > best.objectsConsumed)
            best = a;
    }
    
    return best;
}

- (CPString)description 
{
    if (name.length)
        return [CPString stringWithFormat:@"%@ (%@)", [self className], name];
    else
        return [CPString stringWithFormat:@"%@", [self className]];
}

@end
