#
# Copyright 2022 Gaël PORTAY
#
# SPDX-License-Identifier: LGPL-2.1-or-later
#

.PHONY: all
all: libevent-server

.PHONY: run
run: PATH := $(CURDIR):$(PATH)
run: libevent-server | cachttp.pem
	libevent-server 10433 cachttp.key cachttp.pem

.PHONY: get
get:
	curl -k https://localhost:10433/Makefile

libevent-server: LDLIBS += -lssl -lcrypto -levent_openssl -levent -lnghttp2
libevent-server:

%.pem:
	openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout $*.key -out $@ \
	            -subj "/C=FR/ST=France/L=Annecy/O=CACHTTP/OU=IT/CN=portay.io"

.PHONY: clean
clean:
	rm -f libevent-server

.PHONY: mrproper
mrproper: clean
	rm -f cachttp.key cachttp.pem
