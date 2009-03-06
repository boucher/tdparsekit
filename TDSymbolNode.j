
@import <Foundation/CPObject.j>

@implementation TDSymbolNode : CPObject 
{
    CPString     ancestry;
    TDSymbolNode parent;
    CPDictionary children;
    int          character;
    CPString     string;
}

- (id)initWithParent:(TDSymbolNode)p character:(int)c 
{
    self = [super init];
    if (self) {
        parent = p;
        character = c;
        children = [CPDictionary dictionary];

        // this private property is an optimization. 
        // cache the NSString for the char to prevent it being constantly recreated in -determinAncestry
        string = [CPString stringWithFormat:@"%C", character];

        [self determineAncestry];
    }
    return self;
}

- (void)determineAncestry 
{
    if (-1 == parent.character) { // optimization for sinlge-char symbol (parent is symbol root node)
        ancestry = string;
    } else {
        var result = "",
            n = self;
        while (-1 != n.character) {
            result = n.string + result;
            n = n.parent;
        }
        
        self.ancestry = result; // assign an immutable copy
    }
}

- (CPString)description 
{
    return [CPString stringWithFormat:@"<TDSymbolNode %@>", ancestry];
}

@end
