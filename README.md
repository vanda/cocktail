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

To test (manual only):

For V3 Manifest:  
test3 = ManifestPDF.new('https://iiif.vam.ac.uk/collections/MSL:1876:Forster:141:I/manifest.json', 'portrait', 0, 14)  
test3.extract  
test3.insert_title  
test3.page_generation  
puts test3.manifest_version  
test3.save_as('hash.pdf')  

For V2 Manifest:  
test2 = ManifestPDF.new('https://iiif-int.vam.ac.uk/collections/MSL:1861:7446/manifest.json', 'landscape', 0)  
test2.iterate  
puts test2.manifest_version  
test2.save_as('v2.pdf')  
