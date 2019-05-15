Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 0/5] terse client/server output
Date: Wed, 15 May 2019 16:04:58 -0400
Message-Id: <20190515200503.23000-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Jens, please consider these patches.

I have a user trying to use a single script to consume terse output from
stand-alone fio runs and client/server fio runs. The patches address
some issues with client/server terse output that we found.

Vincent

Vincent Fu (5):
  client: do not print disk utilization for terse v2
  client: handle disk util for all output formats
  client: add a newline after terse disk util
  docs: improve terse output format documentation
  stat: remove terse v2 blank lines with description not set

 HOWTO    | 12 +++++++++++-
 client.c |  9 ++++++---
 fio.1    | 11 ++++++++++-
 stat.c   |  7 ++++---
 4 files changed, 31 insertions(+), 8 deletions(-)

-- 
2.17.1


