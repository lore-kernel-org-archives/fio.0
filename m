Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxiN0cg0adpYvHZaYwp=aOueNJph5QWtUVih_JtoejjFFQ@mail.gmail.com>
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl>
	<5429B424.7080903@kernel.dk>
	<BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl>
	<5429C839.7090408@kernel.dk>
	<BLU402-EAS83A272EBBE7E3778E31EF8E0BA0@phx.gbl>
	<CALjAwxjEs_pcP3tHDSE76cdjC0JpRK_+xofshHTL0Lgch3J_OQ@mail.gmail.com>
	<542A1A21.4070406@kernel.dk>
	<BLU402-EAS3400F7B4A22E573A13F520CE0BB0@phx.gbl>
	<CALjAwxjcCm-Tm5kRf8SX0xYjj458fycVJ3SvOEPsOKaQUgiRDA@mail.gmail.com>
	<BLU402-EAS379961D4B53D8CE57017DC8E0BB0@phx.gbl>
	<CALjAwxhBMStNgdwqYVxcq4yDwJB+F+22Ef4Ra=oorCfeRBb6ew@mail.gmail.com>
	<BLU402-EAS374F3B5890A9AA4FCE9E01DE0BB0@phx.gbl>
	<CALjAwxiN0cg0adpYvHZaYwp=aOueNJph5QWtUVih_JtoejjFFQ@mail.gmail.com>
Date: Tue, 30 Sep 2014 22:17:05 +0100
Message-ID: <CALjAwxj4oUspNtqk=kOmmBE7U5Pu=s7-qGqaGOTUzZSBwb_=yA@mail.gmail.com>
Subject: Re: Limit LBA Range
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jon Tango <cheerios123@outlook.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 30 September 2014 14:07, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> If all you're trying to do is run a limited random job as quickly as
> possible you may find there are simpler fio jobs that will get higher
> throughput...

Perhaps something like the following (this would be the entire file):

[4K Precon]
name=4ktest
filename=\\.\physicaldrive1
ioengine=windowsaio
direct=1
time_based
runtime=18000
size=86%
bs=4k
offset=4k
norandommap
gtod_reduce=1
iodepth=256
thread

Again it's not the same as your vdbench workload but does it show a
different speed to your previous fio job?

-- 
Sitsofe | http://sucs.org/~sits/

