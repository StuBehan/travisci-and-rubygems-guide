# frozen_string_literal: true

require 'something'

describe Something do
  describe '#add' do
    it 'adds something to something_else' do
      expect(subject.add).to eq(3)
    end
  end
end
