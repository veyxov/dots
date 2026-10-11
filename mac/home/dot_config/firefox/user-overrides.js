// Appended after betterfox.js (vendored, v154). Update it with:
//   curl -sL https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js -o ~/dots/mac/home/dot_config/firefox/betterfox.js
user_pref("browser.startup.page", 3);
user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", true);

// prefs.js holds explicit "available" values, which beat Betterfox's "blocked" default
user_pref("browser.ai.control.sidebarChatbot", "blocked");
user_pref("browser.ai.control.linkPreviewKeyPoints", "blocked");

// Betterfox disables the disk cache for privacy; keep it for faster repeat loads
user_pref("browser.cache.disk.enable", true);
