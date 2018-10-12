Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:45501 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbeJMCYp (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 Oct 2018 22:24:45 -0400
Content-Type: text/plain; charset="utf-8"
Mime-Version: 1.0 (1.0)
Subject: Re: fio on vmware esxi
From: Eliezer Nebab <eliezer@integritech.solutions>
In-Reply-To: <C1ACAB20-DCF1-4906-87C0-DBE727736C5E@emc.com>
Date: Fri, 12 Oct 2018 13:50:47 -0500
Content-Transfer-Encoding: 8bit
Message-Id: <A041722F-04AB-4C3D-B9CC-E6CF492C3B7C@integritech.solutions>
References: <001001d460c6$8c44b090$a4ce11b0$@integritech.solutions> <BC19FF62-2BD8-4F83-9BFB-8D271F5D7101@emc.com> <AE78B431-F6A6-4796-BB7E-1FE45E328D74@integritech.solutions> <0DE2B6A6-1AFB-4FAD-BD99-53136B45BCD8@emc.com> <CALjAwxjazAUEip=nea=7K8LVRBRwq6c0h9FheeCVvh372ZvaKw@mail.gmail.com> <6E7254E9-4B9B-4208-9392-2ABD43FE36A4@emc.com> <CALjAwxg9kiEPqOLHD2_-Px9_rXeQyqAzksaf39ABakJnUE1kiw@mail.gmail.com> <C1ACAB20-DCF1-4906-87C0-DBE727736C5E@emc.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Beierl, Mark" <Mark.Beierl@dell.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio <fio@vger.kernel.org>

I dont blame ya for the over enthusiasm Mark.  I’m just as excited and enthused when I got your reply thay you got fio to work on vmware!

Ive yet to try this out, hoping this weekend to spend some quality time on this and will report back.

Eliezer

> On Oct 12, 2018, at 1:18 PM, Beierl, Mark <Mark.Beierl@dell.com> wrote:
> 
> Oops, thanks Sitsofe.
> 
> I over-enthusiatically copied that from another docker file where I was also doing https requests.  You are right, it has no purpose in this case.
> 
> Hopefully I can look at the libaio with --esx option next week.
> 
> Regards,
> Mark
> 
> Mark Beierl
> SW System Sr Principal Developer
> Dell EMC | Cloud & Communication Service Provider Solution
> Mark.Beierl@Dell.com
> 
> On 2018-10-12, 02:13, "Sitsofe Wheeler" <sitsofe@gmail.com> wrote:
> 
> 
>    [EXTERNAL EMAIL] 
>    Please report any suspicious attachments, links, or requests for sensitive information.
> 
> 
>    Thank you for following up on this Mark - I'm sure others will find
>    that information useful!
> 
>    Glancing at your steps:
> 
>> RUN git config --global http.sslVerify false
> 
>    I'm not sure you need this as the next line isn't using https:
> 
>> RUN git clone http://git.kernel.dk/fio.git fio
> 
>    I don't know if alpine builds a static version of libaio (e.g. there
>    isn't a prepackaged *static* libaio on CentOS/RHEL) but if it does you
>    may find you can nobble fio's configure script to allow its detection
>    even though you're using the --esx option...
> 
>>    On Thu, 11 Oct 2018 at 14:42, Beierl, Mark <Mark.Beierl@dell.com> wrote:
>> 
>> Hey all, and special thanks to Sitsofe for pointing me at the github fio issue 464.
>> 
>> I have fio working on my ESXi 6.5 server.  Here is the procedure I used.  Install Docker and use this Dockerfile:
>> 
>> =============================
>> FROM multiarch/alpine:x86_64-v3.6
>> 
>> RUN apk --no-cache add --update \
>>    git \
>>    alpine-sdk \
>>    coreutils \
>>    linux-headers \
>>    libaio \
>>    libaio-dev \
>>    zlib-dev
>> 
>> RUN git config --global http.sslVerify false
>> RUN git clone http://git.kernel.dk/fio.git fio
>> RUN cd fio && ./configure --esx
>> RUN cd fio && EXTFLAGS="-static" make -j $(grep -c ^processor /proc/cpuinfo) install
>> =============================
>> 
>> Then, start the docker container with a dummy command (I’m sure there are better ways to do this, but it works, so hey)
>> $ docker run -d fio sleep 600
>> 
>> Note the ID that it spits out.  Use that ID in the next command:
>> $ docker cp 69e64de38659d350fb07e45b5d7d2d4098c642ec1ca81a6eb18a9b34e622082f:/fio/fio .
>> 
>> You can now scp that fio to your ESXi server and execute it there.
>> 
>> [root@R156U37ESXI:/vmfs/volumes/5a611782-2d14bf65-c453-246e96146f88/testdir] ~/fio test.fio
>> file1: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=16
>> fio-3.11-6-gee6ce
>> Starting 1 thread
>> file1: Laying out IO file (1 file / 1024MiB)
>> Jobs: 1 (f=1): [f(1)][100.0%][r=1346KiB/s,w=899KiB/s][r=336,w=224 IOPS][eta 00m:00s]
>> ....
>> 
>> Hope this works for you, Eliezer!
>> 
>> Regards,
>> Mark
>> 
>> Mark Beierl
>> SW System Sr Principal Developer
>> Dell EMC | Cloud & Communication Service Provider Solution
>> Mark.Beierl@Dell.com
>> 
>> On 2018-10-11, 01:34, "Sitsofe Wheeler" <sitsofe@gmail.com> wrote:
>> 
>> 
>>    [EXTERNAL EMAIL]
>>    Please report any suspicious attachments, links, or requests for sensitive information.
>> 
>> 
>>    Hi,
>> 
>>    The question of how to compile fio for ESXi comes up every few years
>>    and as Mark suggested it IS doable by building a static fio binary
>>    from an appropriate real distro but there are a few gotchas. You can't
>>    take a "regular" distro's fio because the ESXi environment simply
>>    doesn't match that of the regular distro (for example things like a
>>    glibc are compiled with different options, libraries are missing etc).
>> 
>>    The last time it was asked about was over on Github (see
>>    https://github.com/axboe/fio/issues/464 ) where I mentioned the steps
>>    I used to get it going for ESXi 6.0 but note that I no longer have
>>    access to ESXi these days so I can't say what's needed for modern
>>    environments (but the general idea should be the same).
>> 
>>>    On Wed, 10 Oct 2018 at 21:00, Beierl, Mark <Mark.Beierl@dell.com> wrote:
>>> 
>>> Ya, sorry I could not be of more help.
>>> 
>>> I doubt that FIO could be compiled on raw ESXi as there is no compiler available on that from what I can tell.  A statically linked one should work, but I really don’t know enough to be able to say why it could not start a job.
>>> 
>>> I do know that ESXi can pass a full device (raw disk) to a VM and that VM takes full ownership of it.  So you could load a VM with CentOS or something and have FIO profile the raw device, but that is probably not going to be useful.  Chances are you are looking to something a little more advanced like profile vSAN or some other form of software defined storage?
>>> 
>>> Regards,
>>> Mark
>>> 
>>> Mark Beierl
>>> SW System Sr Principal Developer
>>> Dell EMC | Cloud & Communication Service Provider Solution
>>> Mark.Beierl@Dell.com
>>> 
>>> On 2018-10-10, 15:56, "Eliezer Nebab" <eliezer@integritech.solutions> wrote:
>>> 
>>> 
>>>    [EXTERNAL EMAIL]
>>>    Please report any suspicious attachments, links, or requests for sensitive information.
>>> 
>>> 
>>>    Thanks for the quick response Mark.
>>> 
>>>    Yes, I was looking for documentation or guide on if fio can be compiled or installed on esxi servers.
>>> 
>>>    From your response it looks like (compile or precompiled) neither works.
>>> 
>>>    Thank you.
>>> 
>>>    Eliezer
>>> 
>>> 
>>>> On Oct 10, 2018, at 2:05 PM, Beierl, Mark <Mark.Beierl@dell.com> wrote:
>>>> 
>>>> Are you asking if FIO can be built or run on the hypervisor itself, like via ssh?
>>>> 
>>>> I have tried a test before where I statically compiled FIO and copied it to an ESXi server, but I was never able to get any jobs to start.  Not sure if the kernel supports the fork() or whatever call FIO uses to spawn the job processes.  So, I’m not sure it can be done.  ESXi is not a general purpose OS, so it lacks some features.
>>>> 
>>>> Regards,
>>>> Mark
>>>> 
>>>> Mark Beierl
>>>> SW System Sr Principal Developer
>>>> Dell EMC | Cloud & Communication Service Provider Solution
>>>> Mark.Beierl@Dell.com
>>>> 
>>>> On 2018-10-10, 14:24, "fio-owner@vger.kernel.org on behalf of eliezer@integritech.solutions" <fio-owner@vger.kernel.org on behalf of eliezer@integritech.solutions> wrote:
>>>> 
>>>> 
>>>>   [EXTERNAL EMAIL]
>>>>   Please report any suspicious attachments, links, or requests for sensitive information.
>>>> 
>>>> 
>>>>   Is fio supported on vmware esxi 5 and 6 servers?  Does anyone have any
>>>>   helpful guides as to how to install it on vmware?  I've searched google but
>>>>   could not find any.  The only reference to fio+vmware is Disable libaio for
>>>>   ESXi build - bug#80
>>>> 
>>>>   Thank you in advance.
>>>> 
>>>>   Regards,
>>>>   Eliezer
>> 
>>    --
>>    Sitsofe | http://sucs.org/~sits/
>> 
>> 
> 
> 
>    -- 
>    Sitsofe | http://sucs.org/~sits/
> 
> 


