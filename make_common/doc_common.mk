SPHINXBUILD=sphinx-build
BUILDDIR=_build
PAPEROPT_a4=-D latex_paper_size=a4
PAPEROPT_letter=-D latex_paper_size=letter
ALLSPHINXOPTS=-d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
SPHINX_APIDOC=sphinx-apidoc

common_doc_api:
	for module in $(DOC_PACKAGES); do \
		$(SPHINX_APIDOC) -o $(SPHINX_DIR) --force $$module; \
	done

common_doc:
	@cd docs; $(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in docs/$(BUILDDIR)/html."
