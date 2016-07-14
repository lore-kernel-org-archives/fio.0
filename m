Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] Add os_trim() support for DragonFlyBSD
References: <1468499263-6328-1-git-send-email-kusumi.tomohiro@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5787B05A.5010006@kernel.dk>
Date: Thu, 14 Jul 2016 08:31:38 -0700
MIME-Version: 1.0
In-Reply-To: <1468499263-6328-1-git-send-email-kusumi.tomohiro@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 07/14/2016 05:27 AM, Tomohiro Kusumi wrote:
> It has the same interface as Linux kernel with a different ioctl name.

Thanks, applied this and 2/2.

-- 
Jens Axboe


