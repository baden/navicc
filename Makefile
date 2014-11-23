# See LICENSE for licensing information.

PROJECT = navicc
DESCRIPTION = "GPS Tracking"
HOMEPAGE = "http://new.navi.cc/"
PACKAGE_DIR = $(CURDIR)/build

server="ubuntu@192.168.0.102"

# Options.
# -Werror
ERLC_OPTS ?= +debug_info +warn_export_all +warn_export_vars \
	+warn_shadow_vars +warn_obsolete_guard +warn_missing_spec \
	+'{parse_transform, lager_transform}'

# COMPILE_FIRST = cowboy_middleware cowboy_sub_protocol
CT_OPTS +=  -spec test.spec \
			-cover test/cover.spec \
			-erl_args -config test/test.config
# -boot start_sasl \

# PLT_APPS = crypto public_key

# Dependencies.

# bear not got automaticaly by folsom, bug?
DEPS = lager naviapi navipoint naviws navistats
# TEST_DEPS = ct_helper gun

TEST_DEPS = gun
# dep_ct_helper = git https://github.com/extend/ct_helper.git master

dep_naviapi = git git://github.com/baden/naviapi.git master
dep_navipoint = git git://github.com/baden/navipoint.git master
dep_naviws = git git://github.com/baden/naviws.git master
dep_navistats = git git://github.com/baden/navistats.git master


# RELX_OPTS = -o rel release tar
# RELX_OUTPUT_DIR = rel
RELX_OPTS = -o _rel release tar

include erlang.mk

# Also dialyze the tests.
# DIALYZER_OPTS += --src -r test
test-shell: app
	erl -pa ebin -pa deps/*/ebin -pa test -s navicc -config test/test.config

run: rel
	./_rel/navicc_release/bin/navicc_release console

observer:
	erl -sname test -setcookie 123 -s observer

$(eval RELEASE_NAME := $(shell \
	grep -E '^[^%]*{release,.*' relx.config | \
	grep -o ' {.*, "' | \
	grep -o '[^ {,"]*'))
$(eval RELEASE_VER := $(shell \
	grep -E '^[^%]*{navicc_release,[[:space:]]*".*"' relx.config | \
	grep -o '".*"' | \
	grep -o '[^\"]*'))

BUILD_DIR := $(CURDIR)/_rel/$(RELEASE_NAME)

deb:
	@echo "Release: [$(RELEASE_NAME)] ver: [$(RELEASE_VER)]"
	mkdir -p $(PACKAGE_DIR)/etc/init.d
	mkdir -p $(PACKAGE_DIR)/etc/$(PROJECT)

	mkdir -p $(PACKAGE_DIR)/opt/$(PROJECT)
	mkdir -p $(PACKAGE_DIR)/var/log/$(PROJECT)
	# mnesia here
	mkdir -p $(PACKAGE_DIR)/var/lib/$(PROJECT)

	cp -R $(BUILD_DIR)/*   $(PACKAGE_DIR)/opt/$(PROJECT)
	#
	install -p -m 0755 $(CURDIR)/etc/init                $(PACKAGE_DIR)/etc/init.d/$(PROJECT)
	#
	# install -p -m 0755 $(BUILD_DIR)/bin/$(RELEASE_NAME)  $(PACKAGE_DIR)/usr/lib/$(PROJECT)/bin/$(PROJECT)
	install -m644 $(CURDIR)/etc/sys.config            $(PACKAGE_DIR)/etc/$(PROJECT)/sys.config
	install -m644 $(CURDIR)/etc/vm.args               $(PACKAGE_DIR)/etc/$(PROJECT)/vm.args

	# fpm -s dir -t deb -n $(RELEASE_NAME) -v $(RELEASE_VER) .=/opt/$(RELEASE_NAME)
	mkdir -p $(CURDIR)/deploy

	fpm -s dir -t deb -f -n $(RELEASE_NAME) -v $(RELEASE_VER) \
		-p deploy/$(RELEASE_NAME)_$(RELEASE_VER)_amd64.deb \
		--after-install $(CURDIR)/etc/postinst \
		--after-remove  $(CURDIR)/etc/postrm \
		--config-files /etc/$(PROJECT)/sys.config \
		--config-files /etc/$(PROJECT)/vm.args \
		--deb-pre-depends adduser \
		--description $(DESCRIPTION) \
		-a native --url $(HOMEPAGE) \
		-C $(PACKAGE_DIR) etc opt var

publish:
	# @ssh $(server) "mkdir -p navicc" && scp rel/$(RELEASE_NAME)/$(RELEASE_NAME)-$(RELEASE_VER).tar.gz $(server):~/navicc/
	scp deploy/*.deb $(server):~
