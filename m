Return-Path: <ankit.kumar@samsung.com>
From: Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/2] ZBD fix with random zone index logic and missing
 documentation.
Date: Tue,  3 Aug 2021 15:58:34 +0530
Message-Id: <1627986516-4814-1-git-send-email-ankit.kumar@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20210803111208epcas5p2fec4fec945de52fb57986f2ef5e2bcfe@epcas5p2.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, krish.reddy@samsung.com, prakash.v@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

ZBD fix with random zone index logic and missing documentation. 

Ankit Kumar (2):
  Add missing documentation for job_max_open_zones.
  zbd: Improve random zone index generation logic.

 HOWTO | 5 +++++
 zbd.c | 5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
1.8.3.1


