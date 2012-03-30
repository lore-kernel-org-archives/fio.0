Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36869 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab2C3PlV convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 30 Mar 2012 11:41:21 -0400
Received: by wejx9 with SMTP id x9so443488wej.19
        for <fio@vger.kernel.org>; Fri, 30 Mar 2012 08:41:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x497gy3w97v.fsf@segfault.boston.devel.redhat.com>
References: <CAKAYmM+szZDvUmba3T-sCm8EB-QQhE0xQBsiePCJ7LqNGCA2BQ@mail.gmail.com>
	<CANWz5fhJWZzg21aXRbHiNwTBMOiTEqDmGYHD0iTybQPTWTaw8w@mail.gmail.com>
	<CAKAYmM+a8Dsz0+_SgNchhW_ESto=zycq-_e_we7=LoZ9aPM9EQ@mail.gmail.com>
	<x497gy3w97v.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 30 Mar 2012 08:41:20 -0700
Message-ID: <CAKAYmMLUn8eHLW9zo=3137ViA57y04e7VvKCDbptZ7J-PBp=FQ@mail.gmail.com>
Subject: Re: odd result with iodepth
From: Chuck Tuffli <ctuffli@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: fio@vger.kernel.org

On Thu, Mar 29, 2012 at 11:30 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Chuck Tuffli <ctuffli@gmail.com> writes:
>
>> On Thu, Mar 29, 2012 at 10:14 AM, Chris Worley <worleys@gmail.com> wrote:
>>> Sequential merging? =EF=BF=BDTry "randread" instead.
>>
>> Great suggestion. Doing some additional analysis, it does appear that
>> IO's are probably getting merged as I see individual IO requests on
>> the wire of 2-4KB.
>>
>> Googling around this area seems to suggest this kernel behavior isn't
>> something I can disable. So if I honest to goodness *only* want 512B
>> IO, is ioengine=3Dsg the best route?
>
> Try setting /sys/block/sdX/queue/nomerges to 2. =EF=BF=BDThat should comp=
letely
> disable merging.

Jeff -

I upgrade to a 3.0 series kernel and set nomerges to 2 and now all the
tools agree on the IOPs number. Thanks!

---chuck
