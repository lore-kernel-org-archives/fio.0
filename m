Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:36635 "EHLO
	mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbcGZGPg (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 26 Jul 2016 02:15:36 -0400
Received: by mail-yw0-f169.google.com with SMTP id u134so185431520ywg.3
        for <fio@vger.kernel.org>; Mon, 25 Jul 2016 23:15:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <nn66ih$j66$1@ger.gmane.org>
References: <nn5git$q4l$1@ger.gmane.org> <CALjAwxgP4k4rRFAgpiJ-oBaBHd0OAyXXJ-dTZg7QxyaD36dO_g@mail.gmail.com>
 <nn66ih$j66$1@ger.gmane.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 26 Jul 2016 07:15:34 +0100
Message-ID: <CALjAwxhCSTdi_EjvciC=-zy8=8G4rz-X6G4RiOgKwTeyumPPog@mail.gmail.com>
Subject: Re: fio jobs time_based & runtime scope
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saeed <ionictea@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 26 July 2016 at 00:15, Saeed <ionictea@gmail.com> wrote:
> Here's the example:
>
> [global]
> bs=4k
> ioengine=libaio
> iodepth=32
> size=1g
> direct=1
> time_based=1
> runtime=300
> filename=/dev/sdb
> group_reporting
> numjobs=1
>
> # validation
> do_verify=1
> verify_fatal=1
> verify_dump=1
>
> verify_pattern=0x00000001
>
> [sequential]
> rw=readwrite
> stonewall
>
> [random]
> rw=randrw
> stonewall
>
> So with this job file there are two job declarations (sequential & random).
> Does the time_based & runtime requirement apply to the entire job as a whole
> or per job declaration?

time_based and runtime are per job (like nearly all fio options) so
this job file above will take 600 seconds to complete. This is easy to
check with a smaller and simpler job file:

[global]
runtime=5
time_based
size=10M
stonewall
filename=/tmp/fiotmp
[job1]
[job2]

The stonewall forces the jobs to run one after the other and the
results will show long each job ran for. If necessary we can easily
use a program like time to see how long the total running time turned
out to be.

Remember that runtime applies to all parts of a job. If a job is
supposed to verify after it has finished writing but the runtime is
exceeded during the writing part then no verification will occur.

-- 
Sitsofe | http://sucs.org/~sits/
