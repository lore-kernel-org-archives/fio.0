Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxjncx7v0SkHfhDL7GaapqfzeLBpzyh=5ksTPtCQKS2UeA@mail.gmail.com>
References: <20170809134434.105384-1-tkusumi@tuxera.com> <88b0eac7-a5cc-0cf5-5f56-d3fc7dd89f5d@dell.com>
 <CAHndrBmho_KUWg8kqHaM5OXWd_dtviQ+bZNsQa+Nrtq7Kee0AA@mail.gmail.com>
 <CALjAwxj2uC+kBYQz8VmZ3XSXPJM9de+GYP3KZ-r3z7=C_CYbkQ@mail.gmail.com>
 <CAHndrBnyRoRFuwN8qX_PzEW6pfGMX0BVQOm6fSX0hOeEpb-Nig@mail.gmail.com> <CALjAwxjncx7v0SkHfhDL7GaapqfzeLBpzyh=5ksTPtCQKS2UeA@mail.gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Fri, 11 Aug 2017 22:44:30 +0300
Message-ID: <CAHndrBmA7rxJh4ac6SUL7THu9N1Xqd4H=8hoVKQ6rubOEmYeXA@mail.gmail.com>
Subject: Re: [PATCH] HOWTO: fix unit type suffix in "Parameter types" section
 to upper case
Content-Type: text/plain; charset="UTF-8"
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Mikhail Terekhov <Mikhail.Terekhov@dell.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

2017-08-11 22:29 GMT+03:00 Sitsofe Wheeler <sitsofe@gmail.com>:
> On 11 August 2017 at 08:06, Tomohiro Kusumi <kusumi.tomohiro@gmail.com> wrote:
>> Hi
>>
>> 2017-08-11 9:11 GMT+03:00 Sitsofe Wheeler <sitsofe@gmail.com>:
>>> Hi,
>>>
>>> On 10 August 2017 at 19:28, Tomohiro Kusumi <kusumi.tomohiro@gmail.com> wrote:
>>>> Hi
>>>>
>>>> 2017-08-10 18:08 GMT+03:00 Mikhail Terekhov <Mikhail.Terekhov@dell.com>:
>>>>> On 08/09/17 09:44, kusumi.tomohiro@gmail.com wrote:
>>>>>>
>>>>>> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>>>>>>
>>>>>> Redo 9ff84231('HOWTO: fix unit type suffix in "Parameter types" section').
>>>>>>
>>>>>>> These should be all in lower case or all in upper case, but not both.
>>>>>>> The man page already has these in lower case.
>>>>>>
>>>>>> Change above to all upper case based on below comment, instead of all
>>>>>> in lower. Fix the man page (which originally had in lower) as well.
>>>>>>
>>>>>> RE: [PATCH 2/4] HOWTO: fix unit type suffix in "Parameter types" section
>>>>>> http://www.spinics.net/lists/fio/msg06146.html
>>>>>> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
>>>>>> ---
>>>>>>   HOWTO | 20 ++++++++++----------
>>>>>>   fio.1 | 20 ++++++++++----------
>>>>>>   2 files changed, 20 insertions(+), 20 deletions(-)
>>>>>>
>>>>>> diff --git a/HOWTO b/HOWTO
>>>>>> index 6c69a0e..fc173f0 100644
>>>>>> --- a/HOWTO
>>>>>> +++ b/HOWTO
>>>>>> @@ -505,19 +505,19 @@ Parameter types
>>>>>>         prefixes.  To specify power-of-10 decimal values defined in the
>>>>>>         International System of Units (SI):
>>>>>>   -             * *ki* -- means kilo (K) or 1000
>>>>>> -               * *mi* -- means mega (M) or 1000**2
>>>>>> -               * *gi* -- means giga (G) or 1000**3
>>>>>> -               * *ti* -- means tera (T) or 1000**4
>>>>>> -               * *pi* -- means peta (P) or 1000**5
>>>>>> +               * *Ki* -- means kilo (K) or 1000
>>>>>> +               * *Mi* -- means mega (M) or 1000**2
>>>>>> +               * *Gi* -- means giga (G) or 1000**3
>>>>>> +               * *Ti* -- means tera (T) or 1000**4
>>>>>> +               * *Pi* -- means peta (P) or 1000**5
>>>>>>         To specify power-of-2 binary values defined in IEC 80000-13:
>>>>>>   -             * *k* -- means kibi (Ki) or 1024
>>>>>> -               * *m* -- means mebi (Mi) or 1024**2
>>>>>> -               * *g* -- means gibi (Gi) or 1024**3
>>>>>> -               * *t* -- means tebi (Ti) or 1024**4
>>>>>> -               * *p* -- means pebi (Pi) or 1024**5
>>>>>> +               * *K* -- means kibi (Ki) or 1024
>>>>>> +               * *M* -- means mebi (Mi) or 1024**2
>>>>>> +               * *G* -- means gibi (Gi) or 1024**3
>>>>>> +               * *T* -- means tebi (Ti) or 1024**4
>>>>>> +               * *P* -- means pebi (Pi) or 1024**5
>>>>>>         With :option:`kb_base`\=1024 (the default), the unit prefixes are
>>>>>> opposite
>>>>>>         from those specified in the SI and IEC 80000-13 standards to
>>>>>> provide
>>>>>> diff --git a/fio.1 b/fio.1
>>>>>> index ab978ab..a3fba65 100644
>>>>>> --- a/fio.1
>>>>>> +++ b/fio.1
>>>>>> @@ -242,37 +242,37 @@ prefixes. To specify power-of-10 decimal values
>>>>>> defined in the
>>>>>>   International System of Units (SI):
>>>>>>   .RS
>>>>>>   .P
>>>>>> -ki means kilo (K) or 1000
>>>>>> +Ki means kilo (K) or 1000
>>>>>>   .RE
>>>>>>   .RS
>>>>>> -mi means mega (M) or 1000**2
>>>>>> +Mi means mega (M) or 1000**2
>>>>>>   .RE
>>>>>>   .RS
>>>>>> -gi means giga (G) or 1000**3
>>>>>> +Gi means giga (G) or 1000**3
>>>>>>   .RE
>>>>>>   .RS
>>>>>> -ti means tera (T) or 1000**4
>>>>>> +Ti means tera (T) or 1000**4
>>>>>>   .RE
>>>>>>   .RS
>>>>>> -pi means peta (P) or 1000**5
>>>>>> +Pi means peta (P) or 1000**5
>>>>>>   .RE
>>>>>>   .P
>>>>>>   To specify power-of-2 binary values defined in IEC 80000-13:
>>>>>>   .RS
>>>>>>   .P
>>>>>> -k means kibi (Ki) or 1024
>>>>>> +K means kibi (Ki) or 1024
>>>>>>   .RE
>>>>>>   .RS
>>>>>> -m means mebi (Mi) or 1024**2
>>>>>> +M means mebi (Mi) or 1024**2
>>>>>>   .RE
>>>>>>   .RS
>>>>>> -g means gibi (Gi) or 1024**3
>>>>>> +G means gibi (Gi) or 1024**3
>>>>>>   .RE
>>>>>>   .RS
>>>>>> -t means tebi (Ti) or 1024**4
>>>>>> +T means tebi (Ti) or 1024**4
>>>>>>   .RE
>>>>>>   .RS
>>>>>> -p means pebi (Pi) or 1024**5
>>>>>> +P means pebi (Pi) or 1024**5
>>>>>>   .RE
>>>>>>   .P
>>>>>>   With `kb_base=1024' (the default), the unit prefixes are opposite
>>>>>
>>>>> Sorry for the late comment, but:
>>>>>
>>>>> As Robert mentioned SI names are case sensitive, so for kilo it should be
>>>>> 'k', not 'K'.
>>>>>
>>>>> The example for 'int' in 'Parameter types' [1] section seems to contradict
>>>>> to what
>>>>> 'Units' [2] section says. For kb_base=1000 the units meaning should be
>>>>> strait
>>>>> according to [2] but in [1] the meaning is reversed.
>>>>
>>>> Yes, you're right.
>>>> Aside from this lower/upper case thing, "Parameter types" is showing
>>>> them in opposite (it's talking about kb_base=1024 case).
>>>
>>> I've been staring at the box over on
>>> https://en.wikipedia.org/wiki/Template:Bit_and_byte_prefixes and the k
>>> is lower unless you're JEDEC (sigh). The whole unit thing never stops
>>> being awkward (why did humans do this to ourselves?). Anyway, is the
>>> suggestion make k lowercase when explicitly mentioning SI suffixes?
>>>
>>> For the "Parameter types" examples how about something like the following:
>>>
>>> Examples with kb_base=1000:
>>>
>>> 4096 bytes: 4096, 4096b, 4096B, 4ki, 4Ki, 4kib, 4kiB, 4KiB
>>> 1048576 bytes: 1048576, 1024ki, 1mi
>>> 1000000 bytes: 1000000, 1000k, 1m
>>> [...]
>>>
>>> Examples with kb_base=1024 (default):
>>>
>>> 4096 bytes: 4096, 4096b, 4096B, 4k, 4K, 4kb, 4kB, 4KB
>>> 1048576 bytes: 1048576, 1024k, 1m
>>> 1000000 bytes: 1000000, 1000ki, 1mi
>>> [...]
>>>
>>> I've tried not to mention suffixes at the far left, lists go from more
>>> digits to less digits, list go from unsuffixed to longest suffix and
>>> stick to lowercase suffixes for all the later examples. My thinking is
>>> that these are just examples rather than the preferred typing form /
>>> SI form etc.
>>
>> Yes, I see it's more clear with the fat left one without suffixes.
>>
>> I think the previous part before examples also needs to be modified like below,
>> if you look at what "Units" part says, as Mikhail mentioned.
>> The first one (kb_base=1000) is better than the second one though,
>> as it mentions the default kb_base=1024 case right after that.
>
> Ah I see what you mean:
>
>>
>> --
>> diff --git a/HOWTO b/HOWTO
>> index fc173f0..239d349 100644
>> --- a/HOWTO
>> +++ b/HOWTO
>> @@ -505,19 +505,19 @@ Parameter types
>>         prefixes.  To specify power-of-10 decimal values defined in the
>>         International System of Units (SI):
>>
>> -               * *Ki* -- means kilo (K) or 1000
>> -               * *Mi* -- means mega (M) or 1000**2
>> -               * *Gi* -- means giga (G) or 1000**3
>> -               * *Ti* -- means tera (T) or 1000**4
>> -               * *Pi* -- means peta (P) or 1000**5
>> +               * *K* -- means kilo (K) or 1000
>
> I'd argue this should be
>
>  +               * *K* -- means kilo (k) or 1000
>
> (note the little k in brackets)
>
>> +               * *M* -- means mega (M) or 1000**2
>> +               * *G* -- means giga (G) or 1000**3
>> +               * *T* -- means tera (T) or 1000**4
>> +               * *P* -- means peta (P) or 1000**5
>>
>>         To specify power-of-2 binary values defined in IEC 80000-13:
>>
>> -               * *K* -- means kibi (Ki) or 1024
>> -               * *M* -- means mebi (Mi) or 1024**2
>> -               * *G* -- means gibi (Gi) or 1024**3
>> -               * *T* -- means tebi (Ti) or 1024**4
>> -               * *P* -- means pebi (Pi) or 1024**5
>> +               * *Ki* -- means kibi (Ki) or 1024
>> +               * *Mi* -- means mebi (Mi) or 1024**2
>> +               * *Gi* -- means gibi (Gi) or 1024**3
>> +               * *Ti* -- means tebi (Ti) or 1024**4
>> +               * *Pi* -- means pebi (Pi) or 1024**5
>>
>> Or like
>>
>> --diff --git a/HOWTO b/HOWTO
>> index fc173f0..6d0e254 100644
>> --- a/HOWTO
>> +++ b/HOWTO
>> @@ -501,7 +501,7 @@ Parameter types
>>         default unit is bytes. For quantities of time, the default
>> unit is seconds
>>         unless otherwise specified.
>>
>> -       With :option:`kb_base`\=1000, fio follows international
>> standards for unit
>> +       With :option:`kb_base`\=1024, fio follows international
>> standards for unit
>>         prefixes.  To specify power-of-10 decimal values defined in the
>>         International System of Units (SI):
>
> You would need to change more text because otherwise you've got a
> conflict in the paragraph because you're saying kb_base=1024 but
> you're also saying power-of-10 decimal and SI units. I know what
> you're getting at though but I guess for now I'd vote for your other
> changes.
>

Feel free to send the fix for this if you would like.
Then I'll rebase my man page updates (sync with HOWTO) which I'll send
anyway within 2-3 days before 3.0 release, on top of that bug fix once
committed.


> --
> Sitsofe | http://sucs.org/~sits/

