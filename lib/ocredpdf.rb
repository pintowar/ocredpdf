#require "ocredpdf/version"
require "find"

module Ocredpdf
  class Converter

        def initialize(source, target = nil, remove = false)
            @removable = remove
            @path = source
            @tmp_dir = '/tmp/ocr/'
            @target = (target)? target : (File.directory?(source)? source : File.dirname(source))
            throw "target and source should be the same (file or directory)." if ([@path, @target].map{|y| File.directory? y}.uniq.size > 1)
            @formats = ['tiff','tif','jpeg','jpg','gif','png']
            Dir.mkdir @tmp_dir if not File.exist? @tmp_dir
        end
        
        def execute
            if (File.directory? @path)
                Find.find(@path) do |f| 
                    convert f if not File.directory? f and @formats.map{|y| f.downcase.end_with? y}.include? true
                end
            else
                convert @path
            end
        end
        
        private
            def convertImage(img_path)
                name =  img_path.split('.')[0..-2].join("")
                target = @tmp_dir + File.basename(name)
                convert = "convert -monochrome -normalize -density 300 '#{img_path}' '#{target}.png'"
                puts convert
                system convert
            end
            
            def createHocr(png_path)
                name = png_path.split('.')[0..-2].join("")
                target = @tmp_dir + File.basename(name)
                tesser = "tesseract '#{png_path}' '#{target}.hocr' -l por hocr"
                puts tesser
                system tesser
            end

            def createPdf(hocr_path)
                name = hocr_path.split('.')[0..-3].join("")
                target = @tmp_dir + File.basename(name)
                hocr2pdf = "hocr2pdf -i '#{target}.png' -o '#{target}.pdf' < '#{hocr_path}'"
                puts hocr2pdf
                system hocr2pdf
            end
            
            def joinPdf()
                files = []
                Dir.foreach(@tmp_dir){|y| files << "'#{@tmp_dir + y}'" if y.end_with? "pdf"}
                names = files.map{|y| File.basename(y[1..-2])}
                result = nil
                if (names.size > 1)
                    result = @tmp_dir + names.first.split('-')[0..-2].join("") + ".pdf"
                    join = "pdfjam --fitpaper 'true' --suffix joined --outfile '" + result + "' -- " + files.join(" - ")
                    puts join
                    system join
                else
                    result = @tmp_dir + names.first
                end
                return result
            end

            def convert(file_path)
                convertImage file_path
                Dir.foreach(@tmp_dir){|y| createHocr(@tmp_dir + y) if y.end_with? "png"}
                Dir.foreach(@tmp_dir){|y| createPdf(@tmp_dir + y) if y.end_with? "hocr.html"}
                result = joinPdf
                File.delete(file_path) if @removable
                system "mv '#{result}' '#{@target}'" 
                puts "mv '#{result}' '#{@target}'" 
                bname = File.basename(file_path).split('.')[0..-2].join('.')
                Dir.foreach(@tmp_dir) do |y|
                    File.delete(@tmp_dir + y) if File.basename(y).start_with? bname
                end
            end
    end
end
