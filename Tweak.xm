#define PLIST_PATH @"/var/mobile/Library/Preferences/com.spookybois.spotifyalarm.plist"
 
inline bool GetPrefBool(NSString *key) {
return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] boolValue];
}

%hook something
 
-(int)method {
if(GetPrefBool(@"key1")) {
return 9999999;
}
return %orig;
}

-(int)gems {       
if(GetPrefBool(@"key2")) {
return 9999999;
}
return %orig;
}

-(unsigned int)lives {
if(GetPrefBool(@"key3")) {
return 9999999;
}
return %orig;
}

%end

%hook SomethingElse

-(BOOL)SomeMethod {
if(GetPrefBool(@"key4")) {
return TRUE;
}
return %orig;
}

%end
