# Editing UltiSnips snippets

- While editing snippets, if updates are not active yet in a test buffer use
    :call UltiSnips#RefreshSnippets()
  to refresh the snippets.

- Snippet sections that start with '!p' are Python scripts with some
  predefined objects, see :h UltiSnips-python for details. The 'snip' object
  is defined in the file
    .../.vim/plugged/ultisnips/pythonx/UltiSnips/text_objects/python_code.py
