Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758064Ab2C2Sar convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 29 Mar 2012 14:30:47 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: odd result with iodepth
References: <CAKAYmM+szZDvUmba3T-sCm8EB-QQhE0xQBsiePCJ7LqNGCA2BQ@mail.gmail.com>
	<CANWz5fhJWZzg21aXRbHiNwTBMOiTEqDmGYHD0iTybQPTWTaw8w@mail.gmail.com>
	<CAKAYmM+a8Dsz0+_SgNchhW_ESto=zycq-_e_we7=LoZ9aPM9EQ@mail.gmail.com>
Date: Thu, 29 Mar 2012 14:30:44 -0400
In-Reply-To: <CAKAYmM+a8Dsz0+_SgNchhW_ESto=zycq-_e_we7=LoZ9aPM9EQ@mail.gmail.com>
	(Chuck Tuffli's message of "Thu, 29 Mar 2012 11:27:44 -0700")
Message-ID: <x497gy3w97v.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chuck Tuffli <ctuffli@gmail.com>
Cc: fio@vger.kernel.org

Chuck Tuffli <ctuffli@gmail.com> writes:

> On Thu, Mar 29, 2012 at 10:14 AM, Chris Worley <worleys@gmail.com> wrote:
>> Sequential merging?  Try "randread" instead.
>
> Great suggestion. Doing some additional analysis, it does appear that
> IO's are probably getting merged as I see individual IO requests on
> the wire of 2-4KB.
>
> Googling around this area seems to suggest this kernel behavior isn't
> something I can disable. So if I honest to goodness *only* want 512B
> IO, is ioengine=sg the best route?

Try setting /sys/block/sdX/queue/nomerges to 2.  That should completely
disable merging.

Cheers,
Jeff
