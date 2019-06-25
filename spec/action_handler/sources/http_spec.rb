RSpec.describe ActionHandler::Sources::HTTP do
  describe :parametrize do

    let(:source)  { ActionHandler::Sources::HTTP.new }
    let(:params)  { source.parametrize(event) }

    context :queryStringParameters do
      let(:event) { { "queryStringParameters" => { level: 32 } } }

      it "should return an ActionHandler::Params object" do
        expect(params.class).to eq(ActionHandler::Params)
      end

      it "should have the correct params" do
        expect(params[:level]).to eq(32)
      end
    end

    context :pathParameters do
      let(:event) { { "pathParameters" => { level: 32 } } }

      it "should return an ActionHandler::Params object" do
        expect(params.class).to eq(ActionHandler::Params)
      end

      it "should have the correct params" do
        expect(params[:level]).to eq(32)
      end
    end

    context :body do
      let(:event) { { "body" => JSON.generate({ level: 32 }) } }

      it "should return an ActionHandler::Params object" do
        expect(params.class).to eq(ActionHandler::Params)
      end

      it "should have the correct params" do
        expect(params[:level]).to eq(32)
      end
    end

    context :none do
      let(:event) { { "headers" => { level: 32 } } }

      it "should return an ActionHandler::Params object" do
        expect(params.class).to eq(ActionHandler::Params)
      end

      it "should not have any params" do
        expect(params[:level]).to eq(nil)
      end
    end
  end
end
