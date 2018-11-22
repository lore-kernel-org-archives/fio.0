Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 0/2] Fix gcc 8.1 warnings
Date: Thu, 22 Nov 2018 08:48:24 -0800
Message-Id: <1542905306-12193-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Fix gcc 8.1 warnings on strncpy()'s length argument.

Tomohiro Kusumi (2):
  exp: Fix -Wstringop-overflow= warning on gcc 8.1
  init: Fix -Wstringop-truncation warning on gcc 8.1

 exp/expression-parser.y |    2 +-
 init.c                  |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)


