#import "CallTracer.h"
#import "IntrospySQLiteStorage.h"


@implementation CallTracer : NSObject

@synthesize args;
@synthesize className;
@synthesize methodName;

- (CallTracer*)initWithClass:(NSString *)clazz andMethod:(NSString *)meth {
	/* initialize the call tracer with class and method names */
	[super init];
	args = [[NSMutableDictionary alloc] init];
	className = clazz;
	methodName = meth;
	NSLog(@"CallTracer::initWithClass: %@::%@", clazz, meth);
	return self;
}

- (BOOL) addArgFromString:(NSString *)str withKey:(NSString *)key {
	/* add a string argument to the plist of method arguments */
	if(str != nil) {
		[args setValue:str forKey:key];
		return true;
	}
	return false;
}

- (BOOL) addArgFromData:(NSData *)data withKey:(NSString *)key {
	/* add an NSData argument to the plist of method arguments */
	if (data != nil) {
		[args setValue:data forKey:key];
		return true;
	}
	return false;
}

- (BOOL) addArgFromDictionary:(NSDictionary *)dict withKey:(NSString *)key {
	/* add an NSDictionary argument to the plist of method arguments */
	if (dict != nil) {
		[args setValue:dict forKey:key];
		return true;
	}
	return false;
}

- (BOOL) addArgFromBOOL:(BOOL)boolean withKey:(NSString *)key {
	/* add a BOOL argument to the plist of method arguments */
	[args setValue:[NSNumber numberWithBool:boolean] forKey:key];
	return true;
}

- (BOOL) addArgFromInteger:(NSUInteger)val withKey:(NSString *)key {
	/* add a BOOL argument to the plist of method arguments */
	[args setValue:[NSNumber numberWithInt:val] forKey:key];
	return true;
}

- (BOOL) addArgFromFloat:(float)val withKey:(NSString *)key {
	/* add a BOOL argument to the plist of method arguments */
	[args setValue:[NSNumber numberWithFloat:val] forKey:key];
	return true;
}

- (BOOL) addArgFromDouble:(double)val withKey:(NSString *)key {
	/* add a BOOL argument to the plist of method arguments */
	[args setValue:[NSNumber numberWithDouble:val] forKey:key];
	return true;
}

- (BOOL) addArgFromURL:(NSURL *)aURL withKey:(NSString *)key {
	/* creates a dictionary of the NSURL attributes and adds it to the plist */
	if (aURL != nil) {
		NSDictionary *url_dict;
		if ([[aURL scheme] isEqualToString:@"file"]) {
		  url_dict = [NSDictionary dictionaryWithObjects:
				   [NSArray arrayWithObjects: [aURL absoluteString],
							      nil]
						     forKeys: [NSArray arrayWithObjects:
						    	      @"absoluteString",
							      nil]];
		} else if ([[aURL scheme] isEqualToString:@"http"]) {
		  url_dict = [NSDictionary dictionaryWithObjects:
				   [NSArray arrayWithObjects: [aURL absoluteString],
				 			      [aURL scheme],
							      [aURL host],
							      [aURL port],
							      [aURL path],
							      [aURL parameterString],
							      [aURL query], nil]
						     forKeys: [NSArray arrayWithObjects:
						    	      @"absoluteString",
						    	      @"scheme",
							      @"host",
							      @"port",
							      @"path",
							      @"parameterString",
							      @"query", nil]];
		} else {
		  return false;
		}
		[self addArgFromDictionary:url_dict withKey:key];
		return true;
	}
	return false;
}


- (NSData *) serializeArgs {
	/* serialize the NSDictionary of arguments into a plist */
	NSError *error;
	NSData *plist = [NSPropertyListSerialization dataWithPropertyList:(id)args
   							     format:NSPropertyListXMLFormat_v1_0 // for testing
   							    options:0
   							      error:&error];
//	if (error != nil) {
//		NSLog(@"CallTracer::serializeArgs: %@", error);
//		return nil;
//	}
	return plist;
}

- (void)dealloc
{
    [args release];
    [super dealloc];
}

@end
