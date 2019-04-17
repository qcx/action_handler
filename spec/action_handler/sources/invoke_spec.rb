RSpec.describe ActionHandler::Sources::Invoke do
  describe :parametrize do

    let(:source)  { ActionHandler::Sources::Invoke.new }
    let(:params)  { source.parametrize(event) }

    context :root do
      let(:event) { { "level" => 32 } }

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

      it "should have empty params" do
        expect(params[:level]).to eq(nil)
      end
    end
  end
end
