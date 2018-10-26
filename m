Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 0/7] unittests: add CUnit based unittests
Date: Fri, 26 Oct 2018 09:35:39 -0700
Message-Id: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

This series of patches introduce CUnit based unittests,
plus fix bugs found in the test cases.

CUnit is C version of *unit framework to help write test cases.
https://sourceforge.net/projects/cunit/

Having builtin unittest functionality for newly added code
as well as exsiting code if possible helps prevent regression.

Most of the code under lib/ and oslib/ (and os/) work as stand
alone *.o files or inline functions with no dependencies on fio
itself, so these are relatively easy to write unittests.

Summary of patches
1/7: Add basic CUnit framework
2/7: Add unittest suite for lib/memalign.c as an example
3/7: Add unittest suite for lib/strntol.c as an example
4/7: Add unittest suite for oslib/strlcat.c as an example
5/7: Add unittest suite for oslib/strndup.c as an example
6/7: Fix lib/strntol.c which caused test failure in patch 3/7
7/7: Fix oslib/strlcat.c which caused test failure in patch 4/7

Tomohiro Kusumi (7):
  unittests: add CUnit based unittest framework
  unittests: add unittest suite for lib/memalign.c
  unittests: add unittest suite for lib/strntol.c
  unittests: add unittest suite for oslib/strlcat.c
  unittests: add unittest suite for oslib/strndup.c
  lib: fix strntol's end pointer when str has leading spaces
  oslib: fix strlcat's incorrect copying

 .gitignore                |    1 +
 Makefile                  |   26 +++++++++++++++-
 configure                 |   26 ++++++++++++++++
 lib/strntol.c             |    2 +-
 oslib/strlcat.c           |   69 +++++++++++++++++++++++++++++++------------
 oslib/strlcat.h           |    2 +-
 unittests/lib/memalign.c  |   27 +++++++++++++++++
 unittests/lib/strntol.c   |   59 +++++++++++++++++++++++++++++++++++++
 unittests/oslib/strlcat.c |   52 +++++++++++++++++++++++++++++++++
 unittests/oslib/strndup.c |   63 +++++++++++++++++++++++++++++++++++++++
 unittests/unittest.c      |   71 +++++++++++++++++++++++++++++++++++++++++++++
 unittests/unittest.h      |   26 ++++++++++++++++
 12 files changed, 400 insertions(+), 24 deletions(-)
 create mode 100644 unittests/lib/memalign.c
 create mode 100644 unittests/lib/strntol.c
 create mode 100644 unittests/oslib/strlcat.c
 create mode 100644 unittests/oslib/strndup.c
 create mode 100644 unittests/unittest.c
 create mode 100644 unittests/unittest.h


