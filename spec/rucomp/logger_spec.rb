require 'spec_helper'
require 'rucomp/server/logger'
require 'lumberjack'

class Rucomp::Server
  RSpec.describe Logger do
    let(:dummy_lumberjack) { instance_double('Lumberjack::Logger') }
    before do
      allow(Lumberjack::Logger).to receive(:new).and_return(dummy_lumberjack)
    end

    after do
      described_class.reset_logger
      described_class.options = {
        level: :info,
        device: $stderr,
        template: ':time - :severity - :message',
        time_format: '%H:%M:%S'
      }
    end

    describe '.logger' do
      it 'returns the logger' do
        expect(described_class.logger).to be dummy_lumberjack
      end
    end

    describe '.options' do
      let(:options) { described_class.options }
      it 'returns an instance of Rucomp::Logger::Options' do
        expect(described_class.options).to be_a Logger::Options
      end

      it 'has an `info` key' do
        expect(options[:level]).to eq :info
      end

      it 'has a `template` key' do
        expect(options[:template]).to eq ':time - :severity - :message'
      end

      it 'has a `time_format` key' do
        expect(options[:time_format]).to eq '%H:%M:%S'
      end
    end

    describe '.options=' do
      let(:new_opts) { { level: :debug } }
      it 'takes a hash and returns a new instance of Logger::Options' do
        expect { described_class.options = new_opts }.not_to raise_error
        expect(described_class.options).to be_a Logger::Options
        expect(described_class.options[:level]).to be :debug
      end
    end

    describe 'delegated methods' do
      before do
        allow(dummy_lumberjack).to receive(:debug)
        allow(dummy_lumberjack).to receive(:debug?)
        allow(dummy_lumberjack).to receive(:error)
        allow(dummy_lumberjack).to receive(:error?)
        allow(dummy_lumberjack).to receive(:fatal)
        allow(dummy_lumberjack).to receive(:fatal?)
        allow(dummy_lumberjack).to receive(:flush)
        allow(dummy_lumberjack).to receive(:formatter)
        allow(dummy_lumberjack).to receive(:info)
        allow(dummy_lumberjack).to receive(:info?)
        allow(dummy_lumberjack).to receive(:level)
        allow(dummy_lumberjack).to receive(:level=)
        allow(dummy_lumberjack).to receive(:warn)
        allow(dummy_lumberjack).to receive(:warn?)
        allow(dummy_lumberjack).to receive(:unknown)
        allow(dummy_lumberjack).to receive(:silence)
      end

      %i(debug error fatal info warn unknown).each do |meth|
        it "delegates #{meth}" do
          expect(dummy_lumberjack).to receive(meth)
          described_class.send(meth, 'hello')
        end
      end

      %i(debug? error? fatal? info? warn? flush formatter silence).each do |m|
        it "delegates #{m}" do
          expect(dummy_lumberjack).to receive m
          described_class.send(m)
        end
      end
    end
  end
end
