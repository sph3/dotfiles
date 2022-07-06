# show minimalist system info when terminal is opened
function fish_greeting
    pfetch
end

# initialize starship prompt
starship init fish | source
