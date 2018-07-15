# dotfiles

## How to install PHP 7 and PHPStan

Install PHP 7 to use PHPStan. However, linuxbrew and phpenv have errors, so build.

### Installation

```bash
$ ghq get https://github.com/php/php-src.git
$ git checkout -b php-7.2.7 refs/tags/php-7.2.7
$ ./buildconf --force
$ ./configure --prefix="$HOME/dev/php7" --with-openssl=`brew --prefix openssl`
$ make
$ make install

$ export PATH="$HOME/dev/php7/bin:$HOME"
$ composer require --dev phpstan/phpstan
```

### Configure errors when installing with linuxbrew and phpenv

- linuxbrew
  - configure: error: Cannot find sys/sdt.h which is required for DTrace support
- phpenv
  - configure: WARNING: This bison version is not supported for regeneration of the Zend/PHP parsers (found: none, min: 204, excluded: ).
    - `brew install bison`
  - configure: WARNING: unrecognized options: --with-mcrypt
    - append `configure_option -D "--with-mcrypt"` to ~/.phpenv/plugins/php-build/share/php-build/definitions/7.2.7
  - configure: error: ZLIB extension requires gzgets in zlib
    - append `configure_option "--with-openssl=/home/linuxbrew/.linuxbrew/opt/openssl"`
  - configure: error: Cannot find OpenSSL's libraries
    - append `configure_option "--with-libdir=lib"`
  - configure: error: libcrypto not found!
    - `brew install krb5`
  - configure: error: Problem with libpng.(a|so) or libz.(a|so).
    - `brew install libpng`
  - configure: error: Unable to detect ICU prefix or no failed. Please verify ICU install prefix and make sure icu-config works.
    - `brew install icu4c`
  - configure: WARNING: Use of bundled libzip is deprecated and will be removed. Some features such as encryption and bzip2 are not available. Use system library and --with-libzip is recommended.
    - append `configure_option "--with-libzip"`
  - configure: error: Please reinstall the libzip distribution
    - `brew install libzip`
  - configure: error: could not find usable libzip
    - Unknown
  - configure: error: off_t undefined; check your library configuration
    - Unknown
