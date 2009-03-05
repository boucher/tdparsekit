
@import "TDParser.j"

@implementation TDCollectionParser : TDParser 
{
    CPArray subparsers @accessors;
}

- (id)init 
{
    if (self = [super init]) {
        self.subparsers = [];
    }

    return self;
}

- (void)add:(TDParser)p 
{
    [subparsers addObject:p];
}

- (TDParser)parserNamed:(CPString)s 
{
    if (name === s)
        return self;
    else 
    {
        for (var i=0, length = [subparsers count]; i<length; i++)
        {
            var sub = [subparsers[i] parserNamed:s];

            if (sub)
                return sub;
        }
    }

    return nil;
}

@end
