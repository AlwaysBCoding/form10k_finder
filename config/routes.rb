Form10kFinder::Application.routes.draw do

root to: "search#index"

post "/search" => "search#find_form"

end
