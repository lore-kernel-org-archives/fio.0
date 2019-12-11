Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
Subject: Re: [PATCH 0/9] testing patches
References: <20191210175442.2975-1-vincentfu@gmail.com>
 <CALjAwxi-nfeunNEOuhbjF8L-0LhmmHZ=exRBAJ0V+EQi0ep37Q@mail.gmail.com>
 <191fa593-aecc-a077-c24f-980f6d8280e0@gmail.com>
 <cf608708-3aee-767b-7460-ae8e7d77cc7e@kernel.dk>
From: Vincent Fu <vincentfu@gmail.com>
Message-ID: <17299496-53a9-f02e-1726-e3b2c707db6c@gmail.com>
Date: Wed, 11 Dec 2019 15:10:52 -0500
MIME-Version: 1.0
In-Reply-To: <cf608708-3aee-767b-7460-ae8e7d77cc7e@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>, Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 12/11/19 2:57 PM, Jens Axboe wrote:
> On 12/11/19 12:53 PM, Vincent Fu wrote:
>> On 12/10/19 4:32 PM, Sitsofe Wheeler wrote:
>>> On Tue, 10 Dec 2019 at 17:56, <vincentfu@gmail.com> wrote:
>>>>
>>>> From: Vincent Fu <vincent.fu@wdc.com>
>>>>
>>>> Jens, please consider this series of patches related to testing.
>>>>
>>>> The patches improve t/run-fio-tests.py in various ways, most prominently
>>>> adding support for Windows and macOS.
>>>>
>>>> Also included are travis and appveyor patches that add run-fio-tests.py
>>>> as a step.  Currently both the travis and appveyor build processes
>>>> complete in less than four minutes.  Adding run-fio-tests.py increases
>>>> this to about 20 minutes for travis and 14 minutes for appveyor.
>>>
>>> In general I think this work is fantastic and much needed (you can
>>> search through the fio commit logs using "git log --grep 'size='" to
>>> find jobs files that have caused issues in the past and may be worth
>>> turning into tests at some point). However, I think making the builds
>>> so slow may be a disadvantage rather than a benefit. I agree with
>>> nearly all the patch set bar running this by default with
>>> travis/appveyor...
>>>
>>
>> Many thanks for the feedback, Sitsofe. I agree that the build times are
>> uncomfortably long, but since I had done the work I thought I would
>> offer the patches to Jens.
>>
>> Jens, what do you think? Would you like me to re-send the patch series
>> without the appveyor and travis changes?
> 
> Looks like it's about 20 min, I'm not so sure we need faster turn-around
> than that. I would personally much rather see a pull request with 20 min
> delay on whether it passes or not, rather than have to run it manually.
> That's how things get missed.
> 
> So I'd be leaning towards just making it run it by default. Is 20 min
> really that big of an issue? It's not like it's holding anyone up.
> 

I think the main difference is that at 4 minutes, it's easy enough to 
wait around to check that the build has succeeded, whereas at 20 minutes 
one has moved onto another task and will have to make a context switch 
to come back to check on the build. Also, if people add more tests the 
build times will become even longer.

All that said, it's easy enough to revert the patch if adding the tests 
hurts the workflow too much.

