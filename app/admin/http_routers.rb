ActiveAdmin.register Http::Router do
  menu :parent => "Http"

  index do
    id_column
    column "Machine" do |router|
      router.machine.host
    end
    column :port
    default_actions
  end
end
