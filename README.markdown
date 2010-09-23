ResponseAssembler
=======================

ResponseAssembler is a piece of middleware that is meant to provide a way for quickly and easily assembling HTTP response documents from many "parts" (other responses). Let's say you want to have your pages built from posts, sidebar and menu - each of these can be returned by separate URLs (/posts/1, /sidebar, /menu) and ResponseAssembler will merge it for you into one HTML document.

ResponseAssembler can be used with Rack-Cache. For example, you might want to store your /posts/1 response in cache, and pull interactive (not cached) elements on the page. You can do it in Javascript on the client side, but to make it a bit nicer for google or lynx users (;)) you might want to assemble initial version on server side. We have provided you even a helper that mimicks XMLHttpRequest when you want to replace your current Javascript solution so you don't have to change your controllers! ResponseAssembler won't do caching for you, you need to use Rack-Cache instead and teach your app to use it.

You can use ResponseAssembler with CSS, JavaScript, text or CSV files. Please look at example to find out how to specify response mime types that ResponseAssembler should parse.

Usage
=====

Example of using middleware module
----------------------------------

Say, you want to render single Post (/posts/1), and add extra menu, sidebar and comments boxes.
I assume you are using Rails.

First you need to download response_assembler.rb and place it into lib/rack/ directory under your RAILS_ROOT (create it if it's not there).

To enable ResponseAssembler::Middleware, plact this line into your environment.rb:
    
    config.middleware.use "ResponseAssembler::Middleware"

Now, you don't have to change your PostsController::index action at all, just edit it's view template to return something like:

    <get>/menu</get>
    <get>/sidebar</get>
    <h1><%= @post.title %></h1>
    <p><%= @post.body %></p>
    <get><%= post_comments_path @post %></get> // this is /posts/1/comments for example where your comments controller sits

You can see that your response will include what /menu /sidebar and /posts/1/comments returns.

Don't forget to add :layout => false to your /menu /sidebar and /posts/1/comments actions.

If you want to use the same logic for future AJAX requests (say for CommentsController), for example to skip rendering layout, you can mimick XMLHttpRequest by using <xhrget>/some/ajax/controller</xhrget> instead of normal "get".

Options
-------

In you config.ru file, you can use two extra options to initialize ResponseAssembler::Middleware. 

ResponseAssembler will render <p>Part loading failed...</p> in places where responses from your app had different status code than 200 HTTP OK. If you want to change this message, just use:

    use ResponseAssembler::Middleware, "Oops, can't find part"

and if you want to filter, say - only text/css files for inclusions, use array of content types at end of line:

    use ResponseAssembler::Middleware, "/* Oops, can't find part of this CSS */", ["text/css"]

