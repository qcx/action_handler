RSpec.describe ActionHandler::Sources::SNS do
  describe :parametrize do

    let(:source)  { ActionHandler::Sources::SNS.new }
    let(:params)  { source.parametrize(event) }

    context :single do
      let(:event)   { { 'Records' =>[{ 'Sns' =>{ 'Message' => message } }] } }
      let(:message) { JSON.generate({ status: 'CREATED' }) }

      it 'should return an ActionHandler::Params object' do
        expect(params.class).to eq(ActionHandler::Params)
      end

      it 'should have the correct params' do
        expect(params[:status]).to eq('CREATED')
      end
    end

    context :without_records do
      let(:event) { { 'Records' => [{}] } }

      it 'should return an ActionHandler::Params object' do
        expect(params.class).to eq(ActionHandler::Params)
      end

      it 'should have the correct params' do
        expect(params[:status]).to eq(nil)
      end
    end
  end
end
