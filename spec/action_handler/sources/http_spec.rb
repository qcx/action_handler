RSpec.describe ActionHandler::Sources::HTTP do
  describe :parametrize do

    let(:source)  { ActionHandler::Sources::HTTP.new }
    let(:params)  { source.parametrize(base.merge(event)) }

    context :v1 do
      let(:base)    { { 'httpMethod' => 'POST' } }

      context :queryStringParameters do
        let(:event) { { 'queryStringParameters' => { 'level' => 32 } } }

        it 'should return an ActionHandler::Params object' do
          expect(params.class).to eq(ActionHandler::Params)
        end

        it 'should have the correct params' do
          expect(params[:level]).to eq(32)
        end
      end

      context :pathParameters do
        let(:event) { { 'pathParameters' => { 'level' => 32 } } }

        it 'should return an ActionHandler::Params object' do
          expect(params.class).to eq(ActionHandler::Params)
        end

        it 'should have the correct params' do
          expect(params[:level]).to eq(32)
        end
      end

      context :body do
        let(:headers) { { 'Content-Type' => 'application/json' } }
        let(:event)   { { 'headers' => headers, 'body' => body } }

        context :json do
          let(:body) { JSON.generate({ level: 32 }) }

          it 'should return an ActionHandler::Params object' do
            expect(params.class).to eq(ActionHandler::Params)
          end

          it 'should have the correct params' do
            expect(params[:level]).to eq(32)
          end
        end

        context :base64 do
          let(:body)  { Base64.encode64(JSON.generate({ level: 32 })) }
          let(:event) { { 'headers' => headers, 'body' => body, 'isBase64Encoded' => true } }

          it 'should return an ActionHandler::Params object' do
            expect(params.class).to eq(ActionHandler::Params)
          end

          it 'should have the correct params' do
            expect(params[:level]).to eq(32)
          end
        end

        context 'nil body' do
          let(:body)  { nil }
          let(:event) { { 'headers' => headers, 'body' => body } }

          it 'should return an ActionHandler::Params object' do
            expect(params.class).to eq(ActionHandler::Params)
          end

          it 'should have empty params' do
            expect(params.to_h).to be_empty
          end
        end

        context 'empty body' do
          let(:body)  { '' }
          let(:event) { { 'headers' => headers, 'body' => body } }

          it 'should return an ActionHandler::Params object' do
            expect(params.class).to eq(ActionHandler::Params)
          end

          it 'should have empty params' do
            expect(params.to_h).to be_empty
          end
        end
      end
    end

    context :v2 do
      let(:base) { { 'method' => 'PUT' } }

      context :query do
        let(:event) { { 'query' => { 'level' => 32 } } }

        it 'should return an ActionHandler::Params object' do
          expect(params.class).to eq(ActionHandler::Params)
        end

        it 'should have the correct params' do
          expect(params[:level]).to eq(32)
        end
      end

      context :body do
        let(:headers) { { 'Content-Type' => 'application/json' } }
        let(:event)   { { 'headers' => headers, 'body' => body } }
        let(:body)    { { level: 32 } }

        it 'should return an ActionHandler::Params object' do
          expect(params.class).to eq(ActionHandler::Params)
        end

        it 'should have the correct params' do
          expect(params[:level]).to eq(32)
        end
      end
    end

    context :none do
      let(:base)  { {} }
      let(:event) { { 'headers' => { 'level' => 32 } } }

      it 'should return an ActionHandler::Params object' do
        expect(params.class).to eq(ActionHandler::Params)
      end

      it 'should not have any params' do
        expect(params[:level]).to eq(nil)
      end
    end
  end
end
