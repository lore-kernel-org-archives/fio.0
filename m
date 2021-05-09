Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] don't access dlclose'd dynamic ioengine object after
 close
References: <14499187-1da8-ff0c-6b60-8fa6dd33d9fa@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <4e05c5f8-d057-e368-d490-f2bdf74ed65e@kernel.dk>
Date: Sat, 8 May 2021 22:13:30 -0600
MIME-Version: 1.0
In-Reply-To: <14499187-1da8-ff0c-6b60-8fa6dd33d9fa@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <esandeen@redhat.com>, fio <fio@vger.kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
List-ID: <fio@vger.kernel.org>

On 5/7/21 3:13 PM, Eric Sandeen wrote:
> Alexey reported this bug when using dynamically loaded IO engines;
> a segfault on the line where we set the dlhandle to NULL after
> the dlclose.
> 
> I think this is because ops points to the thing we obtained from dlsym:
> 
> 	ops = dlsym(dlhandle, engine_lib);
> 
> and after the final dlclose, the object no longer exists and efforts
> to set the handle within it will fail for obvious reasons.
> I'm not sure why I hadn't seen this before.

Applied, thanks.

-- 
Jens Axboe


