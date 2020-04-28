RSpec.describe ActionHandler::Sources::HTTP do
  describe :parametrize do

    let(:source)  { ActionHandler::Sources::HTTP.new }
    let(:params)  { source.parametrize(base.merge(event)) }
    let(:base)    { { 'httpMethod' => 'POST', 'version' => version } }
    let(:qs)      { { 'level' => 32 } }
    let(:event)   do
      {
        'queryStringParameters' => qs,
        'rawQueryString' => Rack::Utils.build_query(qs),
        'pathParameters' => { 'id' => 12 },
        'headers' => { 'Content-Type' => 'application/json' },
        'body' => JSON.generate({ count: 5 })
      }
    end

    context :v1 do
      let(:version) { '1.0' }

      it 'should return an ActionHandler::Params object' do
        expect(params.class).to eq(ActionHandler::Params)
      end

      it 'should have the correct params' do
        expect(params[:level]).to eq(32)
        expect(params[:id]).to eq(12)
        expect(params[:count]).to eq(5)
      end
    end

    context :other do
      let(:version) { '0.0' }

      it 'should return an ActionHandler::Params object' do
        expect(params.class).to eq(ActionHandler::Params)
      end

      it 'should have the correct params' do
        expect(params[:level]).to eq(nil)
        expect(params[:id]).to eq(nil)
        expect(params[:count]).to eq(nil)
      end
    end
  end
end
