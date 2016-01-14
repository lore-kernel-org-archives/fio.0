Return-Path: <j.rosenboom@x-ion.de>
MIME-Version: 1.0
In-Reply-To: <56967D27.1070803@kernel.dk>
References: <CADr68WZJ0+r4M5WArqvRkHHTAj=uLg8bi8xmGr+mMJ=KamQ+UQ@mail.gmail.com>
	<CADr68Wam45zdOL_d_4PPAZ-O8nfuoVxHDHnPUkCYqSd720FwYA@mail.gmail.com>
	<CADr68WaLSogc_a9PptZ0Q7MeG3Dhnp4QDAfbFzAOeykQNzj37A@mail.gmail.com>
	<56967D27.1070803@kernel.dk>
Date: Thu, 14 Jan 2016 09:54:49 +0100
Message-ID: <CADr68WYaW+b+V1eUeHY3sFZH5VoZ1Q399HyzQUKQk6gVcPQ+=Q@mail.gmail.com>
Subject: Re: engine rbd broken after commit 2466096336bd0fbc1a94811aa338926af6baf42f
From: Jens Rosenboom <j.rosenboom@x-ion.de>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

2016-01-13 17:36 GMT+01:00 Jens Axboe <axboe@kernel.dk>:
...
> Thanks for reporting this! I merged a cleaner fix, we can just set up the
> key earlier and not have to worry about server vs non-server. Can you check
> if current -git works for you?

Yep, working fine, thx.

