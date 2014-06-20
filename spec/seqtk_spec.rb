require 'bio/seqtk'
require 'tempfile'
include Bio::SeqTK

describe Kseq do
  it 'should parse simple FASTA files' do
    tmp = Tempfile.new 'fasta'
    tmp.puts ">A"
    tmp.puts "AAAATTTTCCCCGGGG"
    tmp.puts ">B comment"
    tmp.puts "GGGGTTTTCCCCAAAA"
    tmp.close

    kseq = Kseq.new tmp.path

    expect(kseq.read!).to be_true
    expect(kseq.name).to eq("A")
    expect(kseq.comment).to be_nil
    expect(kseq.seq).to eq("AAAATTTTCCCCGGGG")
    expect(kseq.qual).to be_nil

    expect(kseq.read!).to be_true
    expect(kseq.name).to eq("B")
    expect(kseq.comment).to eq("comment")
    expect(kseq.seq).to eq("GGGGTTTTCCCCAAAA")
    expect(kseq.qual).to be_nil

    expect(kseq.read!).to be_false
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

    expect(kseq.read!).to be_true
    expect(kseq.name).to eq("A")
    expect(kseq.comment).to be_nil
    expect(kseq.seq).to eq("AAAATTTTCCCCGGGG")
    expect(kseq.qual).to eq("AAAAAAAAAAAAAAAA")

    expect(kseq.read!).to be_true
    expect(kseq.name).to eq("B")
    expect(kseq.comment).to eq("comment")
    expect(kseq.seq).to eq("GGGGTTTTCCCCAAAA")
    expect(kseq.qual).to eq("IIIIIIIIIIIIIIII")

    expect(kseq.read!).to be_false
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

    expect(kseq.read!).to be_true
    expect(kseq.name).to eq("A")
    expect(kseq.comment).to be_nil
    expect(kseq.seq).to eq("AAAATTTTCCCCGGGG")
    expect(kseq.qual).to be_nil

    expect(kseq.read!).to be_true
    expect(kseq.name).to eq("B")
    expect(kseq.comment).to eq("comment")
    expect(kseq.seq).to eq("GGGGTTTTCCCCAAAA")
    expect(kseq.qual).to be_nil

    expect(kseq.read!).to be_false
  end
end
