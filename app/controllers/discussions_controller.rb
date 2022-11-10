class DiscussionsController < ApplicationController

  def show
    discussion_id = params[:id]
    @root_discussion = Discussion.get_root_post(discussion_id)
    @discussions_with_replies = Discussion.get_post_replies(@root_discussion[:id])
  end

  def index
    @discussions = Discussion.get_root_posts
  end

  def new

  end

  def create
    discussion = params[:discussion]
    root_id = -1
    if discussion.has_key? :root_discussion_id
      root_id = discussion[:root_discussion_id]
    end
    Discussion.create!(:title => discussion[:title], :body => discussion[:body], :author => discussion[:author], :root_discussion_id => root_id)
    redirect_to discussions_path
  end

  def create_reply
    root_discussion_id = params[:root_discussion_id]
    body = params[:body]
    author = params[:author]
    discussion_reply = Discussion.create!(:title => '', :body => body, :author => author, :root_discussion_id => root_discussion_id)
    redirect_to discussion_path(root_discussion_id)
  end

  def edit
    id = params[:id]
    @discussion = Discussion.find(id)
  end

  def update
    id = params[:id]
    new_title = params[:discussion][:title]
    new_body = params[:discussion][:body]
    discussion = Discussion.find(id)
    discussion.update(title: new_title)
    discussion.update(body: new_body)
    if discussion[:root_discussion_id] != -1
      return redirect_to discussion_path(discussion[:root_discussion_id])
    end
    redirect_to discussions_path
  end

  def destroy
    id = params[:id]
    discussion = Discussion.find(id)
    discussion.destroy
    if discussion[:root_discussion_id] != -1
      return redirect_to discussion_path(discussion[:root_discussion_id])
    end
    redirect_to discussions_path
  end

end