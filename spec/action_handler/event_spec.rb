RSpec.describe ActionHandler::Event do
  describe :[] do
    def event
      ActionHandler::Event.new(event_hash)
    end

    context :string_value do
      let(:event_hash) {{ 'string_key' => 'string_value' }}
      it "should return value" do
        expect(event[:string_key]).to eq('string_value')
      end
    end

    context :json_value do
      let(:event_hash) {{ 'body' => { name: 'ruby' }.to_json }}
      it "should return value" do
        expect(event[:body][:name]).to eq('ruby')
      end
    end

    context :hash_value do
      let(:event_hash) {{ 'body' => { 'user' => { name: 'ruby' } } }}
      it "should return value" do
        expect(event[:body][:user][:name]).to eq('ruby')
      end
    end

    context :array_value do
      let(:event_hash) {{ 'body' => [{ 'user': 'coutinho' }] }}
      it "should return value" do
        expect(event[:body].first[:user]).to eq('coutinho')
      end
    end
  end
end
