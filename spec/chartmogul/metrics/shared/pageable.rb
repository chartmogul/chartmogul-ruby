shared_examples 'Pageable' do
  it 'should be pageable' do
    response = do_request

    expect(response.page).not_to be_nil
    expect(response.has_more).not_to be_nil
    expect(response.per_page).not_to be_nil
  end
end

