SPHINXBUILD=sphinx-build
BUILDDIR=docs/_build
PAPEROPT_a4=-D latex_paper_size=a4
PAPEROPT_letter=-D latex_paper_size=letter
ALLSPHINXOPTS=-d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .

common_doc:
	@cd docs; $(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in docs/$(BUILDDIR)/html."