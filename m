Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20191210175442.2975-1-vincentfu@gmail.com>
In-Reply-To: <20191210175442.2975-1-vincentfu@gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 10 Dec 2019 21:32:51 +0000
Message-ID: <CALjAwxi-nfeunNEOuhbjF8L-0LhmmHZ=exRBAJ0V+EQi0ep37Q@mail.gmail.com>
Subject: Re: [PATCH 0/9] testing patches
Content-Type: text/plain; charset="UTF-8"
To: Vincent Fu <vincentfu@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>, Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On Tue, 10 Dec 2019 at 17:56, <vincentfu@gmail.com> wrote:
>
> From: Vincent Fu <vincent.fu@wdc.com>
>
> Jens, please consider this series of patches related to testing.
>
> The patches improve t/run-fio-tests.py in various ways, most prominently
> adding support for Windows and macOS.
>
> Also included are travis and appveyor patches that add run-fio-tests.py
> as a step.  Currently both the travis and appveyor build processes
> complete in less than four minutes.  Adding run-fio-tests.py increases
> this to about 20 minutes for travis and 14 minutes for appveyor.

In general I think this work is fantastic and much needed (you can
search through the fio commit logs using "git log --grep 'size='" to
find jobs files that have caused issues in the past and may be worth
turning into tests at some point). However, I think making the builds
so slow may be a disadvantage rather than a benefit. I agree with
nearly all the patch set bar running this by default with
travis/appveyor...

-- 
Sitsofe | http://sucs.org/~sits/

