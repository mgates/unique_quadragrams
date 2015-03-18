require 'spec_helper'
require 'benchmark'

describe UniqueQuadragrams do
  it "produces nothing when it has no input" do
    quads, words = get_results("")
    expect(quads).to eq ""
    expect(words).to eq ""
  end

  it "produces a quad and a word for 1 4 letter word" do
    quads, words = get_results("woot")
    expect(quads).to eq "woot"
    expect(words).to eq "woot"
  end

  it "produces two pairs in the same order" do
    string = "root\nbeer"
    quads, words = get_results(string)
    expect(quads).to eq string
    expect(words).to eq string
  end

  it "produces two lines on one five char line" do
    quads, words = get_results("Hello")
    expect(quads.lines.count).to eq 2
    expect(words.lines.count).to eq 2
  end

  it "produces nothing on repeated word" do
    quads, words = get_results("Labs\nLabs")
    expect(quads).to eq ""
    expect(words).to eq ""
  end

  it "is case insensitive" do
    quads, words = get_results("Labs\nlabs")
    expect(quads).to eq ""
    expect(words).to eq ""
  end

  it "doesn't have quads that have non-letters" do
    quads, words = get_results("Hell0")
    expect(quads).to eq "hell"
    expect(words).to eq "Hell0"
  end

  it "should run in roughly linear time", :benchmark do
    dict = "/usr/share/dict/words"
    fail "Can't find system dictionary" unless File.exist?(dict)
    line_count = File.foreach(dict).count
    GC.disable
    full_run = Benchmark.measure { get_results(File.read(dict)) }.total

    GC.disable
    half = File.foreach(dict).first(line_count / 2).join
    half_run = Benchmark.measure { get_results(half) }.total

    quarter = half.lines.first(line_count / 4).join
    quarter_run = Benchmark.measure { get_results(quarter) }.total

    expect(full_run).to be_within(20).percent_of(half_run * 2)
    expect(full_run).to be_within(20).percent_of(quarter_run * 4)
  end

  def get_results(dictionary)
    dict, quads, words = StringIO.new(dictionary), StringIO.new, StringIO.new
    subject.find(dict, quads, words)
    quads.rewind
    words.rewind
    [quads.read.chomp, words.read.chomp]
  end
end
