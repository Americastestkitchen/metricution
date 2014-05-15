# Metricution

This project aims to pull in data and statistics that are relevant to the lives of the development team at Americas Test Kitchen. These are things range from the status of the bathroom to JIRA tickets overviews and GitHub pull request summaries.

## Setup

This will guide you through getting all the needed components of this application. Please see [Project Overview](#project-overview) for a technical explanation of the system.

### Cloning the Project

    git clone https://github.com/Americastestkitchen/metricution.git

### System Dependencies

These are the requirements to have installed on your system to run this application.

- Ruby 2.1
- Postgres 9.2.4+ (not testing on other versions)
- Redis 2.8.9

### Ruby Dependencies

As with any other sane modern Ruby project, the dependencies of this project are managed with [Bundler](http://bundler.io).

    bundle install

### Environment Dependencies

In order for the application to connect to the Spark Cloud for events from the bathroom monitor hardware we need to provide an auth token.

    # .env
    SPARK_AUTH_TOKEN=<TOKEN>

### Starting the Server

This application uses [Foreman](http://ddollar.github.io/foreman) for managing it's environment and starting things up. This means starting the server is very simple.

    foreman start

## Development

In order to help with development you can start the monitor with `foreman run bundle exec bin/monitor mock`. This will send the web app Redis events in the same form as it would if actual bathrooms were being updated. This process will not touch the database.

To start the whole app with mocked data I recomend running the two processes in thier own terminal window.

    # tty1
    foreman run bundle exec bin/monitor mock
    # tty2
    foreman start web

You could start them together

    foreman start web &; foreman run bundle exec bin/monitor mock

but backgrounding things that print to STDOUT is irritating.

## Project Overview

This will serve as a high level explanation about the components of this application to someone who has never touched this code base before. It will also serve as the highest level of documentation to put in words the thoughts behind this project.

### Rails

The Rails side of this application is broken into two parts. The frontend, and the backend. Unlike most Rails apps this project makes these two things __very__ separate. The backend controllers inherit from their own `BackendConroller`, and the whole front end is served from the `FrontendController`.

#### Backend

The first thing you'll notice is there are a lot of folders missing in `app/`. There are no views, helpers, or assets. This is because the __whole__ frontend lives in the `client/` folder. This makes the separation very clear at the filesystem level.

#### Frontend

TODO: Write this once we have some ember stuff in the codebase.

### Bathroom Monitoring

The hardware of the bathroom monitor is a [Spark Core](https://www.spark.io), these are great because they have WiFi built in so communication can happen all over HTTP, no need to build out our own radio protocols and message formats. The Spark Core talks to a server aptly named the Spark Cloud via [Sever Sent Events (SSE)](http://en.wikipedia.org/wiki/Server-sent_events) with information about the status of the bathroom. When the door is opened or closed it sends an event with the status of the door, and the core's id. Our server subscribes to this stream of SSE events and updates it's internal representation of a bathroom. This internal representation is stored internally in the database. The web client opens it's own SSE connection to our server which we respond with updates as they come in to us. The data flow looks like this.

    Spark Core => Spark Cloud => Metricution Worker => Redis => Metricution Controller => Web Browser

Having the controller sit in the middle allows us to send the initial status of the bathroom before we have gotten an event for new web clients.