require 'require_relative' if RUBY_VERSION[0,3] == '1.8'
require_relative 'test_helper'

class A_RoutingTest < MiniTest::Unit::TestCase
  include TestHelper

  def test_it_says_ok_on_root
    get '/'
    assert last_response.body.include?('farhang')
  end

  def test_fail_address
    get '/sdsds'
    assert_equal 404, last_response.status
  end

  def test_css
    get '/css/home.css'
    assert last_response.body.include?('helvetica')
  end

  def test_get_search_ok
    get '/search/Apfel'
    assert last_response.body.include?('<b>Apfel</b>')
    assert last_response.body.include?('<b>Augapfel</b>')
    
    get '/search/apfel'
    assert last_response.body.include?('<b>Apfel</b>')
    assert last_response.body.include?('<b>Augapfel</b>')
  end

  def test_post_search_ok
    post '/search?term=Apfel'
    follow_redirect!
    assert last_response.body.include?('<b>Apfel</b>')
    assert last_response.body.include?('<b>Augapfel</b>')
    
    post '/search?term=apfel'
    follow_redirect!
    assert last_response.body.include?('<b>Apfel</b>')
    assert last_response.body.include?('<b>Augapfel</b>')
  end

  def test_show_lemma_id
    l = Factory(:lemma)
    get "/lemmas/#{l.id}"
    assert last_response.body.include?('das_schweigende_lemma')
    l.destroy
  end
end
  