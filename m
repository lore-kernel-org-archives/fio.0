Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <e85db28f-da18-e6cc-7eda-1b04d2cc95eb@kernel.dk>
References: <e044afaa-22ad-c7e2-d041-e2658f49bac8@bluestop.org>
 <CALjAwxjoTtRp1jVhfKMTcbn6wnmEmmCsjkpO7CkBgF5zj4B3Bg@mail.gmail.com>
 <9cf7d62a-5c4a-737a-d119-13763fb42c72@bluestop.org> <CALjAwxhxpLuLeysnp5kC-kQoWH++4hvehCWJxc9yA_Fcsy=pmw@mail.gmail.com>
 <BAE7B5AF-63F9-4E95-940D-7C84CE5AD92E@nutanix.com> <36259BEC-1CF0-45A5-85AE-F557989EDF30@nutanix.com>
 <2B8D69D8-05F3-4500-8A4E-F5DE21356676@nutanix.com> <CALjAwxiTX1=7pJKQ1Lz7nDkMXZqVJkMkNZDOA_XJYsEGP7wSfw@mail.gmail.com>
 <971ECD81-B100-4EEE-98CE-0E578A59BB02@nutanix.com> <7B5FFC71-BE67-435F-8DE6-8376E52754EB@nutanix.com>
 <CALjAwxgF-2dK+Bc9iwkVsxA4sfWKYSmHe8k3YbpUyDmBWP34ow@mail.gmail.com>
 <CALjAwxirkjduZof+F3prrKX0wp9YS8apS-YdK8+ru1supg1dnA@mail.gmail.com>
 <CALjAwxjPGXSOGwLOSMfVdrmxXsr8ObT6W6E1UBs2LkjttSnduw@mail.gmail.com> <e85db28f-da18-e6cc-7eda-1b04d2cc95eb@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 9 Mar 2018 14:40:54 +0000
Message-ID: <CALjAwxg1SzQV9ss9jjqry8_MLgDfPYq9QdbA5eVZi-PkmSEAKA@mail.gmail.com>
Subject: Re: Windows: FIO randomly hangs using attached script
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: Rob Scheepens <rob.scheepens@nutanix.com>, David Knierim <knierim@nutanix.com>, Rebecca Cran <rebecca@bluestop.org>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 8 March 2018 at 16:18, Jens Axboe <axboe@kernel.dk> wrote:
> Does the below patch make a difference?
>
>
> diff --git a/mutex.c b/mutex.c
> index 63229eda09d6..acc88dc33b98 100644
> --- a/mutex.c
> +++ b/mutex.c
> @@ -240,10 +240,11 @@ void fio_mutex_up(struct fio_mutex *mutex)
>         if (!mutex->value && mutex->waiters)
>                 do_wake = 1;
>         mutex->value++;
> -       pthread_mutex_unlock(&mutex->lock);
>
>         if (do_wake)
>                 pthread_cond_signal(&mutex->cond);
> +
> +       pthread_mutex_unlock(&mutex->lock);
>  }
>
>  void fio_rwlock_write(struct fio_rwlock *lock)

It pains me to say this (because POSIX says such rejigging just
changes the scheduling order) but yes your patch makes a difference.
The following job would trigger the deadlock problem within 10 minutes
for me:

[global]
thread
ioengine=windowsaio
direct=1
iodepth=1
readwrite=read
time_based=1
filesize=1M
runtime=4
time_based
numjobs=500
group_reporting
[job1]
filename=file1:file2:file3:file4:file5:file6:file7:file8:file9:file10:file11:file12:file13:file14:file15

for i in {1..150}; do echo "Loop $i; $(date)"; ./fio --minimal
hang.fio; if [[ $? -ne 0 ]]; then echo "failure"; break; fi; done

The backtrace is always a before - most threads are waiting trying to
lock the mutex, a few are still doing IO completion port work in
windowsaio but just keep timing out and don't get events, a couple are
waiting in pthread_cond_wait() and the thread that is trying to send
pthread_cond_signal() is deadlocked. Not using direct=1 seems to make
the problem go away for some reason and having less threads also makes
the problem harder to hit.

With your patch the above seemed to be able to go to 150 loops without
issue but I haven't tested in anger.

-- 
Sitsofe | http://sucs.org/~sits/

