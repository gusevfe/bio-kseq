require 'bio/kseq'
require 'tempfile'

include Bio

describe Kseq do
  it 'should parse simple FASTA files' do
    tmp = Tempfile.new 'fasta'
    tmp.puts ">A"
    tmp.puts "AAAATTTTCCCCGGGG"
    tmp.puts ">B comment"
    tmp.puts "GGGGTTTTCCCCAAAA"
    tmp.close

    kseq = Kseq.new tmp.path

    expect(kseq.read!).to be_truthy 
    expect(kseq.name).to eq("A")
    expect(kseq.comment).to be_nil
    expect(kseq.seq).to eq("AAAATTTTCCCCGGGG")
    expect(kseq.qual).to be_nil

    expect(kseq.read!).to be_truthy 
    expect(kseq.name).to eq("B")
    expect(kseq.comment).to eq("comment")
    expect(kseq.seq).to eq("GGGGTTTTCCCCAAAA")
    expect(kseq.qual).to be_nil

    expect(kseq.read!).to be_falsey
  end

  it 'should parse simple FASTQ files' do
    tmp = Tempfile.new 'fasta'
    tmp.puts "@A"
    tmp.puts "AAAATTTTCCCCGGGG"
    tmp.puts "+"
    tmp.puts "AAAAAAAAAAAAAAAA"
    tmp.puts "@B comment"
    tmp.puts "GGGGTTTTCCCCAAAA"
    tmp.puts "+"
    tmp.puts "IIIIIIIIIIIIIIII"
    tmp.close

    kseq = Kseq.new tmp.path

    expect(kseq.read!).to be_truthy
    expect(kseq.name).to eq("A")
    expect(kseq.comment).to be_nil
    expect(kseq.seq).to eq("AAAATTTTCCCCGGGG")
    expect(kseq.qual).to eq("AAAAAAAAAAAAAAAA")

    expect(kseq.read!).to be_truthy
    expect(kseq.name).to eq("B")
    expect(kseq.comment).to eq("comment")
    expect(kseq.seq).to eq("GGGGTTTTCCCCAAAA")
    expect(kseq.qual).to eq("IIIIIIIIIIIIIIII")

    expect(kseq.read!).to be_falsey
  end

  it 'should read from IO' do
    tmp = Tempfile.new 'fasta'
    tmp.puts ">A"
    tmp.puts "AAAATTTTCCCCGGGG"
    tmp.puts ">B comment"
    tmp.puts "GGGGTTTTCCCCAAAA"
    tmp.close

    io = File.open(tmp.path)

    kseq = Kseq.new io

    expect(kseq.read!).to be_truthy
    expect(kseq.name).to eq("A")
    expect(kseq.comment).to be_nil
    expect(kseq.seq).to eq("AAAATTTTCCCCGGGG")
    expect(kseq.qual).to be_nil

    expect(kseq.read!).to be_truthy
    expect(kseq.name).to eq("B")
    expect(kseq.comment).to eq("comment")
    expect(kseq.seq).to eq("GGGGTTTTCCCCAAAA")
    expect(kseq.qual).to be_nil

    expect(kseq.read!).to be_falsey
  end

  it 'should read comment' do
    tmp = Tempfile.new 'fasta'
    tmp.puts "@SRR001666.1 071112_SLXA-EAS1_s_7:5:1:817:345 length=36"
    tmp.puts "GGGTGATGGCCGCTGCCGATGGCGTCAAATCCCACC"
    tmp.puts "+SRR001666.1 071112_SLXA-EAS1_s_7:5:1:817:345 length=36"
    tmp.puts "IIIIIIIIIIIIIIIIIIIIIIIIIIIIII9IG9IC"
    tmp.close

    kseq = Kseq.new tmp.path
    expect(kseq.read!).to be_truthy
    expect(kseq.comment).to eq("071112_SLXA-EAS1_s_7:5:1:817:345 length=36")
  end
end
