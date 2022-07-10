#
# Copyright 2022 Gaël PORTAY
#
# SPDX-License-Identifier: LGPL-2.1-or-later
#

.PHONY: all
all: libevent-server

libevent-server: LDLIBS += -lssl -lcrypto -levent_openssl -levent -lnghttp2
libevent-server:

.PHONY: clean
clean:
	rm -f libevent-server

