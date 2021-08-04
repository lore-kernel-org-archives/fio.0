Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] v2: ZBD fix with random zone index logic and missing
 documentation
References: <CGME20210804092848epcas5p43713e1728116d2ea38c910a2b8991c42@epcas5p4.samsung.com>
 <20210804092450.28782-1-ankit.kumar@samsung.com>
 <20210804110731.7yqxy6k7dr6evrrg@shindev>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5d93c040-c57c-502c-4262-8526d4d2867e@kernel.dk>
Date: Wed, 4 Aug 2021 07:25:01 -0600
MIME-Version: 1.0
In-Reply-To: <20210804110731.7yqxy6k7dr6evrrg@shindev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Ankit Kumar <ankit.kumar@samsung.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "krish.reddy@samsung.com" <krish.reddy@samsung.com>, "prakash.v@samsung.com" <prakash.v@samsung.com>
List-ID: <fio@vger.kernel.org>

On 8/4/21 5:07 AM, Shinichiro Kawasaki wrote:
> On Aug 04, 2021 / 14:54, Ankit Kumar wrote:
>> v1 -> v2
>>
>>  - Addressed the commit message review comments for both the patches
>>
>> Ankit Kumar (2):
>>   HOWTO: Add missing documentation for job_max_open_zones
>>   zbd: Improve random zone index generation logic
> 
> Ankit, when I commented the v1 patches, I overlooked that your commit messages
> do not include your Signed-off-by tags. Many of the fio commits have the tags.
> To clarify who contributed, I suggest to add it to the two patches.

Indeed, please always add those.

-- 
Jens Axboe


