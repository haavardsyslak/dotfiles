function fish_prompt --description 'Write out the prompt'
    set -l last_status $status

    # User
    set_color $fish_color green
    echo -n $USER
    set_color normal

#    echo -n '@'

    # Host
 #   set_color $fish_color_host
 #   echo -n (prompt_hostname)
  #  set_color normal

    echo -n ':  '

    # PWD
    set_color $fish_color_user
    #echo -n (prompt_pwd)
    echo -n (pwd | sed -e 's/^\/home\/syslak/~/g')
	set_color normal
	echo -n ' '
    __terlar_git_prompt
    fish_hg_prompt
    echo

    if not test $last_status -eq 0
        set_color $fish_color_error
    end

    echo -n '$ '
    set_color normal
end
