# Builds all dhall entrypoints
check_syntax:
	# globstar doesn't work on macOS bash :facepalm:, so we can't glob
	# xargs will short-circuit if a command fails with code 255
	find ./src/ -name "*.dhall" -print0 | xargs -I{} -0 -n1 bash -c 'echo "{}" &&  dhall --file {} > /dev/null || exit 255'

check_lint:
	find ./src/ -name "*.dhall" -print0 | xargs -I{} -0 -n1 bash -c 'echo "{}" && dhall --ascii lint --check --inplace {} || exit 255'

check_format:
	find ./src/ -name "*.dhall" -print0 | xargs -I{} -0 -n1 bash -c 'echo "{} format" && dhall --ascii format --check --inplace {} || exit 255'

lint:
	find ./src/ -name "*.dhall" -print0 | xargs -I{} -0 -n1 bash -c 'echo "{}" && dhall --ascii lint --inplace {} || exit 255'

format:
	find ./src/ -name "*.dhall" -print0 | xargs -I{} -0 -n1 bash -c 'echo "{}" && dhall --ascii format --inplace {} || exit 255'

format_examples:
	find ./examples/ -name "*.dhall" -print0 | xargs -I{} -0 -n1 bash -c 'echo "{}" && dhall --ascii format --inplace {} || exit 255'

lint_examples:
	find ./examples/ -name "*.dhall" -print0 | xargs -I{} -0 -n1 bash -c 'echo "{}" && dhall --ascii format --inplace {} || exit 255'


all_checks: check_syntax lint format lint_examples format_examples

clean:
	rm -rf ./releases/

generate:
	./release/generate.sh

release: clean all_checks generate upload

upload_release:
	aws s3 sync releases s3://dhall.packages.minaprotocol.com/buildkite/releases --acl public-read


.PHONY: check_syntax check_lint check_format lint format all_checks clean generate upload release