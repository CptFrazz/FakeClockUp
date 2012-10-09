#import <UIKit/UIKit.h>
#import <notify.h>

#define PREF_PATH @"/var/mobile/Library/Preferences/jp.novi.FakeClockUp.plist"
#define kPrefKey @"enabled"

// Determines if the device is capable of running on this platform. If your toggle is device specific like only for
// 3g you would check that here.
BOOL isCapable()
{
	return YES;
}

// This runs when iPhone springboard resets. This is on boot or respring.
BOOL isEnabled()
{
	NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:PREF_PATH];
	BOOL Enabled = [[plistDict objectForKey:kPrefKey] boolValue];
	return Enabled;
}

// This function is optional and should only be used if it is likely for the toggle to become out of sync
// with the state while the iPhone is running. It must be very fast or you will slow down the animated
// showing of the sbsettings window. Imagine 12 slow toggles trying to refresh tate on show.
BOOL getStateFast()
{
	return isEnabled();
}

// Pass in state to set. YES for enable, NO to disable.
void setState(BOOL Enable)
{
	NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:PREF_PATH];
	if (Enable) {
		[plistDict setValue:[NSNumber numberWithBool:YES] forKey:kPrefKey];
		[plistDict writeToFile:PREF_PATH atomically:YES];
	} else {
		[plistDict setValue:[NSNumber numberWithBool:NO] forKey:kPrefKey];
		[plistDict writeToFile:PREF_PATH atomically:YES];
	}
	notify_post("jp.novi.FakeClockUp.preferencechanged");
}

// Amount of time spinner should spin in seconds after the toggle is selected.
float getDelayTime()
{
	return 0.0f;
}

// Runs when the dylib is loaded. Only useful for debug. Function can be omitted.
__attribute__((constructor)) 
static void toggle_initializer() 
{ 
  NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:PREF_PATH];
  if (!plistDict) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSNumber numberWithBool:YES] forKey:kPrefKey];
    [dict writeToFile:PREF_PATH atomically:NO];
  }
}
