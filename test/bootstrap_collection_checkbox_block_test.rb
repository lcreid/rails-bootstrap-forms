# frozen_string_literal: true

require_relative "./test_helper"

class BootstrapCollectionCheckboxBlockTest < ActionView::TestCase
  include BootstrapForm::Helper

  setup :setup_test_fixture

  test "collection_check_boxes renders the form_group correctly with block" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">This is a checkbox collection</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">Foobar</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    actual = @builder.new_collection_check_boxes(:misc, collection, :id, :street, label: "This is a checkbox collection", help: "With a help!") do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_check_boxes renders multiple checkboxes correctly with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foo
          </label>
        </div>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    actual = @builder.new_collection_check_boxes(:misc, collection, :id, :street) do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_check_boxes renders multiple checkboxes contains unicode characters in IDs correctly with block" do
    struct = Struct.new(:id, :name)
    collection = [struct.new(1, "Foo"), struct.new("二", "Bar")]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foo
          </label>
        </div>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_二" name="user[misc][]" type="checkbox" value="二" />
          <label class="form-check-label" for="user_misc_二">
            Bar
          </label>
        </div>
      </div>
    HTML

    actual = @builder.new_collection_check_boxes(:misc, collection, :id, :name) do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_check_boxes renders inline checkboxes correctly with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check form-check-inline custom-class">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foo
          </label>
        </div>
        <div class="form-check form-check-inline custom-class">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    actual = @builder.new_collection_check_boxes(:misc, collection, :id, :street, inline: true) do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_check_boxes renders with checked option correctly with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input checked="checked" class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foo
          </label>
        </div>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    actual = @builder.new_collection_check_boxes(:misc, collection, :id, :street, checked: 1) do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
    actual = @builder.new_collection_check_boxes(:misc, collection, :id, :street, checked: collection.first) do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_check_boxes renders with multiple checked options correctly with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input checked="checked" class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1"> Foo</label>
        </div>
        <div class="form-check custom-class">
          <input checked="checked" class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2"> Bar</label>
        </div>
      </div>
    HTML

    actual = @builder.new_collection_check_boxes(:misc, collection, :id, :street, checked: [1, 2]) do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
    actual = @builder.new_collection_check_boxes(:misc, collection, :id, :street, checked: collection) do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_check_boxes sanitizes values when generating label `for` with block" do
    collection = [Address.new(id: 1, street: "Foo St")]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_foo_st" name="user[misc][]" type="checkbox" value="Foo St" />
          <label class="form-check-label" for="user_misc_foo_st">
            Foo St
          </label>
        </div>
      </div>
    HTML
    actual = @builder.new_collection_check_boxes(:misc, collection, :street, :street) do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_check_boxes renders multiple checkboxes with labels defined by Proc :text_method correctly with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            ooF
          </label>
        </div>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            raB
          </label>
        </div>
      </div>
    HTML

    actual = @builder.new_collection_check_boxes(:misc, collection, :id, proc { |a| a.street.reverse }) do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_check_boxes renders multiple checkboxes with values defined by Proc :value_method correctly with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1">
            Foo
          </label>
        </div>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2">
            Bar
          </label>
        </div>
      </div>
    HTML
    actual = @builder.new_collection_check_boxes(:misc, collection, proc { |a| "address_#{a.id}" }, :street) do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_check_boxes renders multiple checkboxes with labels defined by lambda :text_method correctly with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            ooF
          </label>
        </div>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            raB
          </label>
        </div>
      </div>
    HTML

    actual = @builder.new_collection_check_boxes(:misc, collection, :id, ->(a) { a.street.reverse }) do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_check_boxes renders multiple checkboxes with values defined by lambda :value_method correctly with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1">
            Foo
          </label>
        </div>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    actual = @builder.new_collection_check_boxes(:misc, collection, ->(a) { "address_#{a.id}" }, :street) do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_check_boxes renders with checked option correctly with Proc :value_method with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input checked="checked" class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1">
            Foo
          </label>
        </div>
        <div class="form-check custom-class">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    actual = @builder.new_collection_check_boxes(:misc, collection, proc { |a| "address_#{a.id}" }, :street, checked: "address_1") do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
    actual = @builder.new_collection_check_boxes(:misc, collection, proc { |a| "address_#{a.id}" }, :street, checked: collection.first) do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_check_boxes renders with multiple checked options correctly with lambda :value_method with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input checked="checked" class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1">
            Foo
          </label>
        </div>
        <div class="form-check custom-class">
          <input checked="checked" class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    actual = @builder.new_collection_check_boxes(:misc, collection, ->(a) { "address_#{a.id}" }, :street, checked: %w[address_1 address_2]) do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
    actual = @builder.new_collection_check_boxes(:misc, collection, ->(a) { "address_#{a.id}" }, :street, checked: collection) do |builder|
      builder.check_box(wrapper_class: "custom-class")
    end
    assert_equivalent_xml expected, actual
  end

  test "collection_check_boxes renders error after last check box with block" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    @user.errors.add(:misc, "a box must be checked")

    expected = <<-HTML.strip_heredoc
    <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
      <input name="utf8" type="hidden" value="&#x2713;"/>
      <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <div class="form-check custom-class">
          <input class="form-check-input is-invalid" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">Foo</label>
        </div>
        <div class="form-check custom-class">
          <input class="form-check-input is-invalid" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">Bar</label>
          <div class="invalid-feedback">a box must be checked</div>
        </div>
      </div>
    </form>
    HTML

    actual = bootstrap_form_for(@user) do |f|
      f.new_collection_check_boxes(:misc, collection, :id, :street) do |builder|
        builder.check_box(wrapper_class: "custom-class")
      end
    end

    assert_equivalent_xml expected, actual
  end

  test "collection_check_boxes renders multiple check boxes with error correctly with block" do
    @user.errors.add(:misc, "error for test")
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <input id="user_misc" multiple="multiple" name="user[misc][]" type="hidden" value="" />
        <div class="form-group">
          <label for="user_misc">Misc</label>
          <div class="form-check custom-class">
            <input checked="checked" class="form-check-input is-invalid" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
            <label class="form-check-label" for="user_misc_1"> Foo</label>
          </div>
          <div class="form-check custom-class">
            <input checked="checked" class="form-check-input is-invalid" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
            <label class="form-check-label" for="user_misc_2"> Bar</label>
            <div class="invalid-feedback">error for test</div>
          </div>
        </div>
      </form>
    HTML

    actual = bootstrap_form_for(@user) do |f|
      f.new_collection_check_boxes(:misc, collection, :id, :street, checked: collection) do |builder|
        builder.check_box(wrapper_class: "custom-class")
      end
    end
    assert_equivalent_xml expected, actual
  end
end
