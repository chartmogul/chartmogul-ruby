# frozen_string_literal: true

shared_examples 'PageableWithCursor' do
  it 'should be pageable' do
    response = do_request

    expect(response.has_more).not_to be_nil
    expect(response.cursor).not_to be_nil
  end
end
