module Api
  module V1
    class BathroomStatusController < ApplicationController

      def index
        respond_to do |format|
          format.json { render json: [{}] }
          format.xml  { render xml: [{}] }
        end
      end

      def show
        respond_to do |format|
          format.json { render json: [{}] }
          format.xml  { render xml: [{}] }
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