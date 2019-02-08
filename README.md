IIIF Manifest to PDF
-----

Using the prawnpdf gem to convert IIIF manifest json urls to pdf
[Prawn manual](http://prawnpdf.org/manual.pdf)
[Prawn Documentation](http://prawnpdf.org/docs/0.11.1/Prawn/Document.html)

Hello.rb
===

This one just iterates through the parsed JSON file and prints to console.

Mixin.rb
===

This one actually uses the prawn class to print the images to pdf

To Do:
- [] Sort out a better regex method for resizing IIIF images as /full/full/ is not comprehensive enough
- [] Uses the explicit method and create a custom prawn document to avoid the self issue
