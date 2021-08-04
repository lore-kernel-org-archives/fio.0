Return-Path: <ankit.kumar@samsung.com>
From: Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/2] v3: ZBD fix with random zone index logic and missing
 documentation
Date: Wed,  4 Aug 2021 16:53:06 +0530
Message-Id: <20210804112308.28062-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
References: <CGME20210804112704epcas5p2e74d90bf989d4305d5213971e0a30b63@epcas5p2.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, krish.reddy@samsung.com, prakash.v@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

v2 -> v2

 - Added missing signoff tags with the patches

Ankit Kumar (2):
  HOWTO: Add missing documentation for job_max_open_zones
  zbd: Improve random zone index generation logic

 HOWTO | 5 +++++
 zbd.c | 5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
2.30.0-rc0


