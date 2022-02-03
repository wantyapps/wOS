# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# import os
# import sys
# sys.path.insert(0, os.path.abspath('.'))


# -- Project information -----------------------------------------------------

project = 'wOS'
copyright = '2022, Uri Arev, Yuval Maya'
author = 'Uri Arev, Yuval Maya'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = []

try:
    makefile_version = None
    makefile_patchlevel = None
    for line in open('../Makefile'):
        key, val = [x.strip() for x in line.split('=', 2)]
        if key == 'VERSION':
            makefile_version = val
        elif key == 'PATCHLEVEL':
            makefile_patchlevel = val
        if makefile_version and makefile_patchlevel:
            break
except:
    pass
finally:
    if makefile_version and makefile_patchlevel:
        version = release = makefile_version + '.' + makefile_patchlevel
    else:
        version = release = "unknown version"

# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'sphinx_rtd_theme'
if html_theme == 'sphinx_rtd_theme' or html_theme == 'sphinx_rtd_dark_mode':
    # Read the Docs theme
    try:
        import sphinx_rtd_theme
        html_theme_path = [sphinx_rtd_theme.get_html_theme_path()]

        # Add any paths that contain custom static files (such as style sheets) here,
        # relative to this directory. They are copied after the builtin static files,
        # so a file named "default.css" will overwrite the builtin "default.css".
        html_css_files = [
            'theme_overrides.css',
        ]

        # Read the Docs dark mode override theme
        if html_theme == 'sphinx_rtd_dark_mode':
            try:
                import sphinx_rtd_dark_mode
                extensions.append('sphinx_rtd_dark_mode')
            except ImportError:
                html_theme == 'sphinx_rtd_theme'

        if html_theme == 'sphinx_rtd_theme':
                # Add color-specific RTD normal mode
                html_css_files.append('theme_rtd_colors.css')

    except ImportError:
        html_theme = 'classic'


# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['static']
