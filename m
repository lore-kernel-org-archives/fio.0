Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48799 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731942AbfIEQK4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 5 Sep 2019 12:10:56 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: io_uring engine -- sqthread_poll option can't work as implemented
References: <x49r254apvv.fsf@segfault.boston.devel.redhat.com>
        <6adaa1ad-93b6-48b1-6fe0-7a0cceab9eda@kernel.dk>
        <x498sr5txag.fsf@segfault.boston.devel.redhat.com>
        <0f8ba952-418c-d63d-6b3e-021cae4cfecc@kernel.dk>
        <0edfb602-184c-f33b-485e-221be543b069@kernel.dk>
        <7a3c83bd-4bbe-72ca-b690-5b247e8b9fd0@kernel.dk>
        <x49h85qu6av.fsf@segfault.boston.devel.redhat.com>
        <75a6f63a-2515-32e1-07b8-5c84eed0c662@kernel.dk>
Date: Thu, 05 Sep 2019 12:10:55 -0400
In-Reply-To: <75a6f63a-2515-32e1-07b8-5c84eed0c662@kernel.dk> (Jens Axboe's
        message of "Thu, 5 Sep 2019 09:14:41 -0600")
Message-ID: <x49d0geu3jk.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> I did make make sqthread_poll == true set registerfiles as well, and added
> the man page bits for the option. If you have further updates, please do
> send them. Also interested in how the testing went ;-)

OK, I had a look and the patch looks good to me.  It tested out fine as
well with the attached jobfile, run against both a block device and file
system.

-Jeff

[global]
bs=4k
time_based=1
runtime=10s
ioengine=io_uring
rw=randread
iodepth=8
size=8g

[defaults-buffered]
hipri=0
fixedbufs=0

[defaults-direct]
stonewall
direct=1
hipri=0
fixedbufs=0

[hipri]
stonewall
hipri=1
fixedbufs=0
direct=1

[fixedbufs-buffered]
stonewall
hipri=0
fixedbufs=1
direct=0

[fixedbufs-direct]
stonewall
hipri=0
fixedbufs=1
direct=1

[hipri_fixed]
stonewall
hipri=1
fixedbufs=1
direct=1

[sqthread_poll]
stonewall
hipri=0
fixedbufs=0
direct=0

[sqthread_poll-buffered]
stonewall
hipri=0
fixedbufs=0
direct=0

[sqthread_poll-hipri]
stonewall
hipri=1
fixedbufs=0
direct=1

[sqthread_poll-fixedbufs]
stonewall
hipri=0
fixedbufs=1
direct=0

