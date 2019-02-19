Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 0/2] stat/options patches
Date: Tue, 19 Feb 2019 16:44:06 -0500
Message-Id: <20190219214408.14207-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Jens, please consider these two patches that address a couple issues
that we have encountered. Thanks.

Vincent

Vincent Fu (2):
  stat: use long doubles to identify latency percentiles
  options: catch division by zero in setting CPU affinity

 options.c | 3 +++
 stat.c    | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

-- 
2.17.1


