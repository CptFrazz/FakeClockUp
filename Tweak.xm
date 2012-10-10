static float durMulti;
static BOOL fakeClockUpIsEnabled;
static BOOL excludeEditingMode;
static BOOL excludeNetworkActivityIndicator;
static BOOL isDiabledApplication = NO;
static BOOL switcherIsEditing = NO;

@interface SBIconController : NSObject
+ (id)sharedInstance;
- (BOOL)isEditing;
@end

%hook CAAnimation
- (void)setDuration:(NSTimeInterval)duration
{
  if ((isDiabledApplication || !fakeClockUpIsEnabled) || (([[%c(SBIconController) sharedInstance] isEditing] || switcherIsEditing) && excludeEditingMode))
    %orig;
  else
    %orig(duration * durMulti);
}
%end

%hook UIActivityIndicatorView
- (void)setAnimationDuration:(double)duration
{
  if (fakeClockUpIsEnabled && excludeNetworkActivityIndicator)
    %orig(duration / durMulti);
  else
    %orig;
}
%end

// NOTE: ivar of _editing is not change before call -[CAAnimation setDuration:] method.
%hook SBAppSwitcherController
- (void)_beginEditing
{
  switcherIsEditing = YES;
  %orig;
}

- (void)_stopEditing
{
  switcherIsEditing = NO;
  %orig;
}
%end

static void LoadSettings()
{
  NSDictionary *udDict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/jp.novi.FakeClockUp.plist"];
  id durationExsist = [udDict objectForKey:@"duration"];
  float durm = durationExsist ? [durationExsist floatValue] : 0.4;
  if (durm != 0.0 && durm >= 0.001 && durm <= 20)
    durMulti = durm;

  id fakeClockUpIsEnabledPref = [udDict objectForKey:@"enabled"];
  fakeClockUpIsEnabled = fakeClockUpIsEnabledPref ? [fakeClockUpIsEnabledPref boolValue] : YES;

  id excludeEditingModePref = [udDict objectForKey:@"excludeEditingMode"];
  excludeEditingMode = excludeEditingModePref ? [excludeEditingModePref boolValue] : NO;

  id excludeNetworkActivityIndicatorPref = [udDict objectForKey:@"excludeNetworkActivityIndicator"];
  excludeNetworkActivityIndicator = excludeNetworkActivityIndicatorPref ? [excludeNetworkActivityIndicatorPref boolValue] : NO;

  NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
  if (bundleIdentifier) {
    NSString *key = [@"FCDisable-" stringByAppendingString:bundleIdentifier];
    id disablePref = [udDict objectForKey:key];
    isDiabledApplication = disablePref ? [disablePref boolValue] : NO;
  }
}

static void ChangeNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
  LoadSettings();
}

%ctor
{ 
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, ChangeNotification, CFSTR("jp.novi.FakeClockUp.preferencechanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  LoadSettings();
  [pool drain];
}
