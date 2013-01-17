Taobaoke::Application.routes.draw do
  
  match 'about/(:action)' => 'about#:action'
  match 'ct/(:id)' => 'about#ct'
  match 'i/(:id)' => 'about#i'
  
  match 'q' => 'about#q'
  match 'q/(:id)' => 'about#q'
  
  match 'phone' => 'start#phone'  
  match 'cat/(:action)' => 'start#:action'
  match 'p/(:id)' => 'start#p'
  match 'c/(:id)' => 'start#c'
  
  root :to => 'start#index'
  
end
