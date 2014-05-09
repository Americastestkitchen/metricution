module Api
  module V1
    class BathroomsController < BackendController
      respond_to :json

      def index
        @bathrooms = Bathroom.all
        render json: @bathrooms, each_serializer: BathroomSerializer
      end

      def create
        @bathroom = Bathroom.new(bathroom_params)
        if @bathroom.save
          render json: @bathroom
        else
          render json: @bathroom.errors
        end
      end

      def show
        @bathroom = Bathroom.find(params[:id])
        render json: @bathroom
      end

      def update
        @bathroom = Bathroom.find(params[:id])
        if @bathroom.update_attributes(bathroom_params)
          render json: @bathroom
        else
          render json: @bathroom.errors
        end
      end

      def destroy
        @bathroom = Bathroom.find(params[:id])
        @bathroom.destroy
        render json: @bathroom
      end

      protected

      def bathroom_params
        params.require(:bathroom).permit(:name, :sparkcore_id)
      end

    end
  end
end