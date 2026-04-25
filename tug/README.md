TUG Articles
==========

Source files for TUG articles and presentations for July 2026.

* **a11yBookPaper**: article for TUGboat discussing how we made the Calculus textbook accessible
* **a11yBookTalk**: presentation for TUG discussing how we made the Calculus textbook accessible
* **a11yPresPaper**: article for TUGboat discussing how to make accessible presentations with ltx-talk
* **a11yPresTalk**: presentation for TUG discussing how to make accessible presentations with ltx-talk

**exampleDesc.tex** and **exampleMatrix.tex** are used four different ways:

1, 2. The **a11yPres...** documents `\lstinputlisting` the code for discussion

3, 4. **a11yPresTalk** and **tugFigs** `\input` the code for execution to display the results

**a11yPresPaper** then uses the graphics that are the pages from tugFigs.pdf, so the latter should be compiled first.

**a11yPresTalk** needs to be compiled with lualatex-dev
