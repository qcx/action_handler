RSpec.describe ActionHandler::Parametrizer do
  describe :from_event do
    def event
      ActionHandler::Event.new(event_hash)
    end

    def params
      ActionHandler::Parametrizer.from_event(event)
    end

    context :with_query_string_parameters do
      let(:event_hash) {{ 'queryStringParameters': { position: 'Midfielder' } }}
      it "should parametrize" do
        expect(params[:position]).to eq('Midfielder')
      end
    end

    context :with_path_parameters do
      let(:event_hash) {{ 'pathParameters': { shirt: 8 } }}
      it "should parametrize" do
        expect(params[:shirt]).to eq(8)
      end
    end

    context :with_message do
        let(:event_hash) {{ 'message': { name: 'Seda' }.to_json }}
      it "should parametrize" do
        expect(params[:name]).to eq('Seda')
      end
    end

    context :with_body do
      let(:event_hash) {{ 'body': { team: 'Barcelona' }.to_json }}
      it "should parametrize" do
        expect(params[:team]).to eq('Barcelona')
      end
    end

    context :with_records do
      let(:event_hash) do
        { 'Records': [{ 'body': { stadium: 'Camp Nou'}.to_json }] }
      end
      it "should parametrize" do
        expect(params[:stadium]).to eq('Camp Nou')
      end
    end
  end
end
