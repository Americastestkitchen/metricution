require 'spec_helper'

describe Api::V1::BathroomsController, 'GET index' do
  it 'returns an array of bathrooms' do
    bathroom = create(:bathroom)
    get :index

    expect(
      assigns(:bathrooms)
    ).to include bathroom
  end

  it 'returns json formatted data' do
    bathroom = create(:bathroom)
    get :index

    expect(response.body).to eql(
      "{\"bathrooms\":#{[BathroomSerializer.new(bathroom, root: nil)].to_json}}"
    )
  end
end

describe Api::V1::BathroomsController, 'POST create' do
  context 'success' do
    it 'a new bathroom object gets saved on success' do
      expect{
        post :create, { bathroom: { name: '4th', sparkcore_id: '1234' } }
      }.to change{Bathroom.count}
    end

    it 'renders the bathroom' do
      post :create, { bathroom: { name: '4th', sparkcore_id: '1234' } }

      expect(
        response.body
      ).to eql BathroomSerializer.new(assigns(:bathroom)).to_json
    end
  end

  context 'failure' do
    it 'does not save a new bathroom object' do
      expect{
        post :create, { bathroom: { name: nil } }
      }.to_not change{Bathroom.count}
    end

    it 'renders errors messaging' do
      post :create, { bathroom: { name: nil } }
      expect(response.body).to eql assigns(:bathroom).errors.to_json
    end
  end
end

describe Api::V1::BathroomsController, 'GET show' do
  it 'returns a bathroom' do
    bathroom = create(:bathroom)
    get :show, { id: bathroom.id }

    expect(assigns(:bathroom)).to eql bathroom
  end

  it 'returns json formatted data' do
    bathroom = create(:bathroom)
    get :show, { id: bathroom.id }

    expect(response.body).to eql BathroomSerializer.new(bathroom).to_json
  end
end

describe Api::V1::BathroomsController, 'PUT update' do
  it 'renders the updated bathroom object' do
    bathroom = create(:bathroom)
    put :update, { id: bathroom.id, bathroom: { name: 'Godzilla' } }
    expect(
      response.body
    ).to eql BathroomSerializer.new(assigns(:bathroom)).to_json
  end

  # Not sure about error case atm
end

describe Api::V1::BathroomsController, 'DELETE destroy' do
  it 'assigns bathroom' do
    bathroom = create(:bathroom)
    delete :destroy, { id: bathroom.id }
    expect(assigns(:bathroom)).to eql bathroom
  end

  it 'destroys the bathroom record' do
    bathroom = create(:bathroom)
    expect{
      delete :destroy, { id: bathroom.id }
    }.to change{Bathroom.count}
  end

  it 'renders json formatted data for the destroyed bathroom' do
    bathroom = create(:bathroom)
    delete :destroy, { id: bathroom.id }

    expect(response.body).to eql BathroomSerializer.new(bathroom).to_json
  end
end
