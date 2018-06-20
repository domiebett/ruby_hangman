require 'rspec'
require_relative '../lib/../lib/hangman'

RSpec.describe 'Hangman', '#guess' do

  before :each do
    @hang_man = HangMan.new
  end

  context 'When guess is provided' do
    it 'returns error if guess is wrong' do
      @hang_man.play

    end
  end
end