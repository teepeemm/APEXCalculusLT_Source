List Of Changes
=====================

Individual errors are detailed in [the errata directory](errata/)

Changes for the 2025-07 version:
--------------------

* The biggest change is that the pdf is now accessible according to Ally, Siteimprove, VeraPDF, and ~~PAC~~.  To make this happen, we needed several superficial changes.  Among the more notable

    * Prerequisite sections 1.0, 2.0, and 10.0 now come after the chapter heading and introduction, not before.
    
    * Adjusted page breaks means that the new version is a bit over 5% longer than the old.
    
    * We changed the font from Calibri to Lato and Lete Sans Math.

* All known errata (4) have been fixed.

Changes for the 2023-06 version:
--------------------

* Definition 10.3.2 (Normal line to a parametric curve) has been rearranged to no longer have an unnecessary "provided y'≠0".

* 13.6 and 15.2 both talked about how it's useful to think of del as an operator.  This isn't all that useful in 13.6, so we leave that discussion to 15.2.

* In 13.8, the definition of a critical point has been tightened from "grad=0 or one component undefined" to "each component is zero or undefined" (for example, x+|y| now has no cricital points instead of a continuum of critical points)

* Chapter 14 opened by talking about how the constant of integration in ∫ f_x(x,y) dx is an arbitrary function of y.  Since the chapter is about definite integration, and indefinite integration doesn't occur until 15.3 (which already commented about the arbitrary function), we have removed this remark.

* The formulas in the back of the book have been adjusted to include the formulas we have been distributing in Calc II.  A few more were added as well.

* Notes and notation:

	* In 1.5, a note has been added that theorems 1.3.1, 1.3.2, and 1.3.5 also hold in the case c=±infty.

	* In 9.6, a note has been added that n^(1/n) approaches 1 while (n!)^(1/n) approaches infinity (Knewton Alta likes to use the root test with factorials).

	* In 11.2, a note has been added that a vector can be freely scaled before normalizing.

	* In 13.3, a note has been added that ḟ (ie, $\dot f$) is an alternate notation for differentation with respect to time.

	* We now have a vector arrow over the del operator.

	* In Chapter 14, when evaluating the result of a multiple integral, we now have "x=" to indicate which variable is being evaluated.

* In 6.5, a different video is now being used.

* New exercises: 1.3#55, 3.3#25 (renumbering some subsequent review exercises), 12.5#37

* All known errata (42) have been fixed.

Changes for the 2021-06 version:
--------------------

* The html version now includes 3d images that can be manipulated within the browser.  Chrome doesn't seem to handle MathJax well, so Firefox seems to be the way to go.

* Within 5.3, "Riemann Sums", ∆x usually represents the width of a subinterval.  It also occasionally represented a partition of the interval.  A partition is now represented by P.

* Example 8.7.8 has been introduced, showing how to calculate n in order to achieve a desired accuracy in the Trapezoidal Rule.

* New exercises include: 2.1#31-32, 2.5#39-46, 4.4#24, 6.1#21-24, 7.3#21-24, 8.3#13-26, 9.2#53-58, 9.8#33-44&46.
Except for 4.4, each has subsequent exercises whose numbering has consequently changed.  9.8 is the only section also involving a change in parity of problem numbers.

* (Due to various reasons, the 2020-07 version did not have wide adoption.  You may want to also look at the changes for that version.)

Changes for the 2020-07 version:
--------------------

* A careful reading of Definition 3.3.1 shows that intervals of increasing and decreasing are usually closed within their domain.  We often had open intervals instead.

* Definition 10.3.1 (Tangent line to a parametric curve) has been rearranged to no longer have an unnecessary "provided x'≠0".

* Anthony Bevelacqua and John Collings contributed several exercises.

* New exercises include: 5.4#65, 6.3#18,  
  7.1#33-37, 7.3#31, 7.4#3-4, 7.4#41, 7.5#53-55,  
  8.1#53-56, 8.2#41, 8.3#27, 8.4#33-34, 8.4#39, 8.6#47-48,  
  9.1#52-53, 9.2#54-55, 9.3#15, 9.4#34, 9.5#27-28, 9.6#27, 10.3#51.  
  Those in 6.3, 7.4, and 8.4 have subsequent exercises whose numbering has consequently changed.

* All known errata (31+) have been fixed.

* After a fair bit of work (and some sweeping under the rug), we are down to two overfull hboxes and 10 undervull vboxes.

Changes for the 2019-06 version:
--------------------

* The preface now has a link to a library of the 3d images.  This page also has instructions for using an Android or iOS app to interactively view the images.

* The preface also has a link to an html version of the book.  As far as accessibility goes, pdf can't hope to compete with html.

* The criteria for the first derivative test have been weakened.

* Exercise 3.3#39 proves enough of Darboux's theorem for Key Idea 3.3.1.

* New examples: 6.3 (Using the Washer and Shell Methods), 9.8 (Reindexing a Power Series)

* New exercises in Sections 7.1, 8.5 (tangent half-angle substitution).

* A corrected proof for Theorem 9.4.1.

* Taylor's Theorem has a stronger conclusion regarding the bound on the error term.

* All known errata (106+) have been fixed.

Changes for the 2018-07 version:
---------------------

* We now have Chapter 15 written by the same author.  It is completely rearranged:
  * 15.1->15.1&15.3
  * 15.2->15.2&15.3
  * 15.3->15.2&15.4
  * 15.4->15.5,15.6,15.7
  * 15.5->15.1,15.3,15.7
  * 15.6(some)->15.2

* For the same reasons, Section 11.7 has moved to the beginning of Section 14.7.

* Some exercises have been added (and occasionally subtracted) throughout.  (The purpose of this was partly to make exercise sets with common instructions start with an odd number and end with an even, so that future changes won’t have to adjust the exercises’ parity.)

* By request of Chemistry, Section 13.7 has a short subsection on Taylor polynomials for f:R^2 -> R.

* Suppose f'(c)=0. Previously, we defined (c,f(c)) as the critical point, but were inconsistent about using point, value, or number.  To match Calc 3, we are defining c as the critical point, and f(c) as the critical value.

* The previous numbering was:
  * Theorem/Key Idea/Definition: #
  * Figure: chap.#
  * Example in same section: #
  * Example in other section: chap.sec.#  
  These have all been changed to the last format: chap.sec.#

* All known errata (54+) have been fixed.
