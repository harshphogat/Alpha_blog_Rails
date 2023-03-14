class PagesController < ApplicationController
    def test
        redirect_to articles_path if logged_in?
    end
end
