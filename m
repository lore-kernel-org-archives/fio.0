Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] Fix compilation error on BSD
References: <20200528125642.103863-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <bab7fabe-e1ac-fae0-b240-046c60ff243c@kernel.dk>
Date: Thu, 28 May 2020 10:36:17 -0600
MIME-Version: 1.0
In-Reply-To: <20200528125642.103863-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 5/28/20 6:56 AM, Shin'ichiro Kawasaki wrote:
> It was reported that the commit b76949618d55 ("fio: Generalize zonemode=zbd")
> triggered a compilation failure of zbd.c on NetBSD which does not have
> pthread_mutexattr_setpshared(). This patch series addresses the failure. To
> avoid pthread_mutexattr_setpshared() calls, utilize helper functions pshared.c
> provides.
> 
> The first patch adds another helper function in pshared.c to initialize mutex
> with attribute types desired. The second patch replace mutex initialization in
> zbd.c with the helper functions. To initialize mutex with POSIX_MUTEX_RECURSIVE
> attribute type, utilize the newly introduced function.
> 
> I do not have NetBSD (or other BSD) system then this series is not confirmed
> build pass on NetBSD. Confirmation by BSD users will be appreciated.

I've applied this for now, assuming the BSD interested parties will vet
them soon.

-- 
Jens Axboe


