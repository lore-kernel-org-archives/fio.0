Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Fix build error (compile-time assertion added by
 96344ff0)
References: <1521567258-1008-1-git-send-email-kusumi.tomohiro@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <57cc09d6-f644-20d2-f185-a07076f657a2@kernel.dk>
Date: Tue, 20 Mar 2018 11:18:58 -0600
MIME-Version: 1.0
In-Reply-To: <1521567258-1008-1-git-send-email-kusumi.tomohiro@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 3/20/18 11:34 AM, Tomohiro Kusumi wrote:
>> optgroup.c:208: error: expected identifier or '(' before 'do'
>> optgroup.c:208: error: expected identifier or '(' before 'while'
> 
> compiletime_assert() (do{...}while(0)) can't be in global scope.
> Not sure where you would want this instead, but main() has one already.

I'll move it into optgroup instead, it's clearer if it's closer to
the actual code.

-- 
Jens Axboe


