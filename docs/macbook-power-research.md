# MacBook Power Efficiency Research

As of 2026-08-31.

## Bottom line

The safest, highest-impact path is:

1. Measure first with Activity Monitor's Energy tab and Battery usage history instead of guessing which app is expensive. Apple exposes `Energy Impact`, `12 hr Power`, `Graphics Card`, and `Preventing Sleep`, plus 24-hour and 10-day battery history in Battery settings. [Apple: Activity Monitor energy](https://support.apple.com/en-lamr/guide/activity-monitor/actmntr43697/mac) [Apple: Battery settings](https://support.apple.com/guide/mac-help/change-battery-settings-mchlfc3b7879/mac) [Apple: Battery usage history](https://support.apple.com/guide/mac-help/view-battery-usage-history-mchle6eb6928/26/mac/26)
2. Turn on Low Power Mode when battery life matters more than peak performance. Apple says it reduces energy use, and on supported newer models it can also reduce fan noise. [Apple: Power Modes](https://support.apple.com/en-us/101613)
3. Apply the Apple-supported battery/display/network levers: dim display, shorten display-off time, let the Mac sleep, turn off Wi‑Fi/Bluetooth when unused, quit unused apps, disconnect unused accessories, and enable the battery options Apple documents. [Apple: Save energy](https://support.apple.com/guide/mac-help/optimize-your-mac-battery-life-mh35848/26/mac/26) [Apple: Battery settings](https://support.apple.com/guide/mac-help/change-battery-settings-mchlfc3b7879/mac)
4. Audit Login Items and background items; background permissions explicitly allow apps to do work when not open. [Apple: Login Items & Extensions](https://support.apple.com/en-lamr/guide/mac-help/mh15189/mac)
5. If you use Stats, reduce or remove it only after confirming it is meaningfully expensive on your Mac. The app's own README says each module has a "price" and that `Sensors` and `Bluetooth` are the most inefficient modules. [Stats README](https://github.com/exelban/stats/blob/master/README.md?plain=1)

## What is directly measurable on the Mac

- Apple's supported way to identify energy-heavy apps is Activity Monitor > Energy. The most decision-useful columns are `Energy Impact` for current usage, `12 hr Power` for sustained usage on laptops, `Graphics Card` for apps that pull in higher-power graphics, and `Preventing Sleep` for apps that block sleep. [Apple: Activity Monitor energy](https://support.apple.com/en-lamr/guide/activity-monitor/actmntr43697/mac)
- Apple also exposes battery trend data in System Settings > Battery. `Battery Level` shows charge over time, `Energy Usage` shows daily computer energy use, and `Screen On Usage` helps separate screen time from app/process issues. [Apple: Battery settings](https://support.apple.com/guide/mac-help/change-battery-settings-mchlfc3b7879/mac) [Apple: Battery usage history](https://support.apple.com/guide/mac-help/view-battery-usage-history-mchle6eb6928/26/mac/26)

## Apple-supported changes with the best risk/reward

### 1. Low Power Mode

- Apple says `Low Power Mode` reduces energy usage to increase battery life. On supported systems in macOS Sequoia 15.1 or later, it also helps reduce fan noise and power consumption. [Apple: Power Modes](https://support.apple.com/en-us/101613)
- `Automatic` is the default balance mode. `High Power` explicitly increases energy use for sustained heavy workloads, so it should be off unless you need that performance. [Apple: Power Modes](https://support.apple.com/en-us/101613) [Apple: Battery settings](https://support.apple.com/guide/mac-help/change-battery-settings-mchlfc3b7879/mac)

### 2. Battery settings that Apple explicitly recommends

- In Battery settings, Apple exposes `Optimized Battery Charging`, `Manage battery longevity`, and `Charge Limit`. These are battery-health/longevity controls, not magic efficiency tweaks, but they are first-party supported and safe. [Apple: Battery settings](https://support.apple.com/guide/mac-help/change-battery-settings-mchlfc3b7879/mac)
- Apple also documents `Slightly dim the display on battery`, `Put hard disks to sleep when possible`, `Automatic graphics switching`, `Enable Power Nap`, `Wake for network access`, and `Optimize video streaming while on battery`. The most directly power-positive options are dimming, graphics switching where available, and HDR-to-SDR video optimization on battery. `Power Nap` and `Wake for network access` can trade convenience for extra background activity. [Apple: Battery settings](https://support.apple.com/guide/mac-help/change-battery-settings-mchlfc3b7879/mac)

### 3. Display, sleep, radios, and peripherals

- Apple says sleep uses much less energy than leaving the Mac awake. [Apple: Save energy](https://support.apple.com/guide/mac-help/optimize-your-mac-battery-life-mh35848/26/mac/26)
- Apple specifically recommends dimming the display, turning the display off after inactivity, turning off Wi‑Fi and Bluetooth when not needed, quitting unused apps, and disconnecting unused accessories such as external drives. [Apple: Save energy](https://support.apple.com/guide/mac-help/optimize-your-mac-battery-life-mh35848/26/mac/26)

### 4. Login items and background items

- Apple documents that Login Items & Extensions controls both apps that open at login and apps allowed to run in the background "when the app isn't open," including update and sync work. This is a safe, high-value place to remove ongoing background drain. [Apple: Login Items & Extensions](https://support.apple.com/en-lamr/guide/mac-help/mh15189/mac)

## Menu bar monitoring overhead, including Stats

### Measured / first-party-supported

- Apple does not provide a special "menu bar app overhead" dashboard. The supported way to evaluate a monitor app is still Activity Monitor's Energy pane and Battery history. If a menu bar monitor is costly, it will show up there like any other app/process. [Apple: Activity Monitor energy](https://support.apple.com/en-lamr/guide/activity-monitor/actmntr43697/mac) [Apple: Battery usage history](https://support.apple.com/guide/mac-help/view-battery-usage-history-mchle6eb6928/26/mac/26)

### Vendor-documented facts about Stats

- Stats describes itself as a macOS system monitor that can continuously show CPU, GPU, RAM, Disk, Network, Battery, Sensors, Bluetooth, Clock, and related data in the menu bar. [Stats README](https://github.com/exelban/stats/blob/master/README.md?plain=1)
- The maintainer states that reading some data periodically is "not a cheap task," that each module has its own "price," and that `Sensors` and `Bluetooth` are the most inefficient modules. The README says disabling those modules could reduce Stats CPU usage and power impact by up to 50% in some cases. [Stats README](https://github.com/exelban/stats/blob/master/README.md?plain=1)

### Inference

- It is plausible that removing Stats entirely helps battery life if Activity Monitor shows Stats as a persistent energy user, because the app's purpose is continuous polling/monitoring and its own maintainer documents per-module cost. This is an inference from the product's function plus the maintainer's README, not an Apple guarantee. [Stats README](https://github.com/exelban/stats/blob/master/README.md?plain=1)
- Before uninstalling, the lower-risk move is to disable the expensive Stats modules first, especially `Sensors` and `Bluetooth`, then re-check `Energy Impact` and `12 hr Power`. This recommendation is an inference built on Apple's measurement tools plus the Stats README guidance. [Apple: Activity Monitor energy](https://support.apple.com/en-lamr/guide/activity-monitor/actmntr43697/mac) [Stats README](https://github.com/exelban/stats/blob/master/README.md?plain=1)

## Cautions against dubious tweaks

- Apple says standard Mac configurations already meet ENERGY STAR energy-efficiency guidelines and macOS is designed to be energy efficient out of the box. That makes first-party settings and measurement tools the safest levers. [Apple: Battery settings](https://support.apple.com/guide/mac-help/change-battery-settings-mchlfc3b7879/mac) [Apple: Save energy](https://support.apple.com/guide/mac-help/optimize-your-mac-battery-life-mh35848/26/mac/26)
- I did not find primary-source Apple guidance supporting common "battery optimization" folklore such as memory cleaners, app-killer utilities, hidden Terminal hacks, disabling core protections, or routine cache purges. Treat those as unsupported unless a vendor publishes model-specific evidence. This is an inference from the absence of first-party support in the Apple documentation reviewed here.
- If your goal is longer runtime today, be careful not to confuse it with long-term battery lifespan. Apple's `Optimized Battery Charging`, `Manage battery longevity`, and `Charge Limit` are primarily about preserving battery health/lifespan; they are safe, but they do not replace measuring app drain. [Apple: Battery settings](https://support.apple.com/guide/mac-help/change-battery-settings-mchlfc3b7879/mac)

## Practical order of operations

1. Open Activity Monitor > Energy and sort by `12 hr Power` and then `Energy Impact`. [Apple: Activity Monitor energy](https://support.apple.com/en-lamr/guide/activity-monitor/actmntr43697/mac)
2. In System Settings > Battery, check `Last 24 Hours` and `Last 10 Days` to separate one-off spikes from persistent drain. [Apple: Battery usage history](https://support.apple.com/guide/mac-help/view-battery-usage-history-mchle6eb6928/26/mac/26)
3. Turn on `Low Power Mode` for battery use. Leave `High Power` off unless you are deliberately trading battery for sustained performance. [Apple: Power Modes](https://support.apple.com/en-us/101613)
4. Reduce screen brightness, shorten display-off timers, and let the Mac sleep. [Apple: Save energy](https://support.apple.com/guide/mac-help/optimize-your-mac-battery-life-mh35848/26/mac/26)
5. Disable unneeded login items and background items. [Apple: Login Items & Extensions](https://support.apple.com/en-lamr/guide/mac-help/mh15189/mac)
6. If Stats is installed, disable `Sensors` and `Bluetooth` first, then re-measure. Remove the app only if measurement still shows a meaningful drain for your use case. [Stats README](https://github.com/exelban/stats/blob/master/README.md?plain=1) [Apple: Activity Monitor energy](https://support.apple.com/en-lamr/guide/activity-monitor/actmntr43697/mac)
