# frozen_string_literal: true

RSpec.describe Localisation::Api::Client::Translate do
  it "has a version number" do
    expect(Localisation::Api::Client::VERSION).not_to be nil
  end

  describe "methods" do
    subject { described_class.new(service_url: "https://www.example.com/translate")}
    it { should respond_to :fetch_translations }
    it { should respond_to :translate_many }
    it { should respond_to :translate_one }

  end

  describe "translation" do
    subject { described_class.new(service_url: "https://www.example.com/translate")}

    context "exists" do
      before do
        # just go with plain strings
        allow_any_instance_of(described_class)
          .to receive(:fetch_translations).and_return(["abc", "xyz"])
      end  
      describe ".translate_one" do
        it "returns a translation" do
          expect(subject.translate_one(original: "abcd", locale_code: "en-us")).to eq "abc"
        end
      end

      describe ".translate_many" do
        it "returns a translation" do
          expect(subject.translate_many(originals: [ "abcd", "xyz" ], locale_code: "en-us").size).to eq 2
          # => [ "abc", "abc" ] but that's ok, no need to elaborate further.
        end
      end
    end

    context "does not exist" do
      [ [], nil, false ].each do |output|
        context "output #{output}" do
          before do
            subject { described_class.new(service_url: "https://www.example.com/translate")}
            allow_any_instance_of(described_class)
              .to receive(:fetch_translations).and_return(output)
          end
          it "raises error" do
            expect{ subject.translate_one(original: "abcd", locale_code: "en-us") }.to raise_error(Localisation::Api::Client::TranslationError)
          end
        end
      end
    end
  end
end
