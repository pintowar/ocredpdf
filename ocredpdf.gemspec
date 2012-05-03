# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ocredpdf/version"

Gem::Specification.new do |s|
  s.name        = "ocredpdf"
  s.version     = Ocredpdf::VERSION
  s.authors     = ["Thiago Oliveira Pinheiro"]
  s.email       = ["pintowar@gmail.com"]
  s.homepage    = ""
  s.summary     = "Generate a PDF with OCR from an image"
  s.description = "Generate a PDF with OCR from an image"

  s.rubyforge_project = "ocredpdf"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) } << 'ocredpdf'
  s.require_paths = ["lib"]
  
  s.requirements << 'ImageMagick, v6.6.0-4 or greater'
  s.requirements << 'Tesseract, v3.0.2 or greater'
  s.requirements << 'Leptonica, v1.6.8 or greater'
  s.requirements << 'hOCR, v0.8.2 or greater'
  s.requirements << 'hOCR to PDF converter, v0.8.5 or greater'
  s.requirements << 'PDFjam, v2.0.5 or greater'
  
  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
