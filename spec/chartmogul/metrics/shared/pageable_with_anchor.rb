# frozen_string_literal: true

shared_examples 'PageableWithAnchor' do
  it 'should be pageable' do
    response = do_request

    expect(response.has_more).not_to be_nil
    expect(response.per_page).not_to be_nil
  end
end
