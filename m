Return-Path: <msmucr@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130405084056.GM9683@kernel.dk>
References: <515DAA33.4000009@warnerbros.com> <20130404181946.GD9683@kernel.dk>
 <20130404184104.GE9683@kernel.dk> <CAHBo9gmJHgZAjQ=rjeNpzrV7boLS6+2VcxtZRnkad7y_hwp=Dw@mail.gmail.com>
 <20130405084056.GM9683@kernel.dk>
From: =?UTF-8?Q?Michal_=C5=A0mucr?= <msmucr@gmail.com>
Date: Fri, 5 Apr 2013 21:24:27 +0200
Message-ID: <CAHBo9gn-vMzsKGtZYOHB979_EJ9PbnF3=eK9MPOrnsciNDJtrg@mail.gmail.com>
Subject: Re: How to re-use default sequential filenames?
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Alan Hagge <Alan.Hagge@warnerbros.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

2013/4/5 Jens Axboe <axboe@kernel.dk>:
> It would not be a problem making the block size decision probed or
> dynamic. But it's not clear to me from the above what you would base it
> on. The file size? Or st_blksize?

I'm sorry Jens, i wasn't much clear regarding this. I meant file size - st_size.

Michal

