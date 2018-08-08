# frozen_string_literal: true

require_relative "./test_helper"

class BootstrapCollectionRadioButtonTest < ActionView::TestCase
  include BootstrapForm::Helper

  setup :setup_test_fixture

  test "collection_radio_buttons renders the form_group correctly with block" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">This is a radio button collection</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foobar
          </label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    actual = @builder.collection_radio_buttons(:misc, collection, :id, :street, label: "This is a radio button collection", help: "With a help!") do |builder|
      builder.radio_button(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_radio_buttons renders multiple radios correctly with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> Foo</label>
        </div>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
          <label class="form-check-label" for="user_misc_2"> Bar</label>
        </div>
      </div>
    HTML

    actual = @builder.collection_radio_buttons(:misc, collection, :id, :street) do |builder|
      builder.radio_button(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_radio_buttons renders multiple radios with error correctly with block" do
    @user.errors.add(:misc, "error for test")
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-group">
          <label for="user_misc">Misc</label>
          <div class="form-check custom-class">
            <input class="form-check-input is-invalid" id="user_misc_1" name="user[misc]" type="radio" value="1" />
            <label class="form-check-label" for="user_misc_1"> Foo</label>
          </div>
          <div class="form-check custom-class">
            <input class="form-check-input is-invalid" id="user_misc_2" name="user[misc]" type="radio" value="2" />
            <label class="form-check-label" for="user_misc_2"> Bar</label>
            <div class="invalid-feedback">error for test</div>
          </div>
        </div>
      </form>
    HTML

    actual = bootstrap_form_for(@user) do |f|
      f.collection_radio_buttons(:misc, collection, :id, :street) do |builder|
        builder.radio_button(wrapper_class: "custom-class")
      end
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_radio_buttons renders inline radios correctly with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check form-check-inline custom-class">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> Foo</label>
        </div>
        <div class="form-check form-check-inline custom-class">
          <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
          <label class="form-check-label" for="user_misc_2"> Bar</label>
        </div>
      </div>
    HTML

    actual = @builder.collection_radio_buttons(:misc, collection, :id, :street, inline: true) do |builder|
      builder.radio_button(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_radio_buttons renders with checked option correctly with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input class="form-check-input" checked="checked" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> Foo</label>
        </div>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
          <label class="form-check-label" for="user_misc_2"> Bar</label>
        </div>
      </div>
    HTML

    actual = @builder.collection_radio_buttons(:misc, collection, :id, :street, checked: 1) do |builder|
      builder.radio_button(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_radio_buttons renders label defined by Proc correctly with block" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">This is a radio button collection</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> rabooF</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    actual = @builder.collection_radio_buttons(:misc, collection, :id, proc { |a| a.street.reverse }, label: "This is a radio button collection", help: "With a help!") do |builder|
      builder.radio_button(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_radio_buttons renders value defined by Proc correctly with block" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">This is a radio button collection</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1"> Foobar</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    actual = @builder.collection_radio_buttons(:misc, collection, proc { |a| "address_#{a.id}" }, :street, label: "This is a radio button collection", help: "With a help!") do |builder|
      builder.radio_button(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_radio_buttons renders multiple radios with label defined by Proc correctly with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> ooF</label>
        </div>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
          <label class="form-check-label" for="user_misc_2"> raB</label>
        </div>
      </div>
    HTML

    actual = @builder.collection_radio_buttons(:misc, collection, :id, proc { |a| a.street.reverse }) do |builder|
      builder.radio_button(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_radio_buttons renders multiple radios with value defined by Proc correctly with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1"> Foo</label>
        </div>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc]" type="radio" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2"> Bar</label>
        </div>
      </div>
    HTML

    actual = @builder.collection_radio_buttons(:misc, collection, proc { |a| "address_#{a.id}" }, :street) do |builder|
      builder.radio_button(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_radio_buttons renders label defined by lambda correctly with block" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">This is a radio button collection</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> rabooF</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    actual = @builder.collection_radio_buttons(:misc, collection, :id, ->(a) { a.street.reverse }, label: "This is a radio button collection", help: "With a help!") do |builder|
      builder.radio_button(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_radio_buttons renders value defined by lambda correctly with block" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">This is a radio button collection</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1"> Foobar</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    actual = @builder.collection_radio_buttons(:misc, collection, ->(a) { "address_#{a.id}" }, :street, label: "This is a radio button collection", help: "With a help!") do |builder|
      builder.radio_button(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_radio_buttons renders multiple radios with label defined by lambda correctly with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
          <label class="form-check-label" for="user_misc_1"> ooF</label>
        </div>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
          <label class="form-check-label" for="user_misc_2"> raB</label>
        </div>
      </div>
    HTML

    actual = @builder.collection_radio_buttons(:misc, collection, :id, ->(a) { a.street.reverse }) do |builder|
      builder.radio_button(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_radio_buttons renders multiple radios with value defined by lambda correctly with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc]" type="radio" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1"> Foo</label>
        </div>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc]" type="radio" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2"> Bar</label>
        </div>
      </div>
    HTML

    actual = @builder.collection_radio_buttons(:misc, collection, ->(a) { "address_#{a.id}" }, :street) do |builder|
      builder.radio_button(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end
end
