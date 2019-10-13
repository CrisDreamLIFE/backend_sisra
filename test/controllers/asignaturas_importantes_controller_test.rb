require 'test_helper'

class AsignaturasImportantesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get asignaturas_importantes_index_url
    assert_response :success
  end

end
