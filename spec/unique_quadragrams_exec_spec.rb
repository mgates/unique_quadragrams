require 'open3'
require 'tempfile'
require 'spec_helper'

describe "the unique quadragrams app" do
  describe "when run without enough arguments" do
    it "should output a lovely usage message with no arguments" do
      stdout, stderr, code = run_with()
      expect(stderr).to match /There weren't enough arguments./
      expect(stderr).to match /usage:/
    end

    it "should exit with a non-zero status if there aren't enough arguments" do
      stdout, stderr, code = run_with()
      expect(code).to_not eq 0
    end

    it "should fail if the dictionary file doesn't exist" do
      stdout, stderr, code = run_with("", "/tmp/nothing_here", '-', '-')
      expect(stderr).to match /The dictionary file doesn't exist./
    end
  end

  describe "with stdin as the dictionary" do
    it "doesn't complain" do
      stdout, stderr, code = run_with("", "-", '-', '-')
      expect(code).to eq 0
    end

    it "reads from the dictionary" do
      stdout, stderr, code = run_with("labs", "-", '-', '-')
      expect(stdout).to match 'labs'
    end

  end

  describe "with extant output files" do
    it "should fail if the quads file exists" do
      quads = Tempfile.new("quads")
      stdout, stderr, code = run_with("", '-', quads.path, '-')
      expect(stderr).to match /exists; use -f to overwrite it./
    end

    it "should fail if the words file exists" do
      words = Tempfile.new("words").path
      stdout, stderr, code = run_with("", '-', '-', words)
      expect(stderr).to match /exists; use -f to overwrite it./
    end

    it "should overwrite the words file with -f" do
      words = Tempfile.new("words")
      words.close
      stdout, stderr, code = run_with("labs", '-f', '-', '-', words.path)
      expect(File.read(words.path)).to match /labs/
    end

    it "should overwrite the quads file with -f" do
      quads = Tempfile.new("quads")
      quads.close
      stdout, stderr, code = run_with("labs", '-f', '-', quads.path, '-')
      expect(File.read(quads.path)).to match /labs/
    end
  end

  it "should put newlines at the end of each file" do
    stdout, stderr, code = run_with("labs", '-f', '-', '-', '-')
    expect(stdout).to eq "labs\nlabs\n"
  end

  def run_with(stdin = "", *args)
    bin = File.expand_path('../../bin/unique_quadragrams', __FILE__)
    Open3.capture3([bin, *args].join(" "), :stdin_data => stdin)
  end
end
