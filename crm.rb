require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, "sqlite3:database.sqlite3")
class Contact

	include DataMapper::Resource

	property :id, Serial
	property :first_name, String
	property :last_name, String
	property :email, String
	property :note, String

end

DataMapper.finalize
DataMapper.auto_upgrade!

get '/' do
	@crm_app_name = "the best CRM"
	erb :index
end


get '/contacts' do
	@contacts = Contact.all
	erb :contacts1
end

get '/contacts/modify' do
	@contacts = Contact.all
	erb :find_contacts
end

get '/contacts/new' do
	erb :new_contact
end

post '/contacts' do
	new_contact=Contact.create(:first_name => params[:first_name],
		:last_name => params[:last_name],
		:email => params[:email],
		:note => params[:note]
		)
	redirect to('/contacts')
end

get '/contacts/:id' do
	@contact = Contact.get(params[:id].to_i)
	if @contact
		erb :show_contact
	else
		raise Sinatra::NotFound
	end
end

get "/contacts/:id/edit" do
	@contact = Contact.get(params[:id].to_i)
	if @contact
		erb :editcontact
	else
		raise Sinatra::NotFound
	end
end

post '/contacts/:id' do
	contact=Contact.get(params[:id].to_i)
	contact.update(:first_name => params[:first_name])
	contact.update(:last_name => params[:first_name])
	contact.update(:email => params[:email])
	contact.update(:note => params[:note])
	redirect to("/contacts")
end

delete "/contacts/:id" do
	contact = Contact.get(params[:id].to_i)
	if contact
		contact.destroy
		redirect to("/contacts")
	else
		raise Sinatra::NotFound
	end
end

post "/contacts/:id/edit" do
	if @foundcontact.size > 0
		erb :editcontact
	else
		raise Sinatra::NotFound
	end
end
# get '/contacts/find' do
# 	erb :find_contacts
# end

get '/search' do
	if params[:first_name] || params[:last_name]
		@contact = (Contact.all(:first_name => params[:first_name]) & Contact.all(:last_name => params[:last_name]))[0]
		p @contact
		puts "\n\n\n\n\n\n"
		if @contact
			erb :show_contact
		else
			raise Sinatra::NotFound
		end
	else
		erb :find_contacts
	end
end

