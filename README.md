IIIF Manifest to PDF
-----

Using the excellent prawnpdf gem to convert IIIF manifest json urls to pdf
[Prawn manual](http://prawnpdf.org/manual.pdf)
[Prawn Documentation](http://prawnpdf.org/docs/0.11.1/Prawn/Document.html)

extract_IIIF.rb
===

This will identify the relevant Manifest version (2 or 3) and run the appropriate iteration.

To Use:
---

- Install dependencies `bundle install`
- You can start the Command Line Interface (CLI) with `lib/cocktail`

CLI Options:

- -a folio prefix (default = false)
- -b left footer content. Starts with copyright symbol.
- -c fill colour for image padding (default is black).
- -d fontpath. Path to custom ttf file (not required)
- -f Filename (default = manifest)
- -h help
- -i path to title page (default = /images/title.jpg)
- -j array start. First argument for range printing (not required)
- -k array length. Second argument for range printing (not required)
- -l Landscape or Portrait (this will autoomplete so l or p will suffice)
- -p Additional Padding (default = 10)
- -s Font size (default = 14)
- -t include title page (default = false)
- -u URL (Required)

Example CLI instructions for V3  
`lib/cocktail -u https://iiif.vam.ac.uk/collections/MSL:1876:Forster:141:I/manifest.json -l po -f v3test -t -s 14`

Example CLI instructions for V2  
`lib/cocktail -u https://iiif-int.vam.ac.uk/collections/MSL:1861:7446/manifest.json -l lan -f v2test -t -s 14`

Example Manifests:

V2 (best landscape) = https://iiif-int.vam.ac.uk/collections/MSL:1861:7446/manifest.json  
V3 (best portrait) = https://iiif.vam.ac.uk/collections/MSL:1876:Forster:141:I/manifest.json

To test (manual only):

For V3 Manifest:  
test3 = Cocktail.new('https://iiif.vam.ac.uk/collections/MSL:1876:Forster:141:I/manifest.json', 'portrait', 0, 14)  
test3.extract  
test3.insert_title  
test3.full_page_generation  
puts test3.manifest_version  
test3.save_as('v3test.pdf')  

For V2 Manifest:  
test2 = Cocktail.new('https://iiif-int.vam.ac.uk/collections/MSL:1861:7446/manifest.json', 'landscape', 0)  
test2.extract  
test2.insert_title  
test2.full_page_generation  
puts test2.manifest_version  
test2.save_as('v2test.pdf')  

Shout Outs
===

- How to colour a page in prawnpdf using this technique to [stroke a bounding box](https://stackoverflow.com/questions/17757298/how-to-add-background-fill-color-to-a-bounding-box-in-prawn).
