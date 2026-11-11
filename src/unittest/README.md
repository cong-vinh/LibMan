# unittest

`DaoIntegrationTest8` exercises every DAO against the MySQL seed in
`database/libman.sql`. Add MySQL Connector/J 8.x to `WebContent/WEB-INF/lib`
and run the class from Eclipse (or with the compiled classes on the classpath).

DAO connection settings can be supplied as system properties
`libman.jdbc.url`, `libman.jdbc.user`, `libman.jdbc.password`, or environment
variables `LIBMAN_DB_URL`, `LIBMAN_DB_USER`, `LIBMAN_DB_PASSWORD`.
