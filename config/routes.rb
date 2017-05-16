Rails.application.routes.draw do
  get 'welcome/index'
 
  root 'welcome#index'
  get 'expediente' => 'welcome#expediente'
  get 'abnormal' => 'welcome#abnormal'
  get 'prescriptions' => 'welcome#prescriptions'
  get 'labtest' => 'welcome#labtest'
end
