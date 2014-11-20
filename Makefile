# See LICENSE for licensing information.

PROJECT = navicc

# Options.
# -Werror
ERLC_OPTS ?= +debug_info +warn_export_all +warn_export_vars \
	+warn_shadow_vars +warn_obsolete_guard +warn_missing_spec \
	+'{parse_transform, lager_transform}'

# COMPILE_FIRST = cowboy_middleware cowboy_sub_protocol
CT_OPTS +=  -spec test.spec \
			-cover test/cover.spec \
			-erl_args -config test/test.config

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

include erlang.mk

# Also dialyze the tests.
# DIALYZER_OPTS += --src -r test
test-shell: app
	erl -pa ebin -pa deps/*/ebin -pa test -s navicc -config test/test.config
