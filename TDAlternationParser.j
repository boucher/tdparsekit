
@import "TDCollectionParser.j"
@import "TDAssembly.j"

@implementation TDAlternation : TDCollectionParser 
{
}

+ (id)alternation 
{
    return [[self alloc] init];
}

- (CPSet)allMatchesFor:(CPSet)inAssemblies 
{
    var outAssemblies = [CPSet set];

    for (var i=0, count=[subparsers count]; i<count; i++)
        [outAssemblies unionSet:[subparsers[i] matchAndAssemble:inAssemblies]];

    return outAssemblies;
}

@end