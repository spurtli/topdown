require 'spec_helper'

RSpec.describe Topdown do
  it 'has a version number' do
    expect(Topdown::VERSION).not_to be nil
  end

  describe 'Service' do
    it 'noop' do
      result = Topdown::Service.call {}

      expect(result).to be_success
    end

    it 'call' do
      result = Topdown::Service
        .expect(:a)
        .call(a: 1) {}

      expect(result).to be_success
      expect(result).to have_attributes(a: 1)
    end

    it 'call with contract violation' do
      result = Topdown::Service
        .expect(:a)
        .call(b: 1) {}

      expect(result).to be_failure
      expect(result.error).to be_a(ArgumentError)
    end

    it 'call with raise' do
      result = Topdown::Service
        .create
        .call {raise 'stop'}

      expect(result).to be_failure
      expect(result.error.message).to eql('stop')
    end

    it 'call with nil value' do
      result = Topdown::Service
        .expect(:a)
        .call(a: nil) {}

      expect(result).to be_failure
      expect(result.error).to be_a(Topdown::ContextError)
    end

    it 'call without contract' do
      result = Topdown::Service
        .call(a: 1) {}

      expect(result).to be_success
      expect(result.a).to eql(1)
    end

    it 'create and call' do
      result = Topdown::Service
        .create {context.a += 1}
        .expect(:a)
        .call(a: 1)

      expect(result).to be_success
      expect(result.a).to eql(2)
    end

    it 'create and call with contract violation' do
      result = Topdown::Service
        .create {context.a += 1}
        .expect(:a)
        .call(b: 1)

      expect(result).to be_failure
      expect(result.error).to be_a(ArgumentError)
    end

    it 'create and call with raise' do
      result = Topdown::Service
        .create {raise 'stop'}
        .call

      expect(result).to be_failure
      expect(result.error.message).to eql('stop')
    end

    it 'create and call with nil value' do
      result = Topdown::Service
        .create {context.a += 1}
        .expect(:a)
        .call(a: nil)

      expect(result).to be_failure
      expect(result.error).to be_a(Topdown::ContextError)
    end

    it 'create and call without contract' do
      result = Topdown::Service
        .create {context.a += 1}
        .call(a: 1)

      expect(result).to be_success
      expect(result.a).to eql(2)
    end
  end

  describe 'Pipeline' do
    it 'call empty' do
      result = Topdown::Pipeline
        .create
        .call

      expect(result).to be_success
    end

    it 'add step and call' do
      service1 = Topdown::Service.create {context.a += 1}

      result = Topdown::Pipeline
        .expect(:a)
        .step(service1)
        .call(a: 1)

      expect(result).to be_success
      expect(result).to have_attributes(a: 2)
    end

    it 'add two steps and call' do
      service1 = Topdown::Service.create {context.a += 1}
      service2 = Topdown::Service.create {context.a += 1}

      result = Topdown::Pipeline
        .expect(:a)
        .step(service1)
        .step(service2)
        .call(a: 1)

      expect(result).to be_success
      expect(result).to have_attributes(a: 3)
    end

    it 'add two steps at once and call' do
      service1 = Topdown::Service.create {context.a += 1}
      service2 = Topdown::Service.create {context.a += 1}

      result = Topdown::Pipeline
        .expect(:a)
        .steps(service1, service2)
        .call(a: 1)

      expect(result).to be_success
      expect(result).to have_attributes(a: 3)
    end

    it 'add step and call without contract' do
      service = Topdown::Service.create {context.a += 1}

      result = Topdown::Pipeline
        .create
        .step(service)
        .call(a: 1)

      expect(result).to be_success
      expect(result).to have_attributes(a: 2)
    end

    it 'add two steps and call, stop at raise in step1' do
      service1 = Topdown::Service.create {raise 'stop'}
      service2 = Topdown::Service.create {context.a += 1}

      result = Topdown::Pipeline
        .create
        .step(service1)
        .step(service2)
        .call(a: 1)

      expect(result).to be_failure
      expect(result).to have_attributes(a: 1)
    end

    it 'add two steps and call, stop at raise in step2' do
      service1 = Topdown::Service.create {context.a += 1}
      service2 = Topdown::Service.create {raise 'stop'}

      result = Topdown::Pipeline
        .create
        .step(service1)
        .step(service2)
        .call(a: 1)

      expect(result).to be_failure
      expect(result).to have_attributes(a: 2)
    end
  end
end
