Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35591 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab2CAUQM (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 Mar 2012 15:16:12 -0500
Message-ID: <4F4FD908.4090409@kernel.dk>
Date: Thu, 01 Mar 2012 21:16:08 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] fallocate: enable fallocate options on Linux
References: <1330548842-31981-1-git-send-email-dehrenberg@google.com> <CAAK6Zt3fiTZpmkK6tyMVOAWAdL4FZgOTAa7SE2U6d80-tRanxg@mail.gmail.com> <4F4F8A7E.1010206@kernel.dk> <CAAK6Zt1G_7H3d=zrRwyZni=MkngZHpNFnAqOz=VvCqrDBEY=UQ@mail.gmail.com>
In-Reply-To: <CAAK6Zt1G_7H3d=zrRwyZni=MkngZHpNFnAqOz=VvCqrDBEY=UQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Daniel Ehrenberg <dehrenberg@google.com>
Cc: fio@vger.kernel.org, nauman@google.com, egouriou@google.com, tirea@google.com

On 2012-03-01 20:23, Daniel Ehrenberg wrote:
> On Thu, Mar 1, 2012 at 6:41 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 02/29/2012 10:22 PM, Daniel Ehrenberg wrote:
>>> Hi,
>>>
>>> I'd just like to clarify: I'm not sure if the patch I just sent is
>>> exactly what we'd want. Maybe it is correct to set FIO_HAVE_FALLOCATE
>>> on some Linux systems which aren't at least glibc version 2.8. I don't
>>> know much about the history of these features, and if any fio users
>>> are using an older system where they do still want fallocate
>>> capabilities, I'd appreciate input here.
>>
>> There is something a bit wonky there. We should be able to use
>> posix_fallocate() from 2.6 and on, but only the linux fallocate from 2.8
>> and up.
>>
>> Something like the below.
>>
>> diff --git a/os/os-linux.h b/os/os-linux.h
>> index 3bf6bd9..d5c3f76 100644
>> --- a/os/os-linux.h
>> +++ b/os/os-linux.h
>> @@ -50,6 +50,9 @@
>>  * Can only enable this for newer glibcs, or the header and defines are
>>  * missing
>>  */
>> +#if __GLIBC__ >= 2 && __GLIBC_MINOR__ >= 6
>> +#define FIO_HAVE_FALLOCATE
>> +#endif
>>  #if __GLIBC__ >= 2 && __GLIBC_MINOR__ >= 8
>>  #define FIO_HAVE_LINUX_FALLOCATE
>>  #endif
>>
>> --
>> Jens Axboe
>>
> 
> That looks good to me. Thanks for the revision.

Thanks for letting me know. The change has been committed.

-- 
Jens Axboe

