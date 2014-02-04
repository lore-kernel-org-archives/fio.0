Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 0/2] init: option parsing fixes
Date: Tue,  4 Feb 2014 14:27:09 +0100
Message-Id: <1391520431-21732-1-git-send-email-stefanha@redhat.com>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Patch 1 changes --minimal from optional_argument to no_argument.  There seems
to be no reason why optional_argument was used (the option doesn't use optarg).

Patch 2 fixes a segfault when --output-format is used without an argument.

Stefan Hajnoczi (2):
  init: --minimal does not take an optional argument
  init: log error on missing --output-format argument

 init.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
1.8.5.3


