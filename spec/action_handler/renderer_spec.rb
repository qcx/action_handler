RSpec.describe ActionHandler::Renderer do
  describe :render do
    context :json do
      let(:json) {{ content: { players_count: 12 } }}
      let(:renderer) { ActionHandler::Renderer.new(json: json) }
      it "should render" do
        expect(renderer.render).to eq(statusCode: 200, body: json.to_json, headers: { 'Content-Type' => 'application/json' })
      end
    end

    context :html do
      let(:html) { "<html><body>HTML</body></html>" }
      let(:renderer) { ActionHandler::Renderer.new(html: html) }
      it "should render" do
        expect(renderer.render).to eq(statusCode: 200, body: html, headers: { 'Content-Type' => 'text/html' })
      end
    end

    context :no_content do
      let(:renderer) { ActionHandler::Renderer.new() }
      it "should render" do
        expect(renderer.render).to eq(statusCode: 204)
      end
    end

    context :different_status do
      let(:renderer) { ActionHandler::Renderer.new(status: 202) }
      it "should render" do
        expect(renderer.render).to eq(statusCode: 202)
      end
    end
  end
end
