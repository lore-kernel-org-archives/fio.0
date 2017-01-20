Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50672 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750893AbdATNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 20 Jan 2017 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cUYnT-0002T3-Bl
        for fio@vger.kernel.org; Fri, 20 Jan 2017 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170120130002.9CE522C02A1@kernel.dk>
Date: Fri, 20 Jan 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 54441e7b5f44d3786ee12b3fede90c4bb2c2c260:

  init: fix double free of pid_file (2017-01-18 08:18:28 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f70afaca743f2971312d9928f069a9ea7daeccf7:

  Merge branch 'sphinx-doc' of https://github.com/termim/fio (2017-01-19 22:01:48 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      Merge branch 'sphinx-doc' of https://github.com/termim/fio into sphinx
      Merge branch 'sphinx-doc' of https://github.com/termim/fio
      Merge branch 'sphinx-doc' of https://github.com/termim/fio

Mikhail Terekhov (6):
      run sphinx-quickstart
      Convert documentation to reStructured text.
      add .rst suffix to README and HOWTO
      Revert README and HOWTO files renaming.
      ignore documentation output directory
      remove documentation output in clean

Tomohiro Kusumi (5):
      Rename FIO_TYPE_BD to FIO_TYPE_BLOCK
      Fix typo for "job" in plural
      Refactor fio_show_ioengine_help()
      Move options_mem_dupe() to parse.c
      Change td_var() to take void* for the first arg

 .gitignore           |    1 +
 HOWTO                | 5484 +++++++++++++++++++++++++++++---------------------
 Makefile             |    1 +
 README               |  443 ++--
 backend.c            |    2 +-
 doc/Makefile         |  225 +++
 doc/conf.py          |  360 ++++
 doc/fio_doc.rst      |   51 +
 doc/fio_examples.rst |   62 +
 doc/fio_man.rst      |   11 +
 doc/index.rst        |   25 +
 doc/make.bat         |  281 +++
 engines/binject.c    |    2 +-
 engines/mmap.c       |    2 +-
 engines/sg.c         |    8 +-
 file.h               |    2 +-
 filesetup.c          |   10 +-
 fio.h                |    1 -
 init.c               |    4 +-
 ioengines.c          |   20 +-
 options.c            |   19 +-
 parse.c              |   17 +
 parse.h              |    4 +-
 23 files changed, 4393 insertions(+), 2642 deletions(-)
 create mode 100644 doc/Makefile
 create mode 100644 doc/conf.py
 create mode 100644 doc/fio_doc.rst
 create mode 100644 doc/fio_examples.rst
 create mode 100644 doc/fio_man.rst
 create mode 100644 doc/index.rst
 create mode 100644 doc/make.bat

---

Diff of recent changes:

Too large to post

