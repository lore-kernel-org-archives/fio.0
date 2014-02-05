Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
Date: Wed, 5 Feb 2014 10:43:09 -0800
Message-ID: <CANEJEGuqYiSQnyw2bVNFa3CKqmZK6+-3y5dDT4h3iccU-n0cAA@mail.gmail.com>
Subject: Rip out verify_backlog support?
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>, FIO_list <fio@vger.kernel.org>
Cc: Puthikorn Voravootivat <puthik@chromium.org>
List-ID: <fio@vger.kernel.org>

Today, fio has two distinct phases of operation: workload and then verify.

But there is this hack which is in-between those two: verify_backlog
which makes things a lot more complicated. This hack was added to
limit the amount of memory needed to track the IOs that needed to be
verify. I'm going to argue "verify_each_loop" could do the same thing
and keep fio internals simpler (strictly two phases). If the goal is
to have longer running, well defined workloads that can be verified,
then verifying after each iteration makes more sense.  In other words,
the jobs should define a workload limit (amount of IO or time) and
then iterate that constraint as many times as they want to reach the
duration they want.

Thoughts?

thanks,
grant

