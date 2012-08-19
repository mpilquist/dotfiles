#!/usr/bin/env ruby
=begin
Helper script for tmux' split-window command that retains the original PWD
This script is based on https://wiki.archlinux.org/index.php/Tmux#.2Fproc_method
From: https://gist.github.com/2758863
=end
SHELL = 'reattach-to-user-namespace -l zsh'


session_id, window_id, pane_id = `tmux display-message -p "#S:#I:#P"`.chomp.split(/:/)
tty = nil
in_sessions = false
in_right_session = false
in_right_window = false
in_right_pane = false

# First step is to find our tty
`tmux server-info`.each_line do |line|
    break if line.start_with? 'Terminals'
    if line.start_with? 'Sessions: '
        in_sessions = true
        next
    end
    if in_sessions and line =~ /^\s\d+: #{session_id}: \d+ window..*[flags=.*]/
        in_right_session = true
        next
    end
    if in_right_session and line =~ /^\s{3}#{window_id}:/
        in_right_window = true
        next
    end
    if in_right_window and line =~ /^\s*#{pane_id}: \/dev\/(\S+) /
        tty = $1
        break
    end
end

raise "No matching tty found" if tty.nil?

# Now let's find the process with this tty
pid = `ps -t #{tty}`.split($/)[1].split(' ')[0]

# ... and now its PWD
pwd = `lsof -a -d cwd -p #{pid} -F n`.split($/)[1][1..-1]
args = ARGV * " "

# Let's put it all together by calling split-window with the shell and the path
`tmux split-window #{args} 'cd #{pwd}; #{SHELL}'`
