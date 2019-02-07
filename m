Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 0/2] stat cleanup/bugfix patches
Date: Thu,  7 Feb 2019 10:51:05 -0500
Message-Id: <20190207155107.7148-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Jens, please consider these two cleanup/bugfix patches for stat.c

Vincent

Vincent Fu (2):
  stat: clean up calc_clat_percentiles
  stat: put 'percentiles' object in appropriate 'clat_ns' or 'lat_ns'
    parent

 stat.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

-- 
2.17.1


