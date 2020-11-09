Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/3] dynamic engines: fix several issues
References: <1604940390-21215-1-git-send-email-sandeen@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e732c24d-c7ac-a397-15cd-66226afe3bf5@kernel.dk>
Date: Mon, 9 Nov 2020 10:08:28 -0700
MIME-Version: 1.0
In-Reply-To: <1604940390-21215-1-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>, fio@vger.kernel.org
Cc: sitsofe@yahoo.com, ykorman@gmail.com, rjones@redhat.com
List-ID: <fio@vger.kernel.org>

On 11/9/20 9:46 AM, Eric Sandeen wrote:
> 1) Fix the build
> 2) Fix engine loading
> 3) Fix engine listing

Applied this, and a change for the default lookup path so that it at
least matches the default install path. On second thought, that should
probably just match prefix, but even that won't be correct. More work
needed there, but it's no more broken that before at least.

And a fix for the linking order, so that dynamic engines actually work
now.

-- 
Jens Axboe


