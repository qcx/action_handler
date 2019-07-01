RSpec.describe ActionHandler::Sources::SQS do
  describe :parametrize do

    let(:source)  { ActionHandler::Sources::SQS.new }
    let(:params)  { source.parametrize(event) }

    context :single do
      let(:event)   { { "Records" => [record] } }
      let(:record)  { { "body" => JSON.generate({ level: 32 }) } }

      it "should return an ActionHandler::Params object" do
        expect(params.class).to eq(ActionHandler::Params)
      end

      it "should have the correct params" do
        expect(params[:level]).to eq(32)
      end
    end

    context :multiple do
      let(:event)   { { "Records" => [one, two] } }
      let(:one)  { { "body" => JSON.generate({ level: 32 }) } }
      let(:two)  { { "body" => JSON.generate({ health: 27 }) } }

      it "should return an ActionHandler::Params object" do
        expect(params.class).to eq(ActionHandler::Params)
      end

      it "should have the correct params" do
        expect(params[:level]).to eq(32)
        expect(params[:health]).to eq(27)
      end
    end

    context :without_records do
      let(:event) { { "Records" => [] } }

      it "should return an ActionHandler::Params object" do
        expect(params.class).to eq(ActionHandler::Params)
      end

      it "should have the correct params" do
        expect(params[:level]).to eq(nil)
      end
    end
  end
end
