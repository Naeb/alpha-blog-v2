require "test_helper"

class SignUserUpTest < ActionDispatch::IntegrationTest
  
  setup do
    @admin_user = User.create(username: "John Doe", email: "john_doe@test.com", password:"password", admin: true)
    @common_user = User.create(username: "Jannet Doe", email: "jannet_doe@test.com", password:"password", admin: false)
  end
  
  test "Simple login as common user" do
    get '/login'
    assert_response :success
    post '/login', params: { session: {email: @common_user.email, password: "password"}}
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_match @common_user.username, response.body
    assert_select 'h1.text-center', @common_user.username
  end
  
  test "Simple login as admin user" do
    get '/login'
    assert_response :success
    post '/login', params: { session: {email: @admin_user.email, password: "password"}}
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_match @admin_user.username, response.body
    get '/categories/new'
    assert_response :success
  end

  test "Try loggin with email on capital-case" do
    get '/login'
    assert_response :success
    post '/login', params: { session: {email: 'JANNET_doe@test.com', password: "password"}}
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_match @common_user.username, response.body
    assert_select 'h1.text-center', @common_user.username
  end

end
