# frozen_string_literal: true

require "github-polyglot"

RSpec.describe Adder do
  describe "#add" do
    context 'When num is 1' do
      let(:num) { 1 }

      it 'returns 3' do
        expect(described_class.new(num).add(2)).to eq(3)
      end
    end
  end
end
