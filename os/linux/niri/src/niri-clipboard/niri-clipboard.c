#define _GNU_SOURCE
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <time.h>
#include <unistd.h>
#include <wayland-client.h>
#include <xkbcommon/xkbcommon.h>

/* Wayland protocol definitions for zwp_virtual_keyboard_unstable_v1 */
struct zwp_virtual_keyboard_v1;
struct zwp_virtual_keyboard_manager_v1;

extern const struct wl_interface zwp_virtual_keyboard_v1_interface;
extern const struct wl_interface zwp_virtual_keyboard_manager_v1_interface;

static const struct wl_interface *vkbd_types[] = {
    NULL,
    NULL,
    NULL,
    NULL,
    &wl_seat_interface,
    &zwp_virtual_keyboard_v1_interface,
};

static const struct wl_message zwp_virtual_keyboard_v1_requests[] = {
    { "keymap", "uhu", vkbd_types + 0 },
    { "key", "uuu", vkbd_types + 0 },
    { "modifiers", "uuuu", vkbd_types + 0 },
    { "destroy", "", vkbd_types + 0 },
};

const struct wl_interface zwp_virtual_keyboard_v1_interface = {
    "zwp_virtual_keyboard_v1", 1,
    4, zwp_virtual_keyboard_v1_requests,
    0, NULL,
};

static const struct wl_message zwp_virtual_keyboard_manager_v1_requests[] = {
    { "create_virtual_keyboard", "on", vkbd_types + 4 },
};

const struct wl_interface zwp_virtual_keyboard_manager_v1_interface = {
    "zwp_virtual_keyboard_manager_v1", 1,
    1, zwp_virtual_keyboard_manager_v1_requests,
    0, NULL,
};

#define ZWP_VIRTUAL_KEYBOARD_V1_KEYMAP 0
#define ZWP_VIRTUAL_KEYBOARD_V1_KEY 1
#define ZWP_VIRTUAL_KEYBOARD_V1_MODIFIERS 2
#define ZWP_VIRTUAL_KEYBOARD_V1_DESTROY 3
#define ZWP_VIRTUAL_KEYBOARD_MANAGER_V1_CREATE_VIRTUAL_KEYBOARD 0

static inline struct zwp_virtual_keyboard_v1 *
zwp_virtual_keyboard_manager_v1_create_virtual_keyboard(
    struct zwp_virtual_keyboard_manager_v1 *mgr, struct wl_seat *seat) {
    struct wl_proxy *id = wl_proxy_marshal_flags(
        (struct wl_proxy *)mgr,
        ZWP_VIRTUAL_KEYBOARD_MANAGER_V1_CREATE_VIRTUAL_KEYBOARD,
        &zwp_virtual_keyboard_v1_interface,
        wl_proxy_get_version((struct wl_proxy *)mgr),
        0, seat, NULL);
    return (struct zwp_virtual_keyboard_v1 *)id;
}

static inline void
zwp_virtual_keyboard_v1_keymap(struct zwp_virtual_keyboard_v1 *vkbd,
                               uint32_t format, int32_t fd, uint32_t size) {
    wl_proxy_marshal_flags((struct wl_proxy *)vkbd,
                           ZWP_VIRTUAL_KEYBOARD_V1_KEYMAP, NULL,
                           wl_proxy_get_version((struct wl_proxy *)vkbd),
                           0, format, fd, size);
}

static inline void
zwp_virtual_keyboard_v1_key(struct zwp_virtual_keyboard_v1 *vkbd,
                            uint32_t time, uint32_t key, uint32_t state) {
    wl_proxy_marshal_flags((struct wl_proxy *)vkbd,
                           ZWP_VIRTUAL_KEYBOARD_V1_KEY, NULL,
                           wl_proxy_get_version((struct wl_proxy *)vkbd),
                           0, time, key, state);
}

static inline void
zwp_virtual_keyboard_v1_modifiers(struct zwp_virtual_keyboard_v1 *vkbd,
                                  uint32_t mods_depressed, uint32_t mods_latched,
                                  uint32_t mods_locked, uint32_t group) {
    wl_proxy_marshal_flags((struct wl_proxy *)vkbd,
                           ZWP_VIRTUAL_KEYBOARD_V1_MODIFIERS, NULL,
                           wl_proxy_get_version((struct wl_proxy *)vkbd),
                           0, mods_depressed, mods_latched, mods_locked, group);
}

static inline void
zwp_virtual_keyboard_v1_destroy(struct zwp_virtual_keyboard_v1 *vkbd) {
    wl_proxy_marshal_flags((struct wl_proxy *)vkbd,
                           ZWP_VIRTUAL_KEYBOARD_V1_DESTROY, NULL,
                           wl_proxy_get_version((struct wl_proxy *)vkbd),
                           WL_MARSHAL_FLAG_DESTROY);
}

static const char FALLBACK_KEYMAP_STR[] =
    "xkb_keymap {\n"
    "xkb_keycodes \"minimal\" {\n"
    "    minimum = 8;\n"
    "    maximum = 255;\n"
    "    <LCTL> = 37;\n"
    "    <LFSH> = 50;\n"
    "    <AB02> = 53;\n"
    "    <AB03> = 54;\n"
    "    <AB04> = 55;\n"
    "    <INS>  = 118;\n"
    "};\n"
    "xkb_types \"minimal\" {\n"
    "    virtual_modifiers NumLock;\n"
    "    type \"ONE_LEVEL\" {\n"
    "        modifiers= none;\n"
    "        level_name[Level1]= \"Any\";\n"
    "    };\n"
    "    type \"TWO_LEVEL\" {\n"
    "        modifiers= Shift;\n"
    "        map[Shift]= Level2;\n"
    "        level_name[Level1]= \"Base\";\n"
    "        level_name[Level2]= \"Shift\";\n"
    "    };\n"
    "    type \"ALPHABETIC\" {\n"
    "        modifiers= Shift+Lock;\n"
    "        map[Shift]= Level2;\n"
    "        map[Lock]= Level2;\n"
    "        level_name[Level1]= \"Base\";\n"
    "        level_name[Level2]= \"Caps\";\n"
    "    };\n"
    "};\n"
    "xkb_compatibility \"minimal\" {\n"
    "    interpret Any+AnyOf(all) {\n"
    "        action= SetMods(modifiers=modMapMods,clearLocks);\n"
    "    };\n"
    "};\n"
    "xkb_symbols \"minimal\" {\n"
    "    key <LCTL> { type[Group1] = \"ONE_LEVEL\", [ Control_L ] };\n"
    "    key <LFSH> { type[Group1] = \"ONE_LEVEL\", [ Shift_L ] };\n"
    "    key <AB02> { type[Group1] = \"ALPHABETIC\", [ x, X ] };\n"
    "    key <AB03> { type[Group1] = \"ALPHABETIC\", [ c, C ] };\n"
    "    key <AB04> { type[Group1] = \"ALPHABETIC\", [ v, V ] };\n"
    "    key <INS>  { type[Group1] = \"ONE_LEVEL\", [ Insert ] };\n"
    "    modifier_map Control { <LCTL> };\n"
    "    modifier_map Shift { <LFSH> };\n"
    "};\n"
    "};\n";

struct app_state {
    struct wl_seat *seat;
    struct zwp_virtual_keyboard_manager_v1 *vkbd_mgr;
};

static void registry_global(void *data, struct wl_registry *registry,
                            uint32_t name, const char *interface,
                            uint32_t version) {
    (void)version;
    struct app_state *state = data;
    if (strcmp(interface, wl_seat_interface.name) == 0) {
        state->seat = wl_registry_bind(registry, name, &wl_seat_interface, 1);
    } else if (strcmp(interface, zwp_virtual_keyboard_manager_v1_interface.name) == 0) {
        state->vkbd_mgr = wl_registry_bind(
            registry, name, &zwp_virtual_keyboard_manager_v1_interface, 1);
    }
}

static void registry_global_remove(void *data, struct wl_registry *registry,
                                   uint32_t name) {
    (void)data;
    (void)registry;
    (void)name;
}

static const struct wl_registry_listener registry_listener = {
    .global = registry_global,
    .global_remove = registry_global_remove,
};

static int str_contains_ci(const char *haystack, const char *needle) {
    size_t nlen = strlen(needle);
    for (const char *p = haystack; *p; p++) {
        size_t i = 0;
        while (i < nlen && p[i] &&
               tolower((unsigned char)p[i]) == tolower((unsigned char)needle[i])) {
            i++;
        }
        if (i == nlen) return 1;
    }
    return 0;
}

/* Query NIRI_SOCKET directly to check if the focused window is a terminal */
static int is_terminal_focused(void) {
    const char *sock_path = getenv("NIRI_SOCKET");
    if (!sock_path || !*sock_path) return 0;

    int fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (fd < 0) return 0;

    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, sock_path, sizeof(addr.sun_path) - 1);

    if (connect(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        close(fd);
        return 0;
    }

    const char *req = "\"FocusedWindow\"\n";
    if (write(fd, req, strlen(req)) < 0) {
        close(fd);
        return 0;
    }

    char buf[8192];
    size_t total = 0;
    while (total < sizeof(buf) - 1) {
        ssize_t n = read(fd, buf + total, sizeof(buf) - 1 - total);
        if (n <= 0) break;
        total += (size_t)n;
        if (memchr(buf, '\n', total)) break;
    }
    close(fd);
    if (total == 0) return 0;
    buf[total] = '\0';

    /* Extract exact "app_id":"..." value */
    char app_id[256] = {0};
    const char *key = strstr(buf, "\"app_id\":");
    if (key) {
        const char *p = key + 9;
        while (*p == ' ' || *p == '\t') p++;
        if (*p == '"') {
            p++;
            size_t i = 0;
            while (*p && *p != '"' && i < sizeof(app_id) - 1) {
                if (*p == '\\' && p[1]) p++;
                app_id[i++] = *p++;
            }
            app_id[i] = '\0';
        }
    }

    const char *target = app_id[0] ? app_id : buf;
    const char *terminals[] = {
        "ghostty", "alacritty", "kitty", "foot", "wezterm",
        "xterm", "konsole", "org.gnome.console", "org.gnome.terminal", NULL
    };
    for (int i = 0; terminals[i]; i++) {
        if (str_contains_ci(target, terminals[i])) {
            return 1;
        }
    }
    return 0;
}

static uint32_t now_ms(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint32_t)(ts.tv_sec * 1000 + ts.tv_nsec / 1000000);
}

static char *build_keymap_string(size_t *out_size) {
    struct xkb_context *ctx = xkb_context_new(XKB_CONTEXT_NO_FLAGS);
    if (ctx) {
        struct xkb_rule_names names = {
            .rules = NULL,
            .model = "pc105",
            .layout = "es",
            .variant = NULL,
            .options = NULL,
        };
        struct xkb_keymap *kmap = xkb_keymap_new_from_names(
            ctx, &names, XKB_KEYMAP_COMPILE_NO_FLAGS);
        if (kmap) {
            char *str = xkb_keymap_get_as_string(kmap, XKB_KEYMAP_FORMAT_TEXT_V1);
            xkb_keymap_unref(kmap);
            xkb_context_unref(ctx);
            if (str) {
                *out_size = strlen(str) + 1;
                return str;
            }
        } else {
            xkb_context_unref(ctx);
        }
    }
    *out_size = sizeof(FALLBACK_KEYMAP_STR);
    return strdup(FALLBACK_KEYMAP_STR);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <copy|cut|paste>\n", argv[0]);
        return 1;
    }

    int is_paste = (strcmp(argv[1], "paste") == 0);
    int is_copy = (strcmp(argv[1], "copy") == 0);
    int is_cut = (strcmp(argv[1], "cut") == 0);
    if (!is_copy && !is_cut && !is_paste) {
        fprintf(stderr, "Unknown action: %s (expected copy, cut, or paste)\n", argv[1]);
        return 1;
    }

    int terminal = is_terminal_focused();
    /*
     * Evdev keycodes: KEY_LEFTCTRL = 29, KEY_LEFTSHIFT = 42,
     * KEY_X = 45, KEY_C = 46, KEY_V = 47.
     * Terminals cannot cut output text, so cut falls back to Ctrl+Shift+C.
     */
    uint32_t keycode = is_paste ? 47 : ((is_cut && !terminal) ? 45 : 46);
    /* XKB standard modifier bits: Shift = 1, Control = 4 */
    uint32_t mods = terminal ? (4 | 1) : 4;

    struct wl_display *display = wl_display_connect(NULL);
    if (!display) {
        fprintf(stderr, "Failed to connect to Wayland display\n");
        return 1;
    }

    struct app_state state = {0};
    struct wl_registry *registry = wl_display_get_registry(display);
    wl_registry_add_listener(registry, &registry_listener, &state);
    wl_display_roundtrip(display);

    if (!state.seat || !state.vkbd_mgr) {
        fprintf(stderr, "Wayland compositor missing wl_seat or zwp_virtual_keyboard_manager_v1\n");
        wl_display_disconnect(display);
        return 1;
    }

    struct zwp_virtual_keyboard_v1 *vkbd =
        zwp_virtual_keyboard_manager_v1_create_virtual_keyboard(state.vkbd_mgr, state.seat);

    size_t keymap_size = 0;
    char *keymap_str = build_keymap_string(&keymap_size);

    int fd = memfd_create("vkbd-keymap", MFD_CLOEXEC);
    if (fd < 0) {
        perror("memfd_create");
        free(keymap_str);
        wl_display_disconnect(display);
        return 1;
    }

    if (write(fd, keymap_str, keymap_size) != (ssize_t)keymap_size) {
        perror("write keymap");
        free(keymap_str);
        close(fd);
        wl_display_disconnect(display);
        return 1;
    }
    free(keymap_str);

    zwp_virtual_keyboard_v1_keymap(vkbd, WL_KEYBOARD_KEYMAP_FORMAT_XKB_V1, fd, keymap_size);
    close(fd);

    /*
     * Note for Smithay/Niri:
     * Smithay swaps to the virtual keyboard's keymap lazily on the first `key`
     * request (`prepare_virtual_keymap` -> `change_keymap`), which resets active
     * modifiers. Therefore we send the modifier key press(es) via `key` first,
     * then set `modifiers`, then press C/V.
     */
    uint32_t t0 = now_ms();
    zwp_virtual_keyboard_v1_key(vkbd, t0, 29, WL_KEYBOARD_KEY_STATE_PRESSED); /* KEY_LEFTCTRL */
    if (terminal) {
        zwp_virtual_keyboard_v1_key(vkbd, t0, 42, WL_KEYBOARD_KEY_STATE_PRESSED); /* KEY_LEFTSHIFT */
    }
    zwp_virtual_keyboard_v1_modifiers(vkbd, mods, 0, 0, 0);
    zwp_virtual_keyboard_v1_key(vkbd, t0 + 1, keycode, WL_KEYBOARD_KEY_STATE_PRESSED);
    wl_display_roundtrip(display);

    uint32_t t1 = now_ms();
    zwp_virtual_keyboard_v1_key(vkbd, t1, keycode, WL_KEYBOARD_KEY_STATE_RELEASED);
    if (terminal) {
        zwp_virtual_keyboard_v1_key(vkbd, t1, 42, WL_KEYBOARD_KEY_STATE_RELEASED);
        zwp_virtual_keyboard_v1_modifiers(vkbd, 4, 0, 0, 0);
    }
    zwp_virtual_keyboard_v1_key(vkbd, t1, 29, WL_KEYBOARD_KEY_STATE_RELEASED);
    zwp_virtual_keyboard_v1_modifiers(vkbd, 0, 0, 0, 0);
    wl_display_roundtrip(display);

    zwp_virtual_keyboard_v1_destroy(vkbd);
    wl_display_roundtrip(display);
    wl_display_disconnect(display);
    return 0;
}
