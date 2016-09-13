# See LICENSE for licensing information.
.SILENT:

PROJECT = navicc
DESCRIPTION = "GPS Tracking"
HOMEPAGE = "http://new.navi.cc/"
PACKAGE_DIR = $(CURDIR)/build

$(eval RELEASE_NAME := $(shell \
	grep -E '^[^%]*{release,.*' relx.config | \
	grep -o ' {.*, "' | \
	grep -o '[^ {,"]*'))

ifdef TRAVIS_TAG
RELEASE_VER=$(TRAVIS_TAG)
else
# RELEASE_VER:=`git describe --tags HEAD`
RELEASE_VER:=$(shell git describe --tags --long HEAD)
endif

#
# use this like:
# 'make print-PATH print-CFLAGS make print-ALL_OBJS'
# to see the value of make variable PATH and CFLAGS, ALL_OBJS, etc.
#
print-%:
	@echo $* is $($*)

# $(eval RELEASE_VER := $(shell \
# 	grep -E '^[^%]*{navicc_release,[[:space:]]*".*"' relx.config | \
# 	grep -o '".*"' | \
# 	grep -o '[^\"]*'))


# Options.
# -Werror
# ERLC_OPTS ?= +debug_info +warn_export_all +warn_export_vars \
# 	+warn_shadow_vars +warn_obsolete_guard +warn_missing_spec \
# 	+'{parse_transform, lager_transform}'
ERLC_OPTS := +warn_unused_vars +warn_export_all +warn_shadow_vars
ERLC_OPTS += +warn_unused_import +warn_unused_function +warn_bif_clash
ERLC_OPTS += +warn_unused_record +warn_deprecated_function +warn_obsolete_guard
ERLC_OPTS += +strict_validation +warn_export_vars +warn_exported_vars
ERLC_OPTS += +warn_missing_spec +warn_untyped_record +debug_info
ERLC_OPTS += +'{parse_transform, lager_transform}'

# COMPILE_FIRST = cowboy_middleware cowboy_sub_protocol
CT_OPTS +=  -spec test.spec \
			-cover test/cover.spec \
			-erl_args -config test/test.config
# -boot start_sasl \

# PLT_APPS = crypto public_key

# Dependencies.

# bear not got automaticaly by folsom, bug?
DEPS = lager naviapi navipoint naviws navistats recon
# TEST_DEPS = ct_helper gun

TEST_DEPS = gun xref_runner
# dep_ct_helper = git https://github.com/extend/ct_helper.git master

dep_naviapi = git git://github.com/baden/naviapi.git master
dep_navipoint = git git://github.com/baden/navipoint.git master
dep_naviws = git git://github.com/baden/naviws.git master
dep_navistats = git git://github.com/baden/navistats.git master
dep_recon = git git://github.com/ferd/recon.git master


# RELX_OPTS = -o rel release tar
# RELX_OUTPUT_DIR = rel
# RELX_OPTS = -o build/_rel release tar
# RELX_OUTPUT_DIR = $(PACKAGE_DIR)/usr/lib

BUILD_DEPS = elvis_mk
DEP_PLUGINS = elvis_mk

dep_elvis_mk = git https://github.com/inaka/elvis.mk.git 1.0.0

# BUILD_DEPS += rlx_prv_cmd

dep_rlx_prv_cmd = git https://github.com/wmealing/rlx_prv_cmd.git 0.1.0

EDOC_DIRS := ["src"]
EDOC_OPTS := {preprocess, true}, {source_path, ${EDOC_DIRS}}, nopackages, {subpackages, true}


# RLX_PRV_CMD ?= $(CURDIR)/rlx_prv_cmd.beam
# RLX_PRV_CMD_URL ?= https://github.com/erlangninja/rlx_prv_cmd/releases/download/0.1.0/rlx_prv_cmd.beam
# define get_rlx_prv_cmd
# 	curl -s -L -o $(RLX_PRV_CMD) $(RLX_PRV_CMD_URL) || rm $(RLX_PRV_CMD)
# endef
# export RLX_PRV_CMD
#
# $(RLX_PRV_CMD):
# 	@$(call get_rlx_prv_cmd)
#
# rel:: $(RLX_PRV_CMD)

include erlang.mk

# Also dialyze the tests.
# DIALYZER_OPTS += --src -r test
test-shell: app
	erl -pa ebin -pa deps/*/ebin -pa test -s navicc -config test/test.config

test-local: app
	erl -pa ebin -pa deps/*/ebin -pa test -s navicc -config test/local.config

# run: rel
# 	$(PACKAGE_DIR)/usr/lib/$(RELEASE_NAME)/bin/$(RELEASE_NAME) console

observer:
	erl -sname test -setcookie 123 -s observer


# BUILD_DIR := $(CURDIR)/_rel/$(RELEASE_NAME)

deb:
	@echo "Release: [$(RELEASE_NAME)] ver: [$(RELEASE_VER)]"
	@cp -R $(CURDIR)/files/*   $(PACKAGE_DIR)/
	@mkdir -p $(PACKAGE_DIR)/var/log/$(RELEASE_NAME)
	@mkdir -p $(PACKAGE_DIR)/var/lib/$(RELEASE_NAME)

	@fpm -f -s dir -t deb \
		-n $(RELEASE_NAME) \
		--version $(RELEASE_VER) \
		-a native \
		--workdir       $(CURDIR)/debian \
		--deb-upstart   $(CURDIR)/debian/upstart/$(RELEASE_NAME) \
		--after-install $(CURDIR)/debian/postinst \
		--before-remove $(CURDIR)/debian/prerm \
		--after-remove  $(CURDIR)/debian/postrm \
		-C $(PACKAGE_DIR) \
		etc usr var
	@mkdir -p deploy
	@mv -f $(RELEASE_NAME)_$(RELEASE_VER)_amd64.deb deploy/

# mkdir -p $(PACKAGE_DIR)/etc/init.d
# mkdir -p $(PACKAGE_DIR)/etc/$(PROJECT)

#
# mkdir -p $(PACKAGE_DIR)/opt/$(PROJECT)

#
# cp -R $(BUILD_DIR)/*   $(PACKAGE_DIR)/opt/$(PROJECT)
# #
# # install -p -m 0755 $(CURDIR)/etc/init                $(PACKAGE_DIR)/etc/init.d/$(PROJECT)
# #
# # install -p -m 0755 $(BUILD_DIR)/bin/$(RELEASE_NAME)  $(PACKAGE_DIR)/usr/lib/$(PROJECT)/bin/$(PROJECT)
# install -m644 $(CURDIR)/etc/sys.config            $(PACKAGE_DIR)/etc/$(PROJECT)/sys.config
# install -m644 $(CURDIR)/etc/vm.args               $(PACKAGE_DIR)/etc/$(PROJECT)/vm.args
#
# # fpm -s dir -t deb -n $(RELEASE_NAME) -v $(RELEASE_VER) .=/opt/$(RELEASE_NAME)
# mkdir -p $(CURDIR)/deploy

# fpm -s dir -t deb -f -n $(RELEASE_NAME) -v $(RELEASE_VER) \
# fpm -s dir -t deb -f -n $(RELEASE_NAME) \
# 	--version `git describe --tags --long` \
# 	--workdir debian \
# 	# -p deploy/$(RELEASE_NAME)_$(RELEASE_VER)_amd64.deb \
# 	--after-install $(CURDIR)/etc/debian/postinst \
# 	--after-remove  $(CURDIR)/etc/debian/postrm \
# 	--deb-upstart debian/upstart/navicc \
# 	--config-files /etc/$(PROJECT)/sys.config \
# 	--config-files /etc/$(PROJECT)/vm.args \
# 	--deb-pre-depends adduser \
# 	--description $(DESCRIPTION) \
# 	-a native --url $(HOMEPAGE) \
# 	-C $(PACKAGE_DIR) etc opt var

TAR_FILE = deploy/$(RELEASE_NAME)-$(RELEASE_VER).tar.gz
TAR_FILE_ABS = $(abspath $(TAR_FILE))

tarball: rel
	cd _rel; \
	tar cvzf $(TAR_FILE) $(RELEASE_NAME)

distclean-deb:
	$(gen_verbose) rm -rf $(PACKAGE_DIR)
	$(gen_verbose) rm -rf deploy/

distclean:: distclean-deb

# server="ubuntu@192.168.0.101"

publish-to-het2.baden.work:
	cd _rel; \
	rsync -avz -e ssh navicc-server baden@het2.baden.work:~/navicc-server/
	# @ssh $(server) "mkdir -p navicc" && scp rel/$(RELEASE_NAME)/$(RELEASE_NAME)-$(RELEASE_VER).tar.gz $(server):~/navicc/
	# scp deploy/*.deb $(server):~
