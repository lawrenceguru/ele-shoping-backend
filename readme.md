# Letzell Phoenix GraphQL

## Technologies

### Frontend

- [TypeScript](https://github.com/Microsoft/TypeScript) - A superset of JavaScript that compiles to clean JavaScript output.
- [React](https://facebook.github.io/react) - A JavaScript library for building user interfaces. It introduces many great concepts, such as, Virtual DOM, Data flow, etc.
- [Webpack 4](https://github.com/webpack/webpack) - A bundler for javascript and friends. Packs many modules into a few bundled assets.
- [Bulma](https://bulma.io) - Bulma is a modern CSS framework based on Flexbox
- [Apollo 2](http://dev.apollodata.com) - A flexible, fully-featured GraphQL client for every platform.
- [React Final Form](https://github.com/erikras/react-final-form) - High performance subscription-based form state management for React.

### Backend

- Elixir 1.11
- Phoenix 1.5
- Erlang 24
- [Absinthe](https://github.com/absinthe-graphql/absinthe) - The [GraphQL](http://graphql.org) toolkit for Elixir.
- [Graphiql](https://github.com/graphql/graphiql) - Graphiql is an in-browser IDE for exploring GraphQL.
- [Arc](https://github.com/stavro/arc) - Flexible file upload and attachment library for Elixir.
- [ExAws](https://github.com/CargoSense/ex_aws) - A flexible, easy to use set of clients AWS APIs for Elixir. Use to store attachments in Amazon S3.
- PostgreSQL for database.

## Features

- CRUD (create / read / update / delete) on listings
- Creating comments on listings page
- Pagination on listing
- Searching on listings
- Authentication with token
- Creating user account
- Update user profile and changing password
- Confirm user account with a code sends by email
- Display comments and recipes in real-time
- Application ready for production

## GraphQL Using

- Queries et mutations
- FetchMore for pagination
- Using `apollo-cache-inmemory`
- Apollo Link (dedup, onError, auth)
- Subscription
- [Managing local state](https://github.com/apollographql/apollo-link-state) with Apollo Link
- Optimistic UI
- [Static GraphQL queries](https://dev-blog.apollodata.com/5-benefits-of-static-graphql-queries-b7fa90b0b69a)
- Validation management and integration with Final Form
- Authentication and authorizations
- Protect queries and mutations on GraphQL API
- Batching of SQL queries backend side

## Prerequisites

- Erlang 24 ([Installing Erlang](https://github.com/asdf-vm/asdf)
- Elixir 1.11 ([Installing Elixir](https://elixir-lang.org/install.html))
- Phoenix 1.5 ([Installing Phoenix](https://hexdocs.pm/phoenix/installation.html))
- Node 14.8 ([Installing Node](https://nodejs.org/en/download/package-manager))
- ImageMagick 7
- PostgreSQL

## Getting Started

- Checkout the letzell git tree from Github

          $ git clone https://github.com/annrapid/letzell-ts.git
          $ cd letzell-ts
          letzell-ts$

- Install dependencies :

          letzell-ts/backend$ mix deps.get

- Create and migrate your database :

          letzell-ts$ mix ecto.create && mix ecto.migrate

- Load sample records:

          letzell-ts$ mix run priv/repo/seeds.exs

- Start Phoenix endpoint

          letzell-ts$ mix phx.server

- Run npm to install javascript package in other terminal:

          letzell-ts$ cd client
          letzell-ts/frontend$ npm install

- Start client in development mode. You should be able to go to `http://localhost:3000` :

            letzell-phoenix-graphql/client$ npm start

## Testing

Integration tests with [Wallaby](https://github.com/keathley/wallaby) and ChromeDriver. Instructions:

1.  Install **[ChromeDriver](http://chromedriver.chromium.org)**
2.  Install **FakeS3** with `gem install fakes3`. Fake S3 simulate Amazon S3. It minimize runtime dependencies and be more of a development tool to test S3 calls.
3.  Run **FakeS3** in a new terminal window with `fakes3 -r $HOME/.s3bucket -p 4567`
4.  Build frontend with `API_HOST=localhost:4000 npm run build`
5.  Start frontend test server `npm run test.server`
6.  Run tests with `mix test`

## Production with Kubernetes

This example explains how to deploy the application on **[Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine)**.

### Preparing environment

1.  Create account on **[Google Cloud](https://cloud.google.com)** and create the project `letzell-phoenix-graphql`
2.  Install **[gcloud](https://cloud.google.com/sdk)**
3.  Initialize gcloud with `gcloud init`
4.  Install kubectl with gcloud : `gcloud components install kubectl`
5.  Install **jq** to parse json in command-line : https://stedolan.github.io/jq
6.  Install **only** the Helm client (helm) : https://docs.helm.sh/using_helm/#installing-helm
7.  Set execute permissions on scripts `chmod +x kubernetes/script/*`

### Preparing for the istio installation

1.  Move to kubernetes/istio/charts : `cd kubernetes/istio/charts`
2.  You can run the following command to download and extract the latest release automatically : `curl -L https://git.io/getLatestIstio | sh -`
3.  Move to istio-1.x.y, for example : `cd istio-1.0.2`
4.  Add the istioctl client to your PATH with : `printf "export PATH=%s:\$PATH\n" $PWD/bin >> ~/.bashrc && source ~/.bashrc` (or .zshrc, .bash_profile)
5.  Check istio version : `istioctl version`
6.  Back to root path of the project `cd <root-project>`

### Building and pushing docker images to Google Container Registry

1.  Install **[Docker](https://docs.docker.com/install)**
2.  Read **[Quickstart for Google Container Registry](https://cloud.google.com/container-registry/docs/quickstart)**
3.  Login to docker registry `gcloud auth configure-docker`
4.  Build frontend image : `docker build -t gcr.io/letzell-phoenix-graphql/frontend:latest -f dockerfiles/frontend.dockerfile .`
5.  Build api backend image : `docker build -t gcr.io/letzell-phoenix-graphql/api:latest -f dockerfiles/api.dockerfile .`
6.  Push images to registry : `docker push gcr.io/letzell-phoenix-graphql/frontend:latest && docker push gcr.io/letzell-phoenix-graphql/api:latest`

### Creating Kubernetes cluster

1.  Create account on **[Sendgrid](https://sendgrid.com)** to send emails
2.  Create account on **[AWS S3](https://aws.amazon.com/fr/s3)** to upload images
3.  Set environement variables :

```
export SENDGRID_API_KEY=<your-sendgrid-api-key>
export S3_KEY=<your-s3-key>
export S3_SECRET=<your-s3-secret>
export S3_BUCKET=<your-s3-bucket>
```

4.  Create cluster with `./kubernetes/script/create-cluster.sh`

### Upgrading letzell chart

You can edit or append to the existing customized values and templates, then apply the changes with :

```
helm upgrade letzell ./kubernetes/letzell
```

### Querying Metrics from Prometheus

1. Verify that the prometheus service is running in your cluster:

```
kubectl -n istio-system get svc prometheus
```

2. In Kubernetes environments, execute the following command:

```
$ kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=prometheus -o jsonpath='{.items[0].metadata.name}') 9090:9090 &
```

3. To open the Prometheus UI, visit http://localhost:9090/graph in your web browser.

### Visualizing Metrics with Grafana

1. Verify that the prometheus service is running in your cluster:

```
kubectl -n istio-system get svc prometheus
```

2. Verify that the Grafana service is running in your cluster:

```
kubectl -n istio-system get svc grafana
```

3. In Kubernetes environments, execute the following command:

```
$ kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3001:3000 &
```

4. To open the Grafana UI, visit http://localhost:3001 in your web browser. Username and password is `admin`. You can change the password.

<img alt="Resources dashboard" src="http://documents.matthieusegret.com/resources-dashboard.png" width="500">

### Clean up

To avoid incurring charges to your Google Cloud Platform account for the resources used, delete cluster with :

```
$ ./kubernetes/script/destroy-cluster.sh
```

# Override email_hash field so the error message can be displayed on the react frontend.
 def unique_constraint(changeset, [first_field | _] = fields, opts) do

    # Override email_hash field so the error message can be displayed on the react frontend.
    fields = Enum.map([:email_hash], fn x -> if x == :email_hash, do: :email, else: x end)
    first_field = if first_field == :email_hash, do: :email, else: first_field

    constraint = opts[:name] || unique_index_name(changeset, fields)
    message    = message(opts, "has already been taken")
    match_type = Keyword.get(opts, :match, :exact)
    add_constraint(changeset, :unique, to_string(constraint), match_type, first_field, message)
  end

 url.rewrite-once = (
 ".*\?(.*)$" => "/index.html?$1",
 "^/js/.*$" => "$0",
 "^.*\.(js|ico|gif|jpg|png|css|swf |jar|class)$" => "$0",
 "" => "/index.html"
 )

 query = Repo.all(from f in Listing, where: f.status == "open", order_by: fragment("RANDOM()"), limit: 2000)


## Next step

- [ ] Setup **[k8s_traffic_plug](https://github.com/Financial-Times/k8s_traffic_plug)** : Traffic endpoint and graceful shutdown for Elixir Plug apps
- [ ] Migrate from S3 to Google CDN
- [ ] Connect Erlang nodes between them on Kubernetes cluster with **[Libcluster](https://github.com/bitwalker/libcluster)**
- [ ] Migrate frontend from TypeScript to ReasonML
