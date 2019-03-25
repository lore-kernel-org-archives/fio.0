Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 0/2] client and stat patches
Date: Mon, 25 Mar 2019 10:20:26 -0400
Message-Id: <20190325142028.32550-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Jens, please consider these two patches that address an output issue
when fio runs jobs on servers and a style issue with the patch from last
week.

Vincent

Vincent Fu (2):
  client: put All clients section at end of normal output
  stat: eliminate unneeded curly braces

 client.c |  6 +++++-
 stat.c   | 11 +++++------
 2 files changed, 10 insertions(+), 7 deletions(-)

-- 
2.17.1


