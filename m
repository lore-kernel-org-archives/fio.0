Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] v3: ZBD fix with random zone index logic and missing
 documentation
References: <CGME20210804112704epcas5p2e74d90bf989d4305d5213971e0a30b63@epcas5p2.samsung.com>
 <20210804112308.28062-1-ankit.kumar@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <395d79ae-e07d-641a-dd80-588c84efc193@kernel.dk>
Date: Wed, 4 Aug 2021 07:26:16 -0600
MIME-Version: 1.0
In-Reply-To: <20210804112308.28062-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Ankit Kumar <ankit.kumar@samsung.com>
Cc: fio@vger.kernel.org, krish.reddy@samsung.com, prakash.v@samsung.com
List-ID: <fio@vger.kernel.org>

On 8/4/21 5:23 AM, Ankit Kumar wrote:
> v2 -> v2
> 
>  - Added missing signoff tags with the patches
> 
> Ankit Kumar (2):
>   HOWTO: Add missing documentation for job_max_open_zones
>   zbd: Improve random zone index generation logic
> 
>  HOWTO | 5 +++++
>  zbd.c | 5 +++--
>  2 files changed, 8 insertions(+), 2 deletions(-)

Applied, thanks.

-- 
Jens Axboe


