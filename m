Return-Path: <glqinhongwei@gmail.com>
Return-Path: <glqinhongwei@gmail.com>
From: HongweiQin <glqinhongwei@gmail.com>
Subject: [PATCH v2 0/2] Fix thinktime handling and minimal rate calculation
Date: Sun, 17 Jan 2021 17:54:21 +0800
Message-Id: <cover.1610876646.git.glqinhongwei@gmail.com>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, HongweiQin <glqinhongwei@gmail.com>
List-ID: <fio@vger.kernel.org>

This patch series fix the thinktime handling procedure and take the thinktime
into consideration when checking the minimal rate.

HongweiQin (2):
  Fix thinktime_blocks
  Fix handle_thinktime

 backend.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

-- 
1.8.3.1


