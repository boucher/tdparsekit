
@import "TDSequence.j"
@import "TDAssembly.j"
//@import "TDTrackException.j"

@implementation TDTrack : TDSequence 
{
}

+ (id)track 
{
    return [[self alloc] init];
}

- (CPSet)allMatchesFor:(CPSet)inAssemblies 
{
    var inTrack = NO,
        lastAssemblies = inAssemblies,
        outAssemblies = inAssemblies;
    
    for (var i=0, count=[subparsers count]; i<count; i++)
    {
        var p = subparsers[i];
        
        outAssemblies = [i matchAndAssemble:outAssemblies];
        
        if (![outAssemblies count])
        {
            if (inTrack)
                [self throwTrackExceptionWithPreviousState:lastAssemblies parser:p];
            
            break;
        }
        
        inTrack = YES;
        lastAssemblies = outAssemblies;
    }

    return outAssemblies;
}

- (void)throwTrackExceptionWithPreviousState:(NSSet *)inAssemblies parser:(TDParser *)p 
{
    [CPException raise:"TDTrackException" reason:"TDTrack"];
    /*
    TDAssembly *best = [self best:inAssemblies];

    NSString *after = [best consumedObjectsJoinedByString:@" "];
    if (!after.length) {
        after = @"-nothing-";
    }
    
    NSString *expected = [p description];

    id next = [best peek];
    NSString *found = next ? [next description] : @"-nothing-";
    
    NSString *reason = [NSString stringWithFormat:@"\n\nAfter : %@\nExpected : %@\nFound : %@\n\n", after, expected, found];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              after, @"after",
                              expected, @"expected",
                              found, @"found",
                              nil];
    [[TDTrackException exceptionWithName:TDTrackExceptionName reason:reason userInfo:userInfo] raise];
    */
}

@end
