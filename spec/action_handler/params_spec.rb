RSpec.describe ActionHandler::Params do
  describe :[] do

    def params
      ActionHandler::Params.new(params_hash)
    end

    context :string_value do
      let(:params_hash) {{ 'string_key' => 'string_value' }}
      it "should return value" do
        expect(params[:string_key]).to eq('string_value')
      end
    end

    context :json_value do
      let(:params_hash) {{ 'body' => { name: 'ruby' }.to_json }}
      it "should return value" do
        expect(params[:body][:name]).to eq('ruby')
      end
    end

    context :hash_value do
      let(:params_hash) {{ 'body' => { 'user' => { name: 'ruby' } } }}
      it "should return value" do
        expect(params[:body][:user][:name]).to eq('ruby')
      end
    end

    context :array_value do
      let(:params_hash) {{ 'body' => [{ 'user': 'coutinho' }] }}
      it "should return value" do
        expect(params[:body].first[:user]).to eq('coutinho')
      end
    end
  end
end
