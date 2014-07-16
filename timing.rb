require 'bio'
require 'bio/faster'
require 'bio/kseq'
require 'benchmark'
require 'tempfile'

tmp = Tempfile.new 'bio-kseq'

1.upto(100000) do |n|
  tmp.puts "@" + n.to_s + " " + "comment"
  tmp.puts "AAAAAAAAAAAAAAAAAAAAAAA"
  tmp.puts "+" + n.to_s + " " + "comment"
  tmp.puts "EEEEEEEEEEEEEEEEEEEEEEE"
end

tmp.close

Benchmark.bm do |x|
  x.report("BioRuby") do 
    Bio::FlatFile.open(Bio::Fastq, tmp.path).each_entry { |e| }
  end

  x.report("Bio::Faster") do
    fastq = Bio::Faster.new tmp.path
    fastq.each_record do |sequence_header, sequence, quality|
    end
  end

  x.report("Bio::Kseq") do 
    kseq = Bio::Kseq.new tmp.path
    while kseq.read! do
    end
  end
end
