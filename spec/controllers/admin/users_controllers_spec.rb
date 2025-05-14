require 'rails_helper'

RSpec.describe "Admin::UsersController", type: :request do
  let(:admin) { create(:user_admin, is_admin: true) }
  let(:user) { create(:user) }

  before do
    sign_in admin
  end

  describe "GET index" do
    it "returns a successful response" do
      get admin_users_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user.first_name)
    end
  end

  describe "GET show" do
    it "view the user credentials" do
      get admin_user_path(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user.email)
    end
  end

  describe "GET new" do
    it "renders the create user form" do
      get new_admin_user_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST create" do
    context "with valid entries" do
      let(:user_params) {
        {
          user: {
            first_name: "Alice",
            last_name: "Smith",
            email: "alice@example.com",
            balance: 1000.0
          }
        }
      }

      it "creates a new user and redirects" do
        expect {
          post admin_users_path, params: user_params
        }.to change(User, :count).by(1)

        new_user = User.last
        expect(new_user.approved).to be true
        expect(new_user.confirmed?).to be true
        expect(response).to redirect_to(admin_user_path(new_user))
      end
    end

    context "with invalid entries" do
      it "renders :new with errors" do
        post admin_users_path, params: { user: { email: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Failed to create trader")
      end
    end
  end

  describe "GET edit" do
    it "renders the edit form" do
      get edit_admin_user_path(user)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH update" do
    it "updates user credentials" do
      patch admin_user_path(user), params: { user: { first_name: "Updated" } }
      expect(response).to redirect_to(admin_user_path(user))
      expect(user.reload.first_name).to eq("Updated")
    end
  end

  describe "GET edit_password" do
    it "renders the edit password form" do
      get edit_password_admin_user_path(user)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH update_password" do
    it "change user password" do
      patch update_password_admin_user_path(user), params: {
        user: {
          password: "newsecure123",
          password_confirmation: "newsecure123"
        }
      }
      expect(response).to redirect_to(admin_user_path(user))
    end

    it "cannot change with mismatched password confirmation" do
      patch update_password_admin_user_path(user), params: {
        user: {
          password: "newsecure123",
          password_confirmation: "wrong"
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Failed to change password")
    end
  end

  describe "GET pending" do
    it "shows list of pending users" do
      unapproved = create(:user, approved: false)
      get pending_admin_users_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(unapproved.email)
    end
  end

  describe "PATCH approve" do
    it "approves the user and sends confirmation email" do
      unapproved = create(:user, approved: false, confirmed_at: nil)
      expect {
        patch approve_admin_user_path(unapproved)
      }.to change { unapproved.reload.approved }.from(false).to(true)

      expect(response).to redirect_to(admin_users_path)
    end
  end

  describe "GET show - rescue" do
    it "redirects to admin root with alert" do
      get admin_user_path(id: "9999")
      expect(response).to redirect_to(admin_root_path)
      follow_redirect!
      expect(response.body).to include("Record does not exist.")
    end
  end
end
