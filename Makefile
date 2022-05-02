WAYLAND_FLAGS = $(shell pkg-config wayland-client --cflags --libs)
WAYLAND_PROTOCOLS_DIR = $(shell pkg-config wayland-protocols --variable=pkgdatadir)
WAYLAND_SCANNER = $(shell pkg-config --variable=wayland_scanner wayland-scanner)
CFLAGS ?= -std=c11 -Wall -Wextra -Werror -Wno-unused-parameter -g

XDG_SHELL_PROTOCOL = $(WAYLAND_PROTOCOLS_DIR)/stable/xdg-shell/xdg-shell.xml
VIEWPORTER_PROTOCOL = $(WAYLAND_PROTOCOLS_DIR)/stable/viewporter/viewporter.xml

HEADERS=xdg-shell-client-protocol.h viewporter-client-protocol.h shm.h
SOURCES=main.c xdg-shell-protocol.c viewporter-protocol.c shm.c

all: hello-wayland

hello-wayland: $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -o $@ $(SOURCES) -lrt $(WAYLAND_FLAGS)

xdg-shell-client-protocol.h:
	$(WAYLAND_SCANNER) client-header $(XDG_SHELL_PROTOCOL) xdg-shell-client-protocol.h

xdg-shell-protocol.c:
	$(WAYLAND_SCANNER) private-code $(XDG_SHELL_PROTOCOL) xdg-shell-protocol.c

viewporter-client-protocol.h:
	$(WAYLAND_SCANNER) client-header $(VIEWPORTER_PROTOCOL) viewporter-client-protocol.h

viewporter-protocol.c:
	$(WAYLAND_SCANNER) private-code $(VIEWPORTER_PROTOCOL) viewporter-protocol.c

.PHONY: clean
clean:
	$(RM) hello-wayland xdg-shell-protocol.c xdg-shell-client-protocol.h viewporter-protocol.c viewporter-client-protocol.h
