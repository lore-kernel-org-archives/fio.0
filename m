Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 0/2] two patches
Date: Wed, 11 Sep 2019 10:56:38 -0400
Message-Id: <20190911145640.30005-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Jens, please consider these two patches.

The first is a simple documentation fix, whereas the second has
filesetup.c:setup_files() honor the offset option in one additional
case.

Vincent Fu (2):
  doc: clarify what --alloc-size does
  filesetup: honor the offset option

 HOWTO       | 4 ++--
 filesetup.c | 2 +-
 fio.1       | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.17.1


