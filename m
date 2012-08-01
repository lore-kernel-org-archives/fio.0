Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53343 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab2HAGpQ (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 1 Aug 2012 02:45:16 -0400
Message-ID: <5018D071.2060201@kernel.dk>
Date: Wed, 01 Aug 2012 08:45:05 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix fallocate erroneously returning ENOSYS on Linux systems
References: <20120731135709.74613qmjaulf65yc@webmail.oregonstate.edu>
In-Reply-To: <20120731135709.74613qmjaulf65yc@webmail.oregonstate.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: clinew@onid.orst.edu
Cc: fio@vger.kernel.org, kcastiglia@aereo.com, cmm@linux.vnet.ibm.com

On 07/31/2012 10:57 PM, clinew@onid.orst.edu wrote:
>> On 07/31/2012 09:49 PM, clinew@onid.orst.edu wrote:
>>> Currently, the helpers.c file provides a function defintion for Linux fallocate
>>> that sets errno to ENOSYS and returns failure; this is useful for a non-Linux
>>> OS. However, this definition will override the Linux implementation of
>>> fallocate when 'fallocate=keep' is set. Adding a preprocessor macro to check
>>> if Linux fallocate is defined fixes this issue.
>>>
>>> Signed-off-by: Wade Cline <wcline@us.ibm.com>
>>> ---
>>>  helpers.c |    2 ++
>>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/helpers.c b/helpers.c
>>> index 9562567..714842e 100644
>>> --- a/helpers.c
>>> +++ b/helpers.c
>>> @@ -9,11 +9,13 @@
>>>  #include "arch/arch.h"
>>>  #include "os/os.h"
>>>
>>> +#ifndef FIO_HAVE_LINUX_FALLOCATE
>>>  int _weak fallocate(int fd, int mode, off_t offset, off_t len)
>>>  {
>>>         errno = ENOSYS;
>>>         return -1;
>>>  }
>>> +#endif
>>
>> Hmm, the purpose of the _weak would be to NOT override a fallocate() if
>> we have one. Why isn't this working?
>>
>> -- 
>> Jens Axboe
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> I am not sure. Running 'nm' with and without the patch provides the following symbol table information:
> 
> Without patch:
> W fallocate64
> w posix_fallocate64@@GLIBC_2.2.5
> 
> With patch:
> w fallocate64@@GLIBC_2.10
> w posix_fallocate64@@GLIBC_2.2.5
> 
> My interpretation of this is that, without the patch, the
> weakly-linked symbol has a default definition and doesn't know to look
> up the correct shared-library routine, so it falls back to the default
> definition; this may or may not be the case. Also, it appears that
> using #ifndef <funciton definition> #endif has been done for a number
> of functions in 'helpers.c', so this may not be the only function that
> has experienced the same issue.

I think you are right. It's all pretty much dancing around the fact that
fio does not use autoconf or similar to detect these at build time. I'll
apply the patch, thanks.

-- 
Jens Axboe

