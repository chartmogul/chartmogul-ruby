shared_examples 'Pageable' do
  it 'should be pageable' do
    response = do_request

    expect(response.page).to_not be_nil
    expect(response.has_more).to_not be_nil
    expect(response.per_page).to_not be_nil
  end
end

