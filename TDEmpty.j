
@import "TDParser.j"

@implementation TDEmpty : TDParser {

}

+ (id)empty 
{
    return [[self alloc] init];
}

- (CPSet)allMatchesFor:(CPSet)inAssemblies 
{
    return inAssemblies;
}

@end