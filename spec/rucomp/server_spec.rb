require 'spec_helper'
require 'rucomp/server'

module Rucomp
  RSpec.describe Server do
    let(:server) { described_class.new(opts) }
    context 'with no options' do
      let(:opts) { {} }
      it 'has default values for port, address, and log file' do
        expect(server.port).to eq 35_687
        expect(server.addr).to eq '127.0.0.1'
        expect(server.log_file).to eq '~/.rucomp/server.log'
      end

      it 'defaults to nil for log_to_stdout' do
        expect(server.log_to_stdout).to be_nil
      end
    end

    context 'with an address and port specified' do
      let(:opts) { { port: 32_567, addr: 'localhost' } }
      it 'uses the passed in values' do
        expect(server.port).to eq 32_567
        expect(server.addr).to eq 'localhost'
      end
    end

    context 'with log_to_stdout as `true`' do
      let(:opts) { { log_to_stdout: true } }
      it 'uses $stdout as the log file' do
        expect(server.log_file).to eq $stdout
        expect(server.log_to_stdout).to be_truthy
      end
    end

    context 'with a specific log file' do
      let(:opts) { { log_file: '~/my.log' } }
      it 'uses the log file specified' do
        expect(server.log_file).to eq '~/my.log'
      end
    end
  end
end
