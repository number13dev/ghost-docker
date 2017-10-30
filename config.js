// # Ghost Configuration
// Setup your Ghost install for various [environments](http://support.ghost.org/config/#about-environments).

// Ghost runs in `development` mode by default. Full documentation can be found at http://support.ghost.org/config/

var path = require('path'),
    config;

config = {
    // ### Production
    // When running Ghost in the wild, use the production environment.
    // Configure your URL and mail settings here
    production: {
        url: '{{BLOG_DOMAIN}}',
        mail: {
            from: '{{MAIL_LOGIN}}',
            transport: 'SMTP',
            options: {
                host: '{{MAIL_SERVER}}',
                secureConnection: false,
                port: 587,
                auth: {
                    user: '{{MAIL_LOGIN}}',
                    pass: '{{MAIL_PASSWORD}}'
                }
            }
        },
        maintenance: {
            enabled: false
        },
        database: {
          client: 'mysql',
          connection: {
            host     : '{{DB_HOST}}',
            user     : '{{DB_USR}}',
            password : '{{DB_PW}}',
            database : '{{DB_NAME}}',
            charset  : 'utf8'
          }
        },
        server: {
            host: '127.0.0.1',
            port: '2368'
        }
    },

    development: {
        url: 'http://localhost',
        mail: {
            from: '{{MAIL_LOGIN}}',
            transport: 'SMTP',
            options: {
                host: '{{MAIL_SERVER}}',
                secureConnection: false,
                port: 587,
                auth: {
                    user: '{{MAIL_LOGIN}}',
                    pass: '{{MAIL_PASSWORD}}'
                }
            }
        },
        database: {
            client: 'sqlite3',
            connection: {
                filename: path.join(__dirname, '/content/data/ghost-dev.db')
            },
            debug: false
        },
        server: {
            host: '0.0.0.0',
            port: '2368'
        },
        paths: {
            contentPath: path.join(__dirname, '/content/')
        }
    }
};

module.exports = config;