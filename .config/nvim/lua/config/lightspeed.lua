require'lightspeed'.setup {
    ignore_case = true,
    exit_after_idle_msecs = { unlabeled = 550, labeled = nil },
    --- s/x ---
    special_keys = {
        next_match_group = '<space>',
        prev_match_group = '<tab>',
    },
    --- f/t ---
    limit_ft_matches = 4,
    repeat_ft_with_target_char = false,
}
