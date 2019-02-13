IIIF Manifest to PDF
-----

Using the prawnpdf gem to convert IIIF manifest json urls to pdf
[Prawn manual](http://prawnpdf.org/manual.pdf)
[Prawn Documentation](http://prawnpdf.org/docs/0.11.1/Prawn/Document.html)

combineIIIF.rb
===

This will identify the relevant Manifest version and run the appropriate iteration.

To Use:
---

- Install dependencies `bundle install`
- You can start the Command Line Interface (CLI) with `ruby lib/options.rb`

CLI Options:

- -u URL
- -l Landscape or Portrait
- -p Additional Padding (not required)
- -f Filename
- -t include title page
- -tp path to title page

Example Manifests:

V2 (best landscape) = https://iiif-int.vam.ac.uk/collections/MSL:1861:7446/manifest.json  
V3 (best portrait) = https://iiif.vam.ac.uk/collections/MSL:1876:Forster:141:I/manifest.json

To test (no tests yet written):

- This command will run both the rspec tests and simplecov `bundle exec rspec`
- To view the coverage detail as a webpage run `open coverage/index.html`
