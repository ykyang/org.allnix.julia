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

# Core Syntax
% https://myst-parser.readthedocs.io/en/latest/syntax/syntax.**html**
* **bold**
* *italic*
* `code`
* <https://www.example.com>
* [title](https://www.example.com)
* ![alt](https:///www.example.com/image.png)
* [label_13]: 
  * [title](label_13)
* <a name="label_14"></a>label_14
  * [title](myst.md#label_14)
* [link2]: https://www.example.com
* [title][link2]
* [link3]: #here
* [title][link3]
* 
* > quote

---

- Unordered list

1. Ordered list


opening ```lang to closing```

1.
+
List item one
+




