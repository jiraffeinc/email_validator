module EmailValidatorSpec
  class User
    include ActiveModel::Validations
    attr_accessor :email
    validates :email, presence: true, email: true
  end
end

RSpec.describe MailgunEmailValidator do

  before(:all) do
    ActiveRecord::Schema.define(version: 1) do
      create_table :email_validator_spec_users, force: true do |t|
        t.column :email, :string
      end
    end
  end

  after(:all) do
    ActiveRecord::Base.connection.drop_table(:email_validator_spec_users)
  end

  context "with regular validator" do
    let(:user) { ::EmailValidatorSpec::User.new }

    context 'valid email format' do
      it 'with simple structure' do
        user.email = 'an_unique_valid_email@example.com'
        user.valid?
        expect(user).to be_valid
      end

      it 'with multiple dots' do
        user.email = 'an.unique.valid.email@any.subdomain.example.com'
        user.valid?
        expect(user).to be_valid
      end
    end

    context 'wrong structure' do
      it 'without @' do
        I18n.locale = :ja
        user.email = 'invalid.example.com'
        user.valid?
        expect(user.errors[:email].first).to eq("メールアドレスが不正です")
      end

      it 'with multiple @s' do
        I18n.locale = :ja
        user.email = 'invalid@email@example.com'
        user.valid?
        expect(user.errors[:email].first).to eq("メールアドレスが不正です")
      end
    end

    context 'wrong domain structure' do
      it 'domain without dot' do
        I18n.locale = :ja
        user.email = 'invalid_email@example'
        user.valid?
        expect(user.errors[:email].first).to eq("メールアドレスが不正です")
      end

      it 'with dot in the wrong place' do
        I18n.locale = :ja
        user.email = 'invalid_email@example.'
        user.valid?
        expect(user.errors[:email].first).to eq("メールアドレスが不正です")
      end

      it 'with dot in the wrong place' do
        I18n.locale = :ja
        user.email = 'invalid_email@.example'
        user.valid?
        expect(user.errors[:email].first).to eq("メールアドレスが不正です")
      end
    end

    context 'wrong local-part structure' do
      it 'domain with dot in the wrong place' do
        I18n.locale = :ja
        user.email = 'invalid_email.@example.com'
        user.valid?
        expect(user.errors[:email].first).to eq("メールアドレスが不正です")
      end

      it 'domain with dot in the wrong place' do
        I18n.locale = :ja
        user.email = '.invalid_email@example.com'
        user.valid?
        expect(user.errors[:email].first).to eq("メールアドレスが不正です")
      end
    end

    context 'wrong structure' do
      it 'without @' do
        I18n.locale = :en
        user.email = 'invalid.example.com'
        user.valid?
        expect(user.errors[:email].first).to eq("invalid email")
      end

      it 'with multiple @s' do
        I18n.locale = :en
        user.email = 'invalid@email@example.com'
        user.valid?
        expect(user.errors[:email].first).to eq("invalid email")
      end
    end

    context 'wrong domain structure' do
      it 'domain without dot' do
        I18n.locale = :en
        user.email = 'invalid_email@example'
        user.valid?
        expect(user.errors[:email].first).to eq("invalid email")
      end

      it 'with dot in the wrong place' do
        I18n.locale = :en
        user.email = 'invalid_email@example.'
        user.valid?
        expect(user.errors[:email].first).to eq("invalid email")
      end

      it 'with dot in the wrong place' do
        I18n.locale = :en
        user.email = 'invalid_email@.example'
        user.valid?
        expect(user.errors[:email].first).to eq("invalid email")
      end
    end

    context 'wrong local-part structure' do
      it 'domain with dot in the wrong place' do
        I18n.locale = :en
        user.email = 'invalid_email.@example.com'
        user.valid?
        expect(user.errors[:email].first).to eq("invalid email")
      end

      it 'domain with dot in the wrong place' do
        I18n.locale = :en
        user.email = '.invalid_email@example.com'
        user.valid?
        expect(user.errors[:email].first).to eq("invalid email")
      end
    end
  end
end
