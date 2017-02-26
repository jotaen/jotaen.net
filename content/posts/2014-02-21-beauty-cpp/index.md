+++
title = "The beauty of C++"
subtitle = "A tribute to the best programming language"
date = "2014-02-21"
tags = ["c++", "misc"]
image = "/posts/2014-02-21-beauty-cpp/beauty-of-cpp.jpg"
id = "wgCB2"
url = "wgCB2/the-beauty-of-cplusplus"
aliases = ["wgCB2"]
+++

Over the past two years I worked at a company where we developed desktop applications to operate and control technical prototypes. We used C++, because it covers the wide range from low-level stuff like direct memory access, as well as offering features of a high-level programming language. However, especially in terms of C++ I still find it hard to classify my own level of skill. On the one hand the concepts are basically no rocket science. But on the other, there were also these rare but awkward moments – for example when it took two hours to debug like 3 lines of code – which I never experienced with another language. Going over a list like the [issues on Guru Of The Week](http://www.gotw.ca/gotw) can put you right back in your place.

To say it with the words of Howard Wolowitz from The Big Bang Theory: I have strongly mixed feelings concerning C++. Bascially, I think that good code is not a matter of the programming language in the first place. But there are definitely languages, which are more straightforward and predictable. Wait – don’t they say, that the problem is always sitting between chair and keyboard? Objection! At least, it is only half the story: There is always one human being using the computer and another one, who had developed it. But that would be a topic in itself.

Anyway – the reason why I’m writing all this is, that I set out to condense all the awesomeness of C++ and put it into a single piece of code. This is the outcome:

{% highlight cpp %}
int main() {
  B<j>*a=(&r_)->n((!e||S::t)?r(*(o+u++)):s%t)[_r^=--u,p];
}
{% endhighlight %}

What purpose does this programm fulfill? – Well, I don’t know. But in some way I like it. However, I wrote a header file, with which the programm compiles, but I don’t know what that is actually good for either. (Except for making the programm compile.)

{% highlight cpp %}
// compiles with gcc 4.2.1

typedef int j;

template <typename T>
  struct B {
  B(){}
  B<j>* operator [](int) {return this;}
};

struct R_ { B<j> n(int){return B<j>();} };

int r(int x) { return x; }

struct S { static const bool t = true; };

R_ r_;
bool e;
int u,s,p,_r,t,o[0];
{% endhighlight %}


## Reward

So I thought of a small challenge to offer to you: If you, dearest reader, can develop a somewhat useful header file, please [mail it to me](/about). The only thing I claim is that your header compiles with the above programm. As reward for creative submissions, I send you a signed and personally dedicated copy, which you can frame and put on your wall. Then you can admire the beauty of our all beloved first-choice programming language everyday.

`return 0;`
