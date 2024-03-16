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

.PHONY: deps build format test lint live database_init database_drop
