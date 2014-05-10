module Api
  module V1
    class BathroomsController < BackendController

      def index
        @bathrooms = Bathroom.all
        render @bathrooms, each_serializer: BathroomSerializer
      end

      def create
        @bathroom = Bathroom.new(bathroom_params)
        if @bathroom.save
          render @bathroom
        else
          render @bathroom.errors
        end
      end

      def show
        @bathroom = Bathroom.find(params[:id])
        render @bathroom
      end

      def update
        @bathroom = Bathroom.find(params[:id])
        if @bathroom.update_attributes(bathroom_params)
          render @bathroom
        else
          render @bathroom.errors
        end
      end

      def destroy
        @bathroom = Bathroom.find(params[:id])
        @bathroom.destroy
        render @bathroom
      end

      protected

      def bathroom_params
        params.require(:bathroom).permit(:name, :sparkcore_id)
      end

    end
  end
end
