# frozen_string_literal: true

require 'github_polyglot'
require 'octokit'

RSpec.describe GithubPolyglot do
  describe '#username' do
    context 'when username is set on initialization' do
      let(:username) { 'foo' }

      it 'returns the username' do
        polyglot = described_class.new(username: username)
        expect(polyglot.username).to eq(username)
      end
    end

    context 'when username is not passed' do
      let(:client) { instance_double(Octokit::Client) }

      before do
        allow(Octokit::Client).to receive(:new).and_return(client)
      end

      it 'gets the username from the client' do
        allow(client).to receive(:user).and_return(double(login: 'bar'))
        polyglot = described_class.new(token: 'abcdefg')
        expect(polyglot.username).to eq('bar')
      end
    end
  end
end
