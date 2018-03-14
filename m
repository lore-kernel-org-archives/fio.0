Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 14 Mar 2018 16:05:59 +0000
Message-ID: <CALjAwxjgJW4+LV3X_hOm2+ELKiS7RfJUg1HLCN_bnfXUYyuVsQ@mail.gmail.com>
Subject: Unneeded read_barrier() in fio_mutex_up?
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

I've just been going to fio code to see if I can add a wrapper to
variables being protected by read_barrier() and write_barrier() and I
came across this:

mutex.c:
242 void fio_mutex_up(struct fio_mutex *mutex)
243 {
244         int do_wake = 0;
245
246         assert(mutex->magic == FIO_MUTEX_MAGIC);
247
248         pthread_mutex_lock(&mutex->lock);
249         read_barrier();
250         if (!mutex->value && mutex->waiters)
251                 do_wake = 1;
252         mutex->value++;

What is this read_barrier() protecting? From what I can the only time
we manipulate mutex->value and mutex->waiters without being under
mutex->lock is __fio_mutex_init()...

-- 
Sitsofe | http://sucs.org/~sits/

