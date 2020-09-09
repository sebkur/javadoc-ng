# Javadoc-NG – javadoc rewritten from scratch

The classic javadoc tool has been written in the 90's. Many things
have changed since then, but javadoc and the sites it generates are
still a bit old-fashioned.

Javadoc-NG is an attempt to create a modern version of javadoc, based
on modern technology and libraries as its building blocks.
It is intended to be easy to use and to customize and it should
integrate seamlessly with other parts of a project's documentation.

## tl;dr show me how it looks!

See [Multiset](https://javadocng.mobanisto.com/guava-29.0/com/google/common/collect/Multiset.html)
or [Splitter](https://javadocng.mobanisto.com/guava-29.0/com/google/common/base/Splitter.html)
from Google's Guava; also see the [package
index](https://javadocng.mobanisto.com/guava-29.0/packages.html) and also try
the [search
functionality](https://javadocng.mobanisto.com/guava-29.0/search?q=joiner).

We've also uploaded a version of LocationTech's [JTS](https://javadocng.mobanisto.com/jts-1.17.1/),
see [Coordinate](https://javadocng.mobanisto.com/jts-1.17.1/org/locationtech/jts/geom/Coordinate.html)
or [KdTree](https://javadocng.mobanisto.com/jts-1.17.1/org/locationtech/jts/index/kdtree/KdTree.html)
for some examples there.

If you want to try it out with your own code or a library of your choice, jump
right to [usage section](#how-does-it-work).

## What's the problem with the old javadoc?

It's a bit fuzzy, but using a Javadoc site just feels like going back
in time a few decades.
For example many Javadoc deployments still use the good old frameset
like the official [JDK8 docs](https://docs.oracle.com/javase/8/docs/api/) do.
Starting with JDK9, the frameset [is
gone](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/lang/String.html),
but it has not been replaced with anything useful.
It does have a search feature now, but it is not very forgiving
concerning typos, so it's better to know precisely what you're looking for
to get useful results. It is also sometimes broken, for example try to click any
of the type or member search result in these
[docs from the Error Prone project](https://errorprone.info/api/latest/#) and get
a 404 error.
Many libraries do not have the search feature enabled though, because
they are written to be compatible with the still
popular Java 8 and hence use the old JDK8's javadoc tool chain for generating
their documentation.
Often you find yourself clicking into the "All Classes" frame and using the
browser's own search feature to locate a class – or head back to Google and use
that to find the class you're looking for.

While many things can be criticized in terms of UI and UX, I think one
important point is that Javadocs cannot be easily integrated seamlessly
into a project's homepage.
Many projects use a custom stylesheet to change some colors like the
[Gradle docs](https://docs.gradle.org/current/javadoc/index.html) do, but
that's usually it.
I have only seen a true
integration into the navigation of the project site as a whole
on the [Android
documentation](https://developer.android.com/reference/java/lang/String).
I don't know what they are doing to create that documentation, but I assume
Google has created some internal tool for that.
Unfortunately whatever they created there is not available for others to use to
document their own libraries.

Another problem is that javadoc is not a lightweight tool – it is part of the
JDK and relies on a lot of internal APIs. It is difficult to hack the
documentation output, add a little extra functionality or remove unwanted
features. Best thing you can do is parse the generated HTML and try to
manipulate the output on that layer, which does not leed anywhere when making
anything but trivial adjustments. When you look at HTTP APIs being documented,
they are often integrated into the content section of project's website. Nobody
does that with Javadocs, although in my opinion it would totally make sense.

## Why start from scratch?

While some argue that rewriting something from scratch is
[something you should never
do](https://www.joelonsoftware.com/2000/04/06/things-you-should-never-do-part-i/),
there's also people who believe there are not only reasons against, but
[also in favor](https://wiki.c2.com/?RewriteCodeFromScratch) of rewriting
something from scratch.

The javadoc tool has generally been designed with the idea in mind that others
might want to change the output of the tool, which is why it is possible to
implement your own
[Doclet](https://github.com/openjdk/jdk/blob/master/src/jdk.javadoc/share/classes/jdk/javadoc/doclet/Doclet.java)
and pass that to the tool.
While that interface looks relatively simple, when trying to change the output
of the Javadoc standard doclet, you'll discover that you really need to dig
through an [internal
package](https://github.com/openjdk/jdk/tree/master/src/jdk.javadoc/share/classes/jdk/javadoc/internal/doclets/toolkit)
with about 99 files and 22565 lines of code that is really cumbersome
after 25 years of evolution.
For one the project started with the language features from Java 1.0, which has
evolved drastically since then.
Also, there were no libraries available to the developers at that time, to make
their life easier except what was in the JDK itself.
To name just one example, there was probably no HTML library available
so the doclet comes with its own [HTML generator
engine](https://github.com/openjdk/jdk/blob/master/src/jdk.javadoc/share/classes/jdk/javadoc/internal/doclets/formats/html/markup/HtmlTree.java).

## What is the stack of javadoc-ng?

On the backend side, it uses
[JavaParser](https://github.com/javaparser/javaparser),
a popular [javacc](https://github.com/javacc/javacc)-based parser,
for understanding Java source files and extracting information such as
available packages, classes, constructors, methods, fields etc. from it.
On top of that it uses an [ANTLR](https://github.com/antlr/antlr4) grammar
to make sense of Javadoc comments including the
embedded HTML code and tags such as `@author`, `@param`, `@see`, etc.

Typically, a project or library that is being documented depends on a number
of third party libraries and of course the JRE libraries.
In order to create proper cross-reference links to library classes and methods,
it is necessary to build the namespace of types and members from those dependencies.
The [asm](https://gitlab.ow2.org/asm/asm) bytecode processor is used for this
task.

It builds on top of [jsoup](https://github.com/jhy/jsoup/) to
generate HTML code that can be served using an embedded
[Jetty](https://github.com/eclipse/jetty.project) or packaged as a WAR
file for deployment on any standard application server such as Tomcat
or Glassfish.
The ability to generate static sites consisting of plain files only,
like the classic javadoc tool does, is also a goal, however preference
is currently given to an application server based deployment.

On the frontend side, it uses [Bootstrap 4](https://github.com/twbs/bootstrap)
to create an elegant user interface. Reading software documentation on mobile
devices might be a corner case, but Bootstrap also provides us with a framework
that is well-suited for building a UI that works well on desktop screens of
varying sizes.

## What do I gain by using javadoc-ng?

* Get a modern, decent layout
* Enable search for projects that don't have that feature enabled / still
  use an old JDK's javadoc (pre Java 9)
* Enable fuzzy search using ngrams, get results even with lazy typing
  (for example, search for [spitter](https://javadocng.mobanisto.com/guava-29.0/search?q=spitter)
  in Guava and still find Splitter)
* Enable source code view for projects that do not enable that in their docs
* Code highlighting in source code view (Compare
  [classic](https://guava.dev/releases/29.0-jre/api/docs/src-html/com/google/common/base/Splitter.html)
  to
  [javadoc-ng](https://javadocng.mobanisto.com/guava-29.0/src-html/com/google/common/base/Splitter.html))
* The development has really just begun, so you can shape the features it
  supports and get your documentation to look the way you want it to

## How does it work?

### Prerequisites

First download
[javadoc-ng-0.0.1.jar](https://github.com/sebkur/javadoc-ng/releases/download/v0.0.1/javadoc-ng-0.0.1.jar).

You'll need Java 9 or later to execute the Jar file, I have tested with Java 11.

### Running a web server locally from the CLI

Assuming you have downloaded a [Guava source
jar](https://repo1.maven.org/maven2/com/google/guava/guava/29.0-jre/guava-29.0-jre-sources.jar)
to `/tmp/guava.jar`, then you can run:

    java -jar javadoc-ng-0.0.1.jar run-server 
        --input /tmp/guava.jar --title "Guava 29.0"

After parsing the source files contained in the Jar file, this output should
appear:

    Please visit http://localhost:8080

You can then visit http://localhost:8080 in your browser to browse the
documentation.

If you have a project on your disk just point the tool to a directory instead of
a jar file and it will pick up all `*.java` files recursively and build the
documentation for that:

    java -jar javadoc-ng-0.0.1.jar run-server
        --input /tmp/guava --title "Guava 29.0"

Even better, you can just pass a Maven coordinate to the tool and let it fetch
the Jar artifact for you:

    java -jar javadoc-ng-0.0.1.jar run-server
        --coordinates com.google.guava:guava:29.0-jre
        --title "Guava 29.0"

You can pass a `--port` argument to start the server on a different port:

    java -jar javadoc-ng-0.0.1.jar run-server
        --input /tmp/guava --title "Guava 29.0"
        --port 9000

### Building a WAR for deployment on an application server

You can create a WAR archive for deployment on an application server like this:

    java -jar javadoc-ng-0.0.1.jar create-war
        --input /tmp/guava.jar --title "Guava 29.0"
        --output /tmp/guava.war

You can deploy that to your application server or just download the
[jetty-runner](https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-runner/9.4.31.v20200723/jetty-runner-9.4.31.v20200723.jar)
and use it to run the application like this:

    java -jar /home/z/jetty/jetty-runner-9.4.31.v20200723.jar
        /tmp/guava.war

Jetty also accepts a `--port` argument, so you can start it on a different port,
too:

    java -jar /home/z/jetty/jetty-runner-9.4.31.v20200723.jar
        --port 9000 /tmp/guava.war

As with the `run-server` task, you can specify a directory or a Maven coordinate
instead of jar file as input:

    java -jar javadoc-ng-0.0.1.jar create-war
        --coordinates com.google.guava:guava:29.0-jre
        --title "Guava 29.0"
