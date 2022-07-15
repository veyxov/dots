require'lightspeed'.setup {
    ignore_case = true,
    exit_after_idle_msecs = { unlabeled = 1000, labeled = nil },
    --- s/x ---
    jump_to_unique_chars = { safety_timeout = 250 },
    match_only_the_start_of_same_char_seqs = true,
    force_beacons_into_match_width = false,
    -- Leaving the appropriate list empty effectively disables "smart" mode,
    -- and forces auto-jump to be on or off.
    safe_labels = { 's', 'a', 'r', 't', 'n', 'e', 'i', 'o', 'd', 'h', 'f', 'w', 'y', 'u', ';', 'm', 'g' },
    labels = { 's', 'a', 'r', 't', 'n', 'e', 'i', 'o', 'd', 'h', 'f', 'w', 'y', 'u', ';', 'm', 'g' },
    -- These keys are captured directly by the plugin at runtime.
    special_keys = {
        next_match_group = '<space>',
        prev_match_group = '<tab>',
    },
    --- f/t ---
    limit_ft_matches = nil,
    repeat_ft_with_target_char = false,
}
