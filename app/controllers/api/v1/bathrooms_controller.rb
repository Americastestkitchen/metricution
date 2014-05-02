module Api
  module V1
    class BathroomsController < BackendController

      def index
        @bathrooms = Bathroom.all

        respond_to do |format|
          format.json { render json: @bathrooms, root: false }
          format.xml  { render xml: @bathrooms }
        end
      end

      def show
        @bathroom = Bathroom.find(params[:id])

        respond_to do |format|
          format.json { render json: @bathroom }
          format.xml  { render xml: @bathroom }
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