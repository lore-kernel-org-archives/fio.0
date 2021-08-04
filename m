Return-Path: <ankit.kumar@samsung.com>
From: Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/2] v2: ZBD fix with random zone index logic and missing
 documentation
Date: Wed,  4 Aug 2021 14:54:48 +0530
Message-Id: <20210804092450.28782-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
References: <CGME20210804092848epcas5p43713e1728116d2ea38c910a2b8991c42@epcas5p4.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, krish.reddy@samsung.com, prakash.v@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

v1 -> v2

 - Addressed the commit message review comments for both the patches

Ankit Kumar (2):
  HOWTO: Add missing documentation for job_max_open_zones
  zbd: Improve random zone index generation logic

 HOWTO | 5 +++++
 zbd.c | 5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
2.30.0-rc0


