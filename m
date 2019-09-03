Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 0/2] smalloc fixes
Date: Tue,  3 Sep 2019 13:44:43 -0400
Message-Id: <20190903174445.1212-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Jens, please consider these patches that are a follow up to the smalloc
patch from last week.

I broke up last week's patch into two: one that implements your
suggested fix for the synchronization issue and a second that fixes the
SMALLOC_BPB/SMALLOC_BPI issue.

Vincent


Vincent Fu (2):
  smalloc: allocate struct pool array from shared memory
  smalloc: use SMALLOC_BPI instead of SMALLOC_BPB in add_pool()

 smalloc.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

-- 
2.17.1


