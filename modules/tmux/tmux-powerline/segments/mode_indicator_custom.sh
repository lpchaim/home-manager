# Indicator of pressing TMUX prefix, copy and insert modes.

prefix_pressed_text=""
insert_mode_text="INS"
copy_mode_text="CPY"
normal_mode_text="NOR"
separator=""

prefix_mode_fg="colour226"
normal_mode_fg="colour16"
copy_mode_fg="colour82"
bg="colour33"

run_segment() {
        copy_bg="#{?client_prefix,$copy_mode_fg,$bg}"
        normal_bg="#{?client_prefix,$normal_mode_fg,$bg}"
        normal_or_copy_indicator="#[bg=${bg}]#{?pane_in_mode,#[bg=${copy_bg}]${copy_mode_text},#[bg=${normal_bg}]${insert_mode_text}}";
        echo "${normal_or_copy_indicator}"
        return 0
}
