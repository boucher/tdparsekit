
@import "TDCollectionParser.j"

@implementation TDSequence : TDCollectionParser 
{
}

+ (id)sequence 
{
    return [[self alloc] init];
}

- (CPSet)allMatchesFor:(CPSet)inAssemblies 
{
    var outAssemblies = inAssemblies;

    for (var i=0, count = [subparsers count]; i<count; i++) {
        outAssemblies = [subparsers[i] matchAndAssemble:outAssemblies];
        
        if (![outAssemblies count])
            break;
    }
    
    return outAssemblies;
}

@end