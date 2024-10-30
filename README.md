# Smokescreen

Use [smokescreen](https://github.com/stripe/smokescreen) as a proxy for your
outgoing connections.

This can be combined with
[egress IPs](https://fly.io/docs/flyctl/machine-egress-ip/#main-content-start)
to use a consistent set of IPs for your app.

## Deploying on Fly

The quickest way to deploy this is to import the supplied `fly.source.toml`.

```sh
fly init smokescreen-example --source fly.source.toml
fly launch --no-public-ips --flycast
```

Now you can scale the proxy to multiple regions and machines using
[fly scale count](https://fly.io/docs/flyctl/scale-count/#main-content-start).

For example, to run four instances of the proxy in the `iad` and the `ord`
region, you can run:

```sh
fly scale -r iad,ord count 4
```

And then allocate egress IPs for the machines using the
[fly machine egress-ip allocate](https://fly.io/docs/flyctl/machine-egress-ip-allocate/#main-content-start)
command.

```sh
fly machine egress-ip allocate <your machine ID>
```

Now you can connect to it using anything that supports HTTP proxying using
[flycast](https://fly.io/docs/networking/flycast/). For example, to connect to
the proxy using curl from inside a fly machine, you can run

```sh
$ curl --proxy <name-of-the-smokescreen-app>.flycast:80 https://fly.io
```

By default, machines will use the closest instance of the proxy to them. The
proxy will scale to zero when not in use.
