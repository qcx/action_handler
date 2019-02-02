RSpec.describe ActionHandler::Base do
  describe :call do
    def klass
      Class.new(ActionHandler::Base) do
        def index
          5 + 5
        end

        def show
          render json: { key: :value }
        end
      end
    end
    context :action do
      context :with_render do
        let(:response) { klass.show(event: {}, context: {}) }
        it "should render response" do
          expect(response).to eq(statusCode: 200, body: "{\"key\":\"value\"}", headers: { "Content-Type" => "application/json" })
        end
      end
      context :without_render do
        let(:response) { klass.index(event: {}, context: {}) }
        it "should render response" do
          expect(response).to eq(statusCode: 204)
        end
      end
    end
  end
end
