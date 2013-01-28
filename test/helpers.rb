module Helpers
  BASE_PATH = File.expand_path("../fixtures", __FILE__)

  def fetch_fixture_path(path)
    File.join(BASE_PATH, path)
  end
end