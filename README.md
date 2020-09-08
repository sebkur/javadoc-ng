# Javadoc-NG – javadoc rewritten from scratch

The classic javadoc tool has been written in the 90's. Many things
changed since then, but the javadoc is still a bit old-fashioned.

Javadoc-NG is an attempt to create a modern version of javadoc, based
on modern technology and libraries as its building blocks.

On the backend side, it uses
[JavaParser](https://github.com/javaparser/javaparser),
a popular [javacc](https://github.com/javacc/javacc)-based parser,
for understanding Java source files and extracting information such as
available packages, classes, constructors, methods, fields etc. from it.
On top of that it uses an [ANTLR](https://github.com/antlr/antlr4) grammar
to make sense of Javadoc comments including the
embedded HTML code and tags such as `@author`, `@param`, `@see`, etc.

Typically a project or library that is being documented depends on a number
of other libraries and the JRE libraries. For various purposes it is necessary
to build the namespace of classes and members from those dependencies.
The [asm](https://gitlab.ow2.org/asm/asm) bytecode processor is used for this
task.

It builds on top of [jsoup](https://github.com/jhy/jsoup/) to
generate HTML code that can be served using an embedded
[Jetty](https://github.com/eclipse/jetty.project) or packaged as a WAR
file for deployment on any standard application server such as Tomcat
or Glassfish.

On the frontend side, it uses a [Bootstrap 4](https://github.com/twbs/bootstrap)
to create a nicely looking user interface.

## Gains

* Enable search for projects that don't have that feature enabled / still
  use an old JDK's javadoc (pre Java 9)
* Enable fuzzy search using ngrams, get results even with lazy typing
* Enable source code view for projects that do not enable that in their docs
* Code highlighting in source code view
