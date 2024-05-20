mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
gdk_backend := $(shell [ -f "/etc/arch-release" ] && echo GDK_BACKEND=x11 || echo '')

deps:
	mix deps.get
	mix setup

build:
	mix deps.compile

format:
	mix format --check-formatted

test: format
	mix test

lint:
	mix credo

live:
	$(gdk_backend) iex -S mix phx.server

database_init:
	mix ecto.create
	mix ecto.migrate
	mix run priv/repo/seeds.exs # populate with data

database_drop:
	mix ecto.drop --force-drop --no-compile

deploy:
	@ssh root@slivce.net -t 'rm -rf /var/server/slivce || true'
	@rsync -vrP --delete-after \
		lib \
		priv \
		assets \
		.formatter.exs \
		mix.exs \
		mix.lock root@slivce.net:/var/server/slivce
	@ssh root@slivce.net -t 'mkdir -p /var/server/slivce/config'
	@rsync -vrP --delete-after \
		config/config.exs \
		config/runtime.exs \
		config/prod.exs root@slivce.net:/var/server/slivce/config
	@rsync -vrP --delete-after build.sh root@slivce.net:/var/server/slivce
	@ssh root@slivce.net -t 'bash /var/server/slivce/build.sh slivce compile'
	@ssh root@slivce.net -t 'systemctl restart slivce.service'

.PHONY: deps build format test lint live database_init database_drop deploy
