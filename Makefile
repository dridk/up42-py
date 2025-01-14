SRC := .

env:
	mkvirtualenv --python=$(which python3.8) up42-py
	workon up42-py

install:
	pip install up42-py

install[dev]:
	pip install -r $(SRC)/requirements.txt
	pip install -e .
	pip install -r $(SRC)/requirements-dev.txt
	pip install -r $(SRC)/requirements-docs.txt
	unlink $(PWD)/docs/examples; ln -s $(PWD)/examples docs

test:
	bash test.sh

test[live]:
	bash test.sh --live

e2e:
	python $(SRC)/tests/e2e.py

serve:
	ln -sfn $(PWD)/examples docs
	ln -sfn $(PWD)/docs/examples/guides docs
	ln -sfn $(PWD)/CHANGELOG.md docs
	mkdocs serve

gh-pages:
	ln -sfn $(PWD)/examples docs
	ln -sfn $(PWD)/docs/examples/guides docs
	ln -sfn $(PWD)/CHANGELOG.md docs
	mkdocs gh-deploy -m "update gh-pages [ci skip]"

package:
	python setup.py sdist bdist_wheel
	twine check dist/*

upload:
	twine upload dist/*

clean:
	find . -name "__pycache__" -exec rm -rf {} +
	find . -name ".mypy_cache" -exec rm -rf {} +
	find . -name ".pytest_cache" -exec rm -rf {} +
	find . -name ".coverage" -exec rm -f {} +
