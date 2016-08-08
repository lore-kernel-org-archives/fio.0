Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/6] Use char* for pid_file path
References: <1470677251-8292-1-git-send-email-kusumi.tomohiro@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <50027455-fac6-efb9-ffc6-8ceebc5469a9@kernel.dk>
Date: Mon, 8 Aug 2016 11:33:53 -0600
MIME-Version: 1.0
In-Reply-To: <1470677251-8292-1-git-send-email-kusumi.tomohiro@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/08/2016 11:27 AM, Tomohiro Kusumi wrote:
> since no function expects this to be void*.
>
> Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>

Thanks, applied this and the 5 others, all look good.

-- 
Jens Axboe


