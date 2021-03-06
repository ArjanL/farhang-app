# encoding: UTF-8
require "#{File.dirname(__FILE__)}/spec_helper"
include SpecHelper

describe "sidebar" do
  describe "anonymous" do
    it "returns the homepage for unsigned user" do
      get '/'
      last_response.body.must_include 'Anmelden'
      last_response.body.wont_include 'Abmelden'
    end
  end

  describe "common user" do
    before do
      u = FactoryGirl.create :user
      post '/user/login', :email => u.email, :password => 'secret'
    end

    it "returns the homepage for common user" do
      get '/'
      last_response.body.must_include 'Abmelden'
      last_response.body.wont_include 'Bestätigen'
    end
  end

  describe "admin user" do
    before do
      u = FactoryGirl.create :user, :roles => [:user, :admin]
      post '/user/login', :email => u.email, :password => 'secret'
    end

    it "returns the homepage for admin user" do
      get '/'
      last_response.body.must_include 'Bestätigen'
      #last_response.body.wont_include 'Übersicht'
    end

    it "shows label-succes if no unvalidated lemma exists" do
      get '/'
      last_response.body.must_include "label-success"
    end

    it "shows label-warning if unvalidated lemmas exist" do
      FactoryGirl.create :lemma, :valid => false
      get '/'
      last_response.body.must_include "label-warning"
    end

    it "shows the number of unvalidated lemmas" do
      FactoryGirl.create_list :multi_lemma, 7, :valid => false
      get '/'
      last_response.body.must_include "7"
    end
  end

  describe "root user" do
    before do
      u = FactoryGirl.create :user, :roles => [:user, :root]
      post '/user/login', :email => u.email, :password => 'secret'
    end

    it "returns the homepage for root user" do
      get '/'
      last_response.body.must_include 'Bestätigen'
      last_response.body.must_include 'Übersicht'
    end
  end

  after do
    User.delete_all
    Lemma.delete_all
  end
end

