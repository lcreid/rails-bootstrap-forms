require_relative "test_helper"

class BootstrapCheckboxTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup :setup_test_fixture

  test "check_box is wrapped correctly" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" extra="extra arg" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", extra: "extra arg")
  end

  test "check_box empty label" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">&#8203;</label>
      </div>
    HTML
    # &#8203; is a zero-width space.
    assert_equivalent_html expected, @builder.check_box(:terms, label: "&#8203;".html_safe)
  end

  test "disabled check_box has proper wrapper classes" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" disabled="disabled" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" disabled="disabled" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", disabled: true)
  end

  test "check_box label allows html" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the <a href="#">terms</a>
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: 'I agree to the <a href="#">terms</a>'.html_safe)
  end

  test "check_box accepts a block to define the label" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms) { "I agree to the terms" }
  end

  test "check_box accepts a custom label class" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label btn" for="user_terms">
          Terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label_class: "btn")
  end

  test "check_box 'id' attribute is used to specify label 'for' attribute" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="custom_id" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="custom_id">
          Terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, id: "custom_id")
  end

  test "check_box responds to checked_value and unchecked_value arguments" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="no" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="yes" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, { label: "I agree to the terms" }, "yes", "no")
  end

  test "inline checkboxes" do
    expected = <<~HTML
      <div class="form-check form-check-inline mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", inline: true)
  end

  test "inline checkboxes from form layout" do
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user row row-cols-auto g-3 align-items-center" id="new_user" method="post">
        <div class="col">
          <div class="form-check form-check-inline">
            <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
            <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
            <label class="form-check-label" for="user_terms">I agree to the terms</label>
          </div>
        </div>
      </form>
    HTML
    actual = bootstrap_form_for(@user, layout: :inline) do |f|
      f.check_box(:terms, label: "I agree to the terms")
    end
    assert_equivalent_html expected, actual
  end

  test "disabled inline check_box" do
    expected = <<~HTML
      <div class="form-check form-check-inline mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" disabled="disabled" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" disabled="disabled" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", inline: true,
                                                                disabled: true)
  end

  test "inline checkboxes with custom label class" do
    expected = <<~HTML
      <div class="form-check form-check-inline mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label btn" for="user_terms">
          Terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, inline: true, label_class: "btn")
  end

  test "collection_check_boxes renders the form_group correctly" do
    collection = [Address.new(id: 1, street: "Foobar")]
    expected = <<~HTML
      <input #{autocomplete_attr} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">This is a checkbox collection</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">Foobar</label>
        </div>
        <small class="form-text text-muted">With a help!</small>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street,
                                                                     label: "This is a checkbox collection", help: "With a help!")
  end

  test "collection_check_boxes renders multiple checkboxes correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street)
  end

  test "collection_check_boxes renders multiple checkboxes contains unicode characters in IDs correctly" do
    struct = Struct.new(:id, :name)
    collection = [struct.new(1, "Foo"), struct.new("二", "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_二" name="user[misc][]" type="checkbox" value="二" />
          <label class="form-check-label" for="user_misc_二">Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :name)
  end

  test "collection_check_boxes renders inline checkboxes correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check form-check-inline">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foo
          </label>
        </div>
        <div class="form-check form-check-inline">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street,
                                                                     inline: true)
  end

  test "collection_check_boxes renders with checked option correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street,
                                                                     checked: 1)
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street,
                                                                     checked: collection.first)
  end

  test "collection_check_boxes renders with multiple checked options correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1"> Foo</label>
        </div>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2"> Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street,
                                                                     checked: [1, 2])
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street,
                                                                     checked: collection)
  end

  test "collection_check_boxes sanitizes values when generating label `for`" do
    collection = [Address.new(id: 1, street: "Foo St")]
    expected = <<~HTML
      <input #{autocomplete_attr} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_foo_st" name="user[misc][]" type="checkbox" value="Foo St" />
          <label class="form-check-label" for="user_misc_foo_st">
            Foo St
          </label>
        </div>
      </div>
    HTML
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :street, :street)
  end

  test "collection_check_boxes renders multiple checkboxes with labels defined by Proc :text_method correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            ooF
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            raB
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, proc { |a| a.street.reverse })
  end

  test "collection_check_boxes renders multiple checkboxes with values defined by Proc :value_method correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2">
            Bar
          </label>
        </div>
      </div>
    HTML
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, proc { |a| "address_#{a.id}" },
                                                                     :street)
  end

  test "collection_check_boxes renders multiple checkboxes with labels defined by lambda :text_method correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">
            ooF
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">
            raB
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, ->(a) { a.street.reverse })
  end

  test "collection_check_boxes renders multiple checkboxes with values defined by lambda :value_method correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, ->(a) { "address_#{a.id}" },
                                                                     :street)
  end

  test "collection_check_boxes renders with checked option correctly with Proc :value_method" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, proc { |a| "address_#{a.id}" },
                                                                     :street, checked: "address_1")
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, proc { |a| "address_#{a.id}" },
                                                                     :street, checked: collection.first)
  end

  test "collection_check_boxes renders with multiple checked options correctly with lambda :value_method" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <input #{autocomplete_attr} id="user_misc" name="user[misc][]" type="hidden" value="" />
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_address_1" name="user[misc][]" type="checkbox" value="address_1" />
          <label class="form-check-label" for="user_misc_address_1">
            Foo
          </label>
        </div>
        <div class="form-check">
          <input checked="checked" class="form-check-input" id="user_misc_address_2" name="user[misc][]" type="checkbox" value="address_2" />
          <label class="form-check-label" for="user_misc_address_2">
            Bar
          </label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, ->(a) { "address_#{a.id}" },
                                                                     :street, checked: %w[address_1 address_2])
    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, ->(a) { "address_#{a.id}" },
                                                                     :street, checked: collection)
  end

  test "collection_check_boxes renders with include_hidden options correctly" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :id, :street, include_hidden: false)
  end

  test "check_box skip label" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input position-static" id="user_terms" name="user[terms]" type="checkbox" value="1" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", skip_label: true)
  end

  test "check_box hide label" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input position-static" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label visually-hidden" for="user_terms">I agree to the terms</label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", hide_label: true)
  end

  test "collection_check_boxes renders error after last check box" do
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    @user.errors.add(:misc, "a box must be checked")

    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
          <input #{autocomplete_attr} id="user_misc" name="user[misc][]" type="hidden" value="" />
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="form-check">
            <input class="form-check-input is-invalid" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
            <label class="form-check-label" for="user_misc_1">Foo</label>
          </div>
          <div class="form-check">
            <input class="form-check-input is-invalid" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
            <label class="form-check-label" for="user_misc_2">Bar</label>
            <div class="invalid-feedback">a box must be checked</div>
          </div>
        </div>
      </form>
    HTML

    actual = bootstrap_form_for(@user) do |f|
      f.collection_check_boxes(:misc, collection, :id, :street)
    end

    assert_equivalent_html expected, actual
  end

  test "collection_check_boxes renders data attributes" do
    collection = [
      ["1", "Foo", { "data-city": "east" }],
      ["2", "Bar", { "data-city": "west" }]
    ]
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <div class="form-check">
          <input class="form-check-input" data-city="east" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_misc_1">Foo</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" data-city="west" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
          <label class="form-check-label" for="user_misc_2">Bar</label>
        </div>
      </div>
    HTML

    assert_equivalent_html expected, @builder.collection_check_boxes(:misc, collection, :first, :second, include_hidden: false)
  end

  test "collection_check_boxes renders multiple check boxes with error correctly" do
    @user.errors.add(:misc, "error for test")
    collection = [Address.new(id: 1, street: "Foo"), Address.new(id: 2, street: "Bar")]
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
          <input #{autocomplete_attr} id="user_misc" name="user[misc][]" type="hidden" value="" />
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="form-check">
            <input checked="checked" class="form-check-input is-invalid" id="user_misc_1" name="user[misc][]" type="checkbox" value="1" />
            <label class="form-check-label" for="user_misc_1"> Foo</label>
          </div>
          <div class="form-check">
            <input checked="checked" class="form-check-input is-invalid" id="user_misc_2" name="user[misc][]" type="checkbox" value="2" />
            <label class="form-check-label" for="user_misc_2"> Bar</label>
            <div class="invalid-feedback">error for test</div>
          </div>
        </div>
      </form>
    HTML

    actual = bootstrap_form_for(@user) do |f|
      f.collection_check_boxes(:misc, collection, :id, :street, checked: collection)
    end
    assert_equivalent_html expected, actual
  end

  test "check_box renders error when asked" do
    @user.errors.add(:terms, "You must accept the terms.")
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
          <div class="form-check mb-3">
          <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input is-invalid" id="user_terms" name="user[terms]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_terms">
            I agree to the terms
          </label>
          <div class="invalid-feedback">You must accept the terms.</div>
        </div>
      </form>
    HTML
    actual = bootstrap_form_for(@user) do |f|
      f.check_box(:terms, label: "I agree to the terms", error_message: true)
    end
    assert_equivalent_html expected, actual
  end

  test "check box with custom wrapper class" do
    expected = <<~HTML
      <div class="form-check mb-3 custom-class">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", wrapper_class: "custom-class")
  end

  test "inline check box with custom wrapper class" do
    expected = <<~HTML
      <div class="form-check form-check-inline mb-3 custom-class">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
        <label class="form-check-label" for="user_terms">
          I agree to the terms
        </label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", inline: true,
                                                                wrapper_class: "custom-class")
  end

  test "a required checkbox" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[terms]" type="hidden" value="0" />
        <input class="form-check-input" id="user_terms" name="user[terms]" required="required" type="checkbox" value="1"/>
        <label class="form-check-label required" for="user_terms">I agree to the terms</label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:terms, label: "I agree to the terms", required: true)
  end

  test "a required attribute as checkbox" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[email]" type="hidden" value="0"/>
        <input class="form-check-input" id="user_email" name="user[email]" required="required" type="checkbox" value="1"/>
        <label class="form-check-label" for="user_email">Email</label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:email, label: "Email")
  end

  test "an attribute with required and if is not marked as required" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[status]" type="hidden" value="0"/>
        <input class="form-check-input" id="user_status" name="user[status]" type="checkbox" value="1"/>
        <label class="form-check-label" for="user_status">Status</label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:status, label: "Status")
  end

  test "an attribute with presence validator and unless is not marked as required" do
    expected = <<~HTML
      <div class="form-check mb-3">
        <input #{autocomplete_attr} name="user[misc]" type="hidden" value="0"/>
        <input class="form-check-input" id="user_misc" name="user[misc]" type="checkbox" value="1"/>
        <label class="form-check-label" for="user_misc">Misc</label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.check_box(:misc)
  end
end
