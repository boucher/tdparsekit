
@import <Foundation/Foundation.j>

TDAssemblyDefaultDelimiter = @"/";

@interface TDAssembly : CPObject
{
    CPArray     stack;
    id          target;
    unsigned    index;
    CPString    string;
    CPString    defaultDelimiter;
}

+ (id)assemblyWithString:(CPString)s 
{
    return [[self alloc] initWithString:s];
}

- (id)init 
{
    return [self initWithString:nil];
}

- (id)initWithString:(CPString)s 
{
    if self = [super init] {
        stack = [];
        string = s;
    }

    return self;
}

// this private intializer exists simply to improve the performance of the -copyWithZone: method.
// note flow *does not* go thru the designated initializer above. however, that ugliness is worth it cuz
// the perf of -copyWithZone: in this class is *vital* to the framework's performance
- (id)_init 
{
    return [super init];
}

// this method diverges from coding standards cuz it is vital to the entire framework's performance
- (id)copy 
{
    var a = [[[self class] alloc] _init];
    
    a.stack = [stack copy];
    a.string = string;
    a.index = index;

    if (defaultDelimiter)
        a.defaultDelimiter = defaultDelimiter;

    if (target)
        a.target = [target copy]

    return a;
}

- (id)next {
    //NSAssert1(0, @"-[TDAssembly %s] must be overriden", _cmd);
    return nil;
}

- (BOOL)hasMore {
    //NSAssert1(0, @"-[TDAssembly %s] must be overriden", _cmd);
    return NO;
}

- (CPString)consumedObjectsJoinedByString:(CPString)delimiter {
    //NSAssert1(0, @"-[TDAssembly %s] must be overriden", _cmd);
    return nil;
}

- (CPString)remainingObjectsJoinedByString:(CPString)delimiter {
    //NSAssert1(0, @"-[TDAssembly %s] must be overriden", _cmd);
    return nil;
}

- (unsigned)length {
    //NSAssert1(0, @"-[TDAssembly %s] must be overriden", _cmd);
    return 0;
}

- (unsigned)objectsConsumed {
    //NSAssert1(0, @"-[TDAssembly %s] must be overriden", _cmd);
    return 0;
}

- (unsigned)objectsRemaining {
    //NSAssert1(0, @"-[TDAssembly %s] must be overriden", _cmd);
    return 0;
}

- (id)peek {
    //NSAssert1(0, @"-[TDAssembly %s] must be overriden", _cmd);
    return nil;
}

- (id)pop 
{
    var result = nil;
    if (stack.count) {
        result = [stack lastObject];
        [stack removeLastObject];
    }
    return result;
}

- (void)push:(id)object 
{
    if (object) {
        [stack addObject:object];
    }
}

- (BOOL)isStackEmpty {
    return 0 === stack.count;
}


- (CPArray)objectsAbove:(id)fence 
{
    var result = [];
    
    while (stack.count) {        
        var obj = [self pop];
        
        if ([obj isEqual:fence]) {
            [self push:obj];
            break;
        } else {
            [result addObject:obj];
        }
    }
    
    return result;
}

- (CPString)description 
{
    var s = "[",
        i = 0,
        length = stack.count;
    
    for (;i<length;i++) {
        s = s + [obj description];
        if (len - 1 !== i++) {
            s = s + ", ";
        }
    }
    
    s = s + "]";
    
    var d = defaultDelimiter ? defaultDelimiter : TDAssemblyDefaultDelimiter;
    
    s = s + [self consumedObjectsJoinedByString:d] + "^" + [self remainingObjectsJoinedByString:d];

    return s;
}

@end
