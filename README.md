# dotbins

Here I keep scripts and utils that live on my *~/.bin* directory. They are
currently on a private git repo, so I'm cleaning and importing them.

**They aren't optimal**, but works for my needs. Feel free to suggest
improvements on them.

## scripts
- **mutefy**: Old script to mute ads on Spotify (when using Alsa). I don't use
  it anymore, so maybe it isn't working right now
- **renamer**: Rename all files where invoked, removing whitespaces (and some
  other trash), in order to ease file handling on command line. Also, the new
  file name can have all characters in upper or lower case
- **imgurme**: Parse and download images from an Imgur gallery url
- **curreios**: Check [Correrios](http://websro.correios.com.br/sro_bin/txect01$.startup?P_LINGUA=001&P_TIPO=001)
  shipments
- **update-git**: Update git repositories found on the current directory (with
  its submodules)
- **show-ansi-colors.sh**: Display current terminal colors. Based on
  [this script](https://gist.github.com/eliranmal/b373abbe1c21e991b394bdffb0c8a6cf)
- **wireguard_allow_ip_ranges.sh**: Update wireguard config files PostUp and
  PreDown rules to allow specific IP ranges
- **power**: lock X screen and/or suspend/hybernate

    Usage:
    ```shell
    $ power <suspend|hibernate|hybrid|lock-only>
    ```

    This script clears cached GPG passwords when called. If ran without
    arguments, will hybrid-suspend the system.

    Also, can be used as an *acpi event* handler (/etc/acpi/event/lid):
    ```shell
    event=button/lid LID close
    action=su "$(ps aux | grep xinit | grep -v grep | awk '{print $1}')" -c "power lock-only"
    ```

- **pinentry-auto**: show `pinentry-curses` or `pinentry-qt` if requiring GPG
  password from a terminal emulator of from a GUI application. Based on [this
  script](https://kevinlocke.name/bits/2019/07/31/prefer-terminal-for-gpg-pinentry/).

    Usage:

    Configure your **pinentry-program** entry to `pinentry-auto` and set
    *USE_CURSES=1* on the *PINENTRY_USER_DATA* environment variable on your
    shell.
    ```shell
    $ cat ~/.gnupg/gpg-agent.conf
    ...
    pinentry-program /home/mdk/.bin/pinentry-auto
    ...
    $ cat ~/.profile
    ...
    export PINENTRY_USER_DATA="USE_CURSES=1"
    ...
    ```

    **Note**: If starting X from command line (runlevel 3; e.g.: `startx`),
    just unset *PINENTRY_USER_DATA*:
    ```shell
    $ cat ~/.xinitrc
    ...
    unset PINENTRY_USER_DATA
    ...
    ```

## dotfiles
You can take a look on them on my [dotfiles repo](https://git.sr.ht/~mdkcore/dotfiles) ;)
