module Api
  module V1
    # BathroomsController
    # This controller serves a JSON API to the Bathrooms. It implements
    # standard 5 actions: [index, show, create, update, destroy].
    #
    # Successful response:
    #
    #     {
    #       "bathroom" :
    #       {
    #         "id" : 2,
    #         "name" : "foo",
    #         "sparkcore_id" : "8f7b5c6f0c6b5555bf9d14e2",
    #         "status" : "available",
    #         "status_updated_at" : "2014-05-17T05:24:09.878Z"
    #       }
    #     }
    #
    # Unsuccessful response:
    #
    #     {
    #       "error" : "<some message>"
    #     }
    #
    class BathroomsController < BackendController
      # GET /api/v1/bathrooms
      # Returns all of the Bathrooms.
      def index
        @bathrooms = Bathroom.all
        render json: @bathrooms, each_serializer: BathroomSerializer
      end

      # POST /api/v1/bathrooms
      # Creates a Bathroom. Must provide a "name" and a "sparkcore_id".
      #
      # TODO: Add state for unknown, this will be the state a new bathroom
      # is in.
      def create
        @bathroom = Bathroom.new(bathroom_params)
        if @bathroom.save
          render json: @bathroom
        else
          render json: @bathroom.errors
        end
      end

      # GET /api/v1/bathrooms/:id
      # Returns a single bathroom.
      def show
        @bathroom = Bathroom.find(params[:id])
        render json: @bathroom
      end

      # PATCH or PUT /api/v1/bathrooms/:id
      # Updates the "name" or "sparkcore_id" of a bathroom.
      def update
        @bathroom = Bathroom.find(params[:id])
        if @bathroom.update_attributes(bathroom_params)
          render json: @bathroom
        else
          render json: @bathroom.errors
        end
      end

      # DELETE /api/v1/bathrooms/:id
      # Destroys a bathroom, returning it's representation.
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
