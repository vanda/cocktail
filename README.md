IIIF Manifest to PDF
-----

Using the prawnpdf gem to convert IIIF manifest json urls to pdf
[Prawn manual](http://prawnpdf.org/manual.pdf)
[Prawn Documentation](http://prawnpdf.org/docs/0.11.1/Prawn/Document.html)

consoleTest.rb
===

This one just iterates through the parsed JSON file and prints to console.

Mixin.rb
===

This one actually uses the prawn class to print the images to pdf

To Do:
- [x] Sort out a better regex method for resizing IIIF images as /full/full/ is not comprehensive enough
- [] Sort out regex so it can deal with the following options (at the moment it misses the last example)
- https://framemark.vam.ac.uk//collections/2006AW1774/140,870,1800,1778/full/0/default.jpg
- https://framemark.vam.ac.uk//collections/2006AW1878/full/full/0/default.jpg
- https://framemark.vam.ac.uk//collections/2006AW1879/full/full/180/default.jpg
- [] Uses the explicit method and create a custom prawn document to avoid the self issue

To Use:
---

- Install dependencies `bundle install`

To test:

- This command will run both the rspec tests and simplecov `bundle exec rspec`
- To view the coverage detail as a webpage run `open coverage/index.html`
