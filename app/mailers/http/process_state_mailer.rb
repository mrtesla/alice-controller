class Http::ProcessStateMailer < ActionMailer::Base
  default from: "alice@mrhenry.be"

  def changes(changes)
    @changes = changes

    @changes.each do |key, groups|
      @changes.delete key if groups.empty? or groups.values.all? { |g| g.empty? }
    end

    recipients = User.all.map(&:email)
    mail(:to => recipients, :subject => "[Alice] Process state changes")
  end
end
