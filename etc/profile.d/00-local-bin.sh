# WSL-PORT (Ubuntu): denna fil är omskriven jämfört med upstream.
#
# 1) append_path definieras i *Archs* /etc/profile. Ubuntus /etc/profile har
#    ingen sådan funktion. Utan fallbacken nedan avbryts skriptet direkt med
#    "append_path: command not found" och ~/.local/bin hamnar aldrig i PATH.
#    Det är inte kosmetiskt: under zsh läses inte ~/.profile (som är det enda
#    på Ubuntu som annars lägger dit den), så t.ex. `claude` blir omöjlig att
#    hitta.
#
# 2) ~/.local/bin PREPENDAS i stället för att appendas. WSL-interop skjuter in
#    ~15 Windows-kataloger i PATH (bl.a. "/mnt/c/Program Files/nodejs"). Allt
#    som appendas hamnar bakom dem och kan skuggas av en Windows-binär med
#    samma namn. Ubuntus egen ~/.profile prependar av precis samma skäl.
#
# 3) [[ ]] → POSIX [ ], och -r → -d för katalogtester.

if ! command -v append_path >/dev/null 2>&1; then
    append_path () {
        case ":$PATH:" in
            *:"$1":*) ;;
            *) PATH="${PATH:+$PATH:}$1" ;;
        esac
    }
fi

prepend_path () {
    case ":$PATH:" in
        *:"$1":*) ;;
        *) PATH="$1${PATH:+:$PATH}" ;;
    esac
}

if [ -d "$HOME/.local/bin" ]; then
    prepend_path "$HOME/.local/bin"
fi

if [ -d "$HOME/go/bin" ]; then
    append_path "$HOME/go/bin"
fi

if [ -d "/opt/dotfiles/.bin" ]; then
    append_path "/opt/dotfiles/.bin"
fi

if [ -d "$HOME/.bun/bin" ]; then
    [ -s "$HOME/.bun/_bun" ] && . "$HOME/.bun/_bun"
    export BUN_INSTALL="$HOME/.bun"
    append_path "$HOME/.bun/bin"
fi

if [ -r "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

export PATH
unset -f prepend_path 2>/dev/null || true

true
