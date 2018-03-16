Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <406902be-f4ce-c4f4-4e16-ee9caf8c0bcf@kernel.dk>
References: <e044afaa-22ad-c7e2-d041-e2658f49bac8@bluestop.org>
 <CALjAwxjoTtRp1jVhfKMTcbn6wnmEmmCsjkpO7CkBgF5zj4B3Bg@mail.gmail.com>
 <9cf7d62a-5c4a-737a-d119-13763fb42c72@bluestop.org> <CALjAwxhxpLuLeysnp5kC-kQoWH++4hvehCWJxc9yA_Fcsy=pmw@mail.gmail.com>
 <BAE7B5AF-63F9-4E95-940D-7C84CE5AD92E@nutanix.com> <36259BEC-1CF0-45A5-85AE-F557989EDF30@nutanix.com>
 <2B8D69D8-05F3-4500-8A4E-F5DE21356676@nutanix.com> <CALjAwxiTX1=7pJKQ1Lz7nDkMXZqVJkMkNZDOA_XJYsEGP7wSfw@mail.gmail.com>
 <971ECD81-B100-4EEE-98CE-0E578A59BB02@nutanix.com> <7B5FFC71-BE67-435F-8DE6-8376E52754EB@nutanix.com>
 <CALjAwxgF-2dK+Bc9iwkVsxA4sfWKYSmHe8k3YbpUyDmBWP34ow@mail.gmail.com>
 <CALjAwxirkjduZof+F3prrKX0wp9YS8apS-YdK8+ru1supg1dnA@mail.gmail.com>
 <CALjAwxjPGXSOGwLOSMfVdrmxXsr8ObT6W6E1UBs2LkjttSnduw@mail.gmail.com>
 <e85db28f-da18-e6cc-7eda-1b04d2cc95eb@kernel.dk> <CALjAwxg1SzQV9ss9jjqry8_MLgDfPYq9QdbA5eVZi-PkmSEAKA@mail.gmail.com>
 <406902be-f4ce-c4f4-4e16-ee9caf8c0bcf@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 16 Mar 2018 08:13:50 +0000
Message-ID: <CALjAwxgr10F9X0n=7Scugz1yO48XPW5ANYGoD4JAss6Y3Egbcw@mail.gmail.com>
Subject: Re: Windows: FIO randomly hangs using attached script
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: Rob Scheepens <rob.scheepens@nutanix.com>, David Knierim <knierim@nutanix.com>, Rebecca Cran <rebecca@bluestop.org>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 9 March 2018 at 14:55, Jens Axboe <axboe@kernel.dk> wrote:
>
> In some implementations it's actually mandated to have the wakeup
> within the lock, which seems to be the case here. It's a shame,
> since it's clearly suboptimal (from a scalability point of view)
> to have to hold the lock while issuing a wakeup for a process
> that's going to grab the same lock.
>
> I'll commit the patch. Thanks a lot for all your hard work on this
> one, let's hope that was it...

FWIW this has been accepted as a bug in the mingw-w64 project's
winpthreads library. The standalone program on
https://gist.github.com/sitsofe/abd99efec507b18234e7cc042d1baff1
reliably triggers the deadlock for me when using a mingw build on both
real Windows and under Wine but not when built for Linux with glibc.
See https://sourceforge.net/p/mingw-w64/bugs/710/ for the "Deadlock in
winpthreads' pthread_cond_signal()" bug.

Rob, David, Rebecca: do you know if the current git fio cures the
deadlock you were seeing?

-- 
Sitsofe | http://sucs.org/~sits/

