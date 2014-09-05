Return-Path: <matthew.weber@rockwellcollins.com>
MIME-Version: 1.0
In-Reply-To: <5409D102.7090306@kernel.dk>
References: <CANQCQpamy7TCmgtZBwtzcKH3KMZnJZ1tguPRGr2Xa63Axo3P1w@mail.gmail.com>
	<5409D102.7090306@kernel.dk>
Date: Fri, 5 Sep 2014 10:19:50 -0500
Message-ID: <CANQCQpYjJ7bHiUq0B8ghp5yo70iCzV_zK7-CUeZLjSmfvU=HRg@mail.gmail.com>
Subject: Re: fio-2.1.4 - dlopen failed for libaio
From: Matthew Weber <matthew.weber@rockwellcollins.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Agreed, thanks!

On Fri, Sep 5, 2014 at 10:04 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 09/05/2014 07:42 AM, Matthew Weber wrote:
>> Status output from a case where fio is built without libaio support....
>>      fio: engine libaio not loadable
>>      fio: failed to load engine libaio
>>      fio: file:ioengines.c:102, func=dlopen, error=libaio: cannot open
>> shared object file: No such file or directory
>>
>> I don't think this is necessarily a bug, but I wanted to comment on
>> what we observed.  There was some discussion on this on the buildroot
>> mailing list since we thought we needed to force a dependency on
>> having libaio always built as a dependency for the fio package to link
>> against.  Instead the user just needs to enable the libaio if they use
>> it as an engine (which is fine).
>> http://buildroot-busybox.2317881.n4.nabble.com/PATCH-v4-fio-add-missing-libaio-dependency-td77314.html
>>
>> Here our interpretation of what's happening.... It looks like the
>> shared library open error is one of the expected failure outputs if
>> you don't have support for the specific dynamic "io library".  The
>> build of the fio package does correctly determine if the libaio lib is
>> present or not and correctly adds it to the ioengines list for use (at
>> build time, so the enghelp output is correct, etc).  However when fio
>> is executed, it looks up if a "set of operations" is registered for
>> whichever ioengine library used.  If they are, it goes ahead and uses
>> them.  If they need to be loaded, like in the case of libaio, it
>> attempts to load them. However there is no check to see if fio was
>> built with support for the external library being loaded (like in this
>> case of libaio).
>
> The output could be improved, but it's expected behavior. If you specify
> ioengine=someengine, fio will check for an internal engine of that name.
> If it doesn't find one, it will attempt to dynamically load an engine
> with that file name. When that then fails, you get the above output.
> This is no different than if you did ioengine=windowsaio on Linux, or
> ioengine=libaio on Windows, for instance.
>
> --
> Jens Axboe
>



-- 
Matthew L Weber / Pr Software Engineer
Airborne Information Systems / Security Systems and Software
MS 131-100, C Ave NE, Cedar Rapids, IA, 52498, USA
www.rockwellcollins.com

Note: Any Export License Required Information and License Restricted
Third Party Intellectual Property (TPIP) content must be encrypted and
sent to matthew.weber@corp.rockwellcollins.com.

