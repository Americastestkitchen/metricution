module Api
  module V1
    class BathroomsController < BackendController

      def index
        @bathrooms = Bathroom.all

        respond_to do |format|
          format.json { render json: @bathrooms.to_json }
          format.xml  { render xml: @bathrooms.to_xml }
        end
      end

      def show
        @bathroom = Bathroom.find(params[:id])

        respond_to do |format|
          format.json { render json: @bathroom.to_json }
          format.xml  { render xml: @bathroom.to_xml }
        end
      end

      def update
        # Logic.

        respond_to do |format|
          format.json { render json: [{}] }
          format.xml  { render xml: [{}] }
        end
      end

    end
  end
end