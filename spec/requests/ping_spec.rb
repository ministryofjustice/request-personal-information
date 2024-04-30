require "rails_helper"

RSpec.describe "Ping", type: :request do
  it "renders deployment information as JSON" do
    allow(Deployment).to receive(:info).and_return(foo: "bar")
    get "/ping"
    expect(JSON.parse(response.body)).to eq("foo" => "bar")
  end
end
