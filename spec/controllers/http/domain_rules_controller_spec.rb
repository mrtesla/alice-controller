require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Http::DomainRulesController do

  let(:application) { Core::Application.create(name: 'client_example') }

  # This should return the minimal set of attributes required to create a valid
  # Http::DomainRule. As you add validations to Http::DomainRule, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { core_application_id: application.id, domain: '*.example.com.', actions: '[["forward", "client_example"]]' }
  end

  describe "GET index" do
    it "assigns all http_domain_rules as @http_domain_rules" do
      domain_rule = Http::DomainRule.create! valid_attributes
      get :index
      assigns(:http_domain_rules).should eq([domain_rule])
    end
  end

  describe "GET show" do
    it "assigns the requested domain_rule as @domain_rule" do
      domain_rule = Http::DomainRule.create! valid_attributes
      get :show, :id => domain_rule.id
      assigns(:http_domain_rule).should eq(domain_rule)
    end
  end

  describe "GET new" do
    it "assigns a new domain_rule as @domain_rule" do
      get :new
      assigns(:http_domain_rule).should be_a_new(Http::DomainRule)
    end
  end

  describe "GET edit" do
    it "assigns the requested domain_rule as @domain_rule" do
      domain_rule = Http::DomainRule.create! valid_attributes
      get :edit, :id => domain_rule.id
      assigns(:http_domain_rule).should eq(domain_rule)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Http::DomainRule" do
        expect {
          post :create, :http_domain_rule => valid_attributes
        }.to change(Http::DomainRule, :count).by(1)
      end

      it "assigns a newly created domain_rule as @domain_rule" do
        post :create, :http_domain_rule => valid_attributes
        assigns(:http_domain_rule).should be_a(Http::DomainRule)
        assigns(:http_domain_rule).should be_persisted
      end

      it "redirects to the created domain_rule" do
        post :create, :http_domain_rule => valid_attributes
        response.should redirect_to(Http::DomainRule.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved domain_rule as @domain_rule" do
        # Trigger the behavior that occurs when invalid params are submitted
        Http::DomainRule.any_instance.stub(:save).and_return(false)
        post :create, :http_domain_rule => {}
        assigns(:http_domain_rule).should be_a_new(Http::DomainRule)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Http::DomainRule.any_instance.stub(:save).and_return(false)
        post :create, :http_domain_rule => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested domain_rule" do
        domain_rule = Http::DomainRule.create! valid_attributes
        # Assuming there are no other http_domain_rules in the database, this
        # specifies that the Http::DomainRule created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Http::DomainRule.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => domain_rule.id, :http_domain_rule => {'these' => 'params'}
      end

      it "assigns the requested domain_rule as @domain_rule" do
        domain_rule = Http::DomainRule.create! valid_attributes
        put :update, :id => domain_rule.id, :http_domain_rule => valid_attributes
        assigns(:http_domain_rule).should eq(domain_rule)
      end

      it "redirects to the domain_rule" do
        domain_rule = Http::DomainRule.create! valid_attributes
        put :update, :id => domain_rule.id, :http_domain_rule => valid_attributes
        response.should redirect_to(domain_rule)
      end
    end

    describe "with invalid params" do
      it "assigns the domain_rule as @domain_rule" do
        domain_rule = Http::DomainRule.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Http::DomainRule.any_instance.stub(:save).and_return(false)
        put :update, :id => domain_rule.id, :http_domain_rule => {}
        assigns(:http_domain_rule).should eq(domain_rule)
      end

      it "re-renders the 'edit' template" do
        domain_rule = Http::DomainRule.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Http::DomainRule.any_instance.stub(:save).and_return(false)
        put :update, :id => domain_rule.id, :http_domain_rule => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested domain_rule" do
      domain_rule = Http::DomainRule.create! valid_attributes
      expect {
        delete :destroy, :id => domain_rule.id
      }.to change(Http::DomainRule, :count).by(-1)
    end

    it "redirects to the http_domain_rules list" do
      domain_rule = Http::DomainRule.create! valid_attributes
      delete :destroy, :id => domain_rule.id
      response.should redirect_to(http_domain_rules_url)
    end
  end

end
