Return-Path: <axboe@kernel.dk>
Message-ID: <52FA3D40.2040305@kernel.dk>
Date: Tue, 11 Feb 2014 08:09:52 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Fio 2.1.5 release upcoming
References: <20140206192135.GB3950@kernel.dk>	<CAF+0mvnBvLVqijP+Atbh9SEjt0p6-e3hy4Q3QRMtb+swp72bTQ@mail.gmail.com>	<20140209205744.GB2750@kernel.dk>	<CAF+0mvk+h3Hb5-KyQr7fqfmrUN6V4-HvKx4M0AYHC6mTUQu0+Q@mail.gmail.com>	<20140210221420.GD4096@kernel.dk>	<CAF+0mvmhEBaYSmLh99MST9MCg3rHan339rQkQb2Nw3fvStUfTg@mail.gmail.com>	<52F95D7B.1000002@kernel.dk> <CAF+0mvkg4sD4r75G6+warH0UtMOzYWm29-=MVQx5MDGiRk3sPA@mail.gmail.com>
In-Reply-To: <CAF+0mvkg4sD4r75G6+warH0UtMOzYWm29-=MVQx5MDGiRk3sPA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>



On 02/10/2014 05:00 PM, Matthew Eaton wrote:
> On Mon, Feb 10, 2014 at 3:15 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>> To be honest I'm not sure how to apply a patch.  Thus far I have only
>>> used release versions of fio.  Do I need to get fio from git, apply
>>> the patch, and then compile?
>>
>>
>> The easiest would be:
>>
>> $ git clone git://git.kernel.dk/fio
>>
>> Then save the patch from mail in a file, eg /tmp/patch. Then do:
>>
>> $ cd fio
>> $ patch -p1 --dry-run < /tmp/patch
>>
>> If the patch command spews any errors, the most likely explanation is that
>> your mailer mangled it somehow. You can try and add -l and see if that makes
>> patch happier, it'll ignore white space then.
>>
>> Assuming that worked, just do:
>>
>> $ ./configure
>> $ make
>>
>> and re-run with ./fio and your job file.
>>
>> --
>> Jens Axboe
>
> Jens, thanks a lot for your help.  Here is the output from fio from
> git + your patch.  Looks correct except that write io should be 1024
> MB instead of 1000 MB?

Yeah, but that one I can more easily explain. Unless told otherwise, fio 
just divides the file sizes into equal sizes, and aligns to the min bs. 
So that means you got 50*20MB files, eg 1000MB in total. I can make this 
a bit more clever, if it split the leftover 24MB over 24 of the files.

-- 
Jens Axboe

