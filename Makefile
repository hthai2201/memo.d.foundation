setup:
	@if ! command -v devbox >/dev/null 2>&1; then curl -fsSL https://get.jetpack.io/devbox | bash; fi
	@devbox install
	@mkdir -p ./content

fetch:
	@mix run -e 'Memo.UpdateGitSettings.run()'
	@./git-fetch.sh

build:
	@make clear-build
	@mix run -e 'Memo.ExportMarkdown.run("vault", "content")'
	@hugo -DEF --minify

clear-build:
	@rm -rf public || true
	@mkdir -p public
	@rm -rf content

run:
	@make clear-build
	@mix run -e 'Memo.ExportMarkdown.run("vault", "content")'
	@hugo -DEF --poll 2s --logLevel error server
	
watch-run:
	@make clear-build
	@mix run -e 'Memo.Application.watch_run("vault", "content")'

duckdb-export:
	@rm -f vault.duckdb
	@mix run -e 'Memo.Application.export_duckdb("vault", "parquet", "HEAD~5")'

duckdb-export-all:
	@rm -f vault.duckdb
	@mix run -e 'Memo.Application.export_duckdb("vault", "parquet", :all)'

duckdb-export-pattern:
	@rm -f vault.duckdb
	@mix run -e 'Memo.Application.export_duckdb("vault", "parquet", :all, "$(pattern)")'

sync-hashnode:
	@mix run -e 'Memo.Application.sync_hashnode("vault")'
