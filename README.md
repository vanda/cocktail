IIIF Manifest to PDF
-----

Using the prawnpdf gem to convert IIIF manifest json urls to pdf
[Prawn manual](http://prawnpdf.org/manual.pdf)
[Prawn Documentation](http://prawnpdf.org/docs/0.11.1/Prawn/Document.html)

combineIIIF.rb
===

This will identify the relevant Manifest version and run the appropriate iteration.

consoleTest.rb
===

This one just iterates through the parsed JSON file and prints to console. It's useful for debugging.

iiif2.rb
===

This uses the mixin method of Prawn and generates a new document with layout options when the new class is instantiated. It works with the IIIF V2 Manifest.

iiif3.rb
===

This uses the mixin method of Prawn and generates a new document with layout options when the new class is instantiated. It works with the IIIF V3 Manifest.

To Use:
---

- Install dependencies `bundle install`
- You can start the Command Line Interface (CLI) with `ruby bin/main`

Example Manifests:

V2 (best landscape) = https://iiif-int.vam.ac.uk/collections/MSL:1861:7446/manifest.json
V3 (best portrait) = https://iiif.vam.ac.uk/collections/MSL:1876:Forster:141:I/manifest.json

To test (no tests yet written):

- This command will run both the rspec tests and simplecov `bundle exec rspec`
- To view the coverage detail as a webpage run `open coverage/index.html`
