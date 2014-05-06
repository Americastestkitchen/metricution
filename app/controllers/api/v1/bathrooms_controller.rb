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

      def create
        @bathroom = Bathroom.new(bathroom_params)

        respond_to do |format|
          if @bathroom.save
            format.json { render json: @bathroom }
            format.xml  { render xml: @bathroom }
          else
            format.json { render json: @bathroom.errors }
            format.xml  { render xml: @bathroom.errors }
          end
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
        @bathroom = Bathroom.find(params[:id])

        respond_to do |format|
          if @bathroom.update_attributes(bathroom_params)
            format.json { render json: @bathroom }
            format.xml  { render xml: @bathroom }
          else
            format.json { render json: @bathroom.errors }
            format.xml  { render xml: @bathroom.errors }
          end
        end
      end

      def destroy
        @bathroom = Bathroom.find(params[:id])
        @bathroom.destroy

        respond_to do |format|
          format.json { render json: @bathroom }
          format.xml  { render xml: @bathroom }
        end
      end

      protected

      def bathroom_params
        params.require(:bathroom).permit(:name, :sparkcore_id)
      end

    end
  end
end