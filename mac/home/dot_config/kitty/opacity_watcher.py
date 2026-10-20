# Theme .auto.conf files only carry colors, so per-appearance opacity has to be set at runtime.
def _apply(boss, window):
    opacity = '0.69' if window.is_dark else '0.82'
    boss.call_remote_control(window, ('set-background-opacity', f'--match=id:{window.id}', opacity))


def on_focus_change(boss, window, data):
    if data['focused']:
        _apply(boss, window)


def on_color_scheme_preference_change(boss, window, data):
    _apply(boss, window)
