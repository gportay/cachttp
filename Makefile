#
# Copyright 2022 Gaël PORTAY
#
# SPDX-License-Identifier: LGPL-2.1-or-later
#

.PHONY: all
all: libevent-server libevent-client

.PHONY: run
run: PATH := $(CURDIR):$(PATH)
run: libevent-server | cachttp.pem
	libevent-server 10433 cachttp.key cachttp.pem

.PHONY: get
get: PATH := $(CURDIR):$(PATH)
get:
	libevent-client https://localhost:10433/Makefile

libevent-server: LDLIBS += -lssl -lcrypto -levent_openssl -levent -lnghttp2
libevent-server:

libevent-client: LDLIBS += -lssl -lcrypto -levent_openssl -levent -lnghttp2
libevent-client: libevent-client.o url-parser/url_parser.o

url-parser/url_parser.o:
	$(MAKE) -C url-parser url_parser.o

%.pem:
	openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout $*.key -out $@ \
	            -subj "/C=FR/ST=France/L=Annecy/O=CACHTTP/OU=IT/CN=portay.io"

.PHONY: clean
clean:
	$(MAKE) -C url-parser clean
	rm -f libevent-server libevent-client

.PHONY: mrproper
mrproper: clean
	rm -f cachttp.key cachttp.pem
