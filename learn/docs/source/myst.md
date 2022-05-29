% conda activate py38
% sphinx-quickstart
%   Separate source: y
% cd docs/
% make html
%
% https://myst-parser.readthedocs.io/en/latest/intro.html
% https://myst-parser.readthedocs.io/en/latest/docutils.html
%
% Copy myst-*-* from C:\Users\ykyan\local\mambaforge\envs\py38\Scripts
% python myst-docutils-html --help
% python myst-docutils-html learn_MyST.md learn_MyST.html
# My nifty title

Some **text**!

```{admonition} Here's my title
:class: tip

Here's my admonition content.<sup>1</sup>
```

