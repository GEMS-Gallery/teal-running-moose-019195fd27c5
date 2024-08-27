import Nat "mo:base/Nat";
import Order "mo:base/Order";
import Text "mo:base/Text";

import Array "mo:base/Array";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Debug "mo:base/Debug";

actor {
  // Define the Post type
  public type Post = {
    id: Nat;
    title: Text;
    body: Text;
    author: Text;
    timestamp: Time.Time;
  };

  // Stable variable to store posts
  stable var posts : [Post] = [];
  stable var nextId : Nat = 0;

  // Create a new post
  public func createPost(title: Text, body: Text, author: Text) : async Result.Result<Post, Text> {
    let post : Post = {
      id = nextId;
      title = title;
      body = body;
      author = author;
      timestamp = Time.now();
    };
    posts := Array.append(posts, [post]);
    nextId += 1;
    #ok(post)
  };

  // Get all posts, sorted by timestamp (most recent first)
  public query func getPosts() : async [Post] {
    Array.sort(posts, func(a: Post, b: Post) : Order.Order {
      if (a.timestamp > b.timestamp) { #less }
      else if (a.timestamp < b.timestamp) { #greater }
      else { #equal }
    })
  };
}
