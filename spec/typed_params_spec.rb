require 'spec_helper'

RSpec.describe TypedParams do
  class Test
    include TypedParams
  end

  let(:valid_hash) do
    { name: 'bob', age: 20, job: { title: 'senior engineer', grade: 5 } }
  end
  let(:invalid_hash) do
    { name: 'bob', age: 20, job: { title: 'senior engineer', grade: 'abc' } }
  end
  let(:type) { :'UsersController::CreateRequest' }

  subject { Test.new.typed_params(parameters, type) }

  describe 'ActionController::Parameters' do
    context 'valid typed params' do
      let(:parameters) { ActionController::Parameters.new(valid_hash) }

      it do
        expect(subject).to eql(parameters.to_unsafe_h)
      end
    end
    
    context 'invalid typed params' do
      let(:parameters) { ActionController::Parameters.new(invalid_hash) }

      it do
        expect { subject }.to raise_error(TypedParams::InvalidTypeError)
      end
    end
  end

  describe 'Hash' do
    context 'valid typed params' do
      let(:parameters) { valid_hash }

      it do
        expect(subject).to eql(parameters)
      end
    end
    
    context 'invalid typed params' do
      let(:parameters) { invalid_hash }

      it do
        expect { subject }.to raise_error(TypedParams::InvalidTypeError)
      end
    end
  end
end
