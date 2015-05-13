Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:33005 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934127AbbEMOBv (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 13 May 2015 10:01:51 -0400
Received: by qgdy78 with SMTP id y78so21682878qgd.0
        for <fio@vger.kernel.org>; Wed, 13 May 2015 07:01:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF+0mv=L0xSu8zs-d7kXUZ8LtUV+kmPc0MVyammADMHeJFuDEQ@mail.gmail.com>
References: <CAB-428kCfA3PZdu+3jOUAxQH4jL2fScEUAKctxy4NhXUfbz3rA@mail.gmail.com>
 <CAF+0mv=L0xSu8zs-d7kXUZ8LtUV+kmPc0MVyammADMHeJFuDEQ@mail.gmail.com>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Wed, 13 May 2015 09:01:09 -0500
Message-ID: <CAB-428m3S0xRi8KD9a9zr55839mD6vEx8OATHdb4Yzhv8-R6xw@mail.gmail.com>
Subject: Re: Write Pattern and Verify in separate run instance ?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Mattew,

Thanks for your reply. Is it possible to run Write-Phase and
Verify-phase in two separate run instances and job files ?


On Tue, May 12, 2015 at 8:18 PM, Matthew Eaton <m.eaton82@gmail.com> wrote:
> On Tue, May 12, 2015 at 9:49 AM, Alireza Haghdoost <haghdoost@gmail.com> wrote:
>> I want to do following experiment with FIO but now sure FIO have this
>> capability in place:
>>
>> 1. Run FIO and write a random content pattern on a RAW device or a File.
>> 2. Run FIO and verify the contents that has been written is correct.
>>
>> Based on my understanding, FIO do the verification phase at the same
>> run instance. However, I want the verification phase happen in a
>> separate stand alone run instance that may happen later.
>>
>> Would you please kindly let me know if this capability is available ?
>> If not, I will appreciate your input so I can expand the toolset.
>>
>> Thanks
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> One of the example job files sounds similar to what you're asking for.
> It uses a two phase approach, write phase, then verify phase.  I
> modified it a bit but maybe it will help you get on the right track.
>
> ; writes 512 byte verification blocks until the disk is full,
> ; then verifies written data
> [global]
> thread=1
> bs=128k
> direct=1
> ioengine=sync
> verify=meta
> verify_pattern=0x0123456789abcdef
> verify_interval=512
>
> [write-phase]
> filename=${fname}    ; or use a full disk, for example /dev/sda
> rw=write
> fill_device=1
> do_verify=0
>
> [verify-phase]
> stonewall
> create_serialize=0
> filename=${fname}
> rw=read
> do_verify=1
