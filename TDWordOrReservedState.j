
@import "TDWordState.j"

@implementation TDWordOrReservedState : TDWordState 
{
    CPSet reservedWords;
}

- (id)init 
{
    self = [super init];
    if (self) {
        reservedWords = [CPSet set];
    }
    return self;
}

- (void)addReservedWord:(CPString)s 
{
    [reservedWords addObject:s];
}

- (TDToken)nextTokenFromReader:(TDReader)r startingWith:(int)cin tokenizer:(TDTokenizer)t 
{
    return nil;
}

@end
