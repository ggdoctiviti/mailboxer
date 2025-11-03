class Mailboxer::BaseBuilder

  attr_reader :params

  def initialize(params)
    @params = params.with_indifferent_access
  end

  def build
    klass.new.tap do |object|
      params.keys.each do |field|
        object.send("#{field}=", get(field)) unless (get(field).nil? || field.eql?("attachment"))
        att = get("attachment").nil? ? nil : Mailboxer::AttachmentUploader.new(attachment: get("attachment"))
        object.attachment = att unless att.nil?
      end
    end
  end

  protected

  def get(key)
    respond_to?(key) ? send(key) : params[key]
  end

  def recipients
    Array(params[:recipients]).uniq
  end
end
