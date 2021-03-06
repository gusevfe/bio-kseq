# Bio::Kseq [![Build Status](https://travis-ci.org/gusevfe/bio-kseq.svg?branch=master)](https://travis-ci.org/gusevfe/bio-kseq)

Ruby bindings for a very fast FASTA/Q parser [kseq.h](https://github.com/lh3/seqtk/blob/master/kseq.h) by Heng Li.

A default FASTA/Q parser from [BioRuby](http://bioruby.org) is extremly slow. One alternative is to use [bio-faster](https://github.com/fstrozzi/bioruby-faster) but that lacks support for FASTA files. However, `bio-faster` does parse qualities, unlike `bio-kseq`. 

## Timings
```
                 user     system     total          real
BioRuby      2.130000   0.270000   2.400000 (  2.403145)
Bio::Faster  0.420000   0.070000   0.490000 (  0.486809)
Bio::Kseq    0.030000   0.010000   0.040000 (  0.037176)
```

## Installation

Add this line to your application's Gemfile:

    gem 'bio-kseq'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bio-kseq

## Usage

```ruby
require 'bio/kseq'

# Convert FASTQ to FASTA
kseq = Bio::Kseq.new("test.fastq")
while kseq.read! # returns truthy values when there is an entry
  puts ">" + kseq.name 
  puts kseq.seq
end

kseq = Bio::Kseq.new("test.fastq.gz") # You can open GZIPed files flawlessly
kseq.read! or throw("Failed to read test.fastq.gz")

# Suppose entry is like this:
# @SRR001666.1 071112_SLXA-EAS1_s_7:5:1:817:345 length=36
# GGGTGATGGCCGCTGCCGATGGCGTCAAATCCCACC
# +SRR001666.1 071112_SLXA-EAS1_s_7:5:1:817:345 length=36
# IIIIIIIIIIIIIIIIIIIIIIIIIIIIII9IG9IC
kseq.name    # = "SRR001666.1"
kseq.comment # = "071112_SLXA-EAS1_s_7:5:1:817:345 length=36", may be nil
kseq.seq     # = "GGGTGATGGCCGCTGCCGATGGCGTCAAATCCCACC"
kseq.qual    # = "IIIIIIIIIIIIIIIIIIIIIIIIIIIIII9IG9IC", may be nil

kseq = Bio::Kseq.new(IO.popen("zcat test.fastq.gz")) # You can also process Ruby IO objects
kseq.read! or throw("Failed to read test.fastq.gz")
puts kseq # Outputs a valid FASTQ entry
```

## Contributing

1. Fork it ( http://github.com/gusevfe/bio-kseq/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
