Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHndrBm96oiGqS4FOcRh0doToaptqhQPHnArMaLJX_AUiyXVLw@mail.gmail.com>
References: <20170704180816.39585-1-tkusumi@tuxera.com> <20170704180816.39585-2-tkusumi@tuxera.com>
 <CALjAwxjMC_Hk2KUBRjpxS_2Ujc4iMr796h5fDukK1RgGLrJyng@mail.gmail.com> <CAHndrBm96oiGqS4FOcRh0doToaptqhQPHnArMaLJX_AUiyXVLw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 4 Jul 2017 23:50:58 +0100
Message-ID: <CALjAwxje2p3LGUWvEcMvQMH=EH_7wcTWGPzSOibr1ZmW3p1Fog@mail.gmail.com>
Subject: Re: [PATCH 1/7] man: sync OPTIONS section with HOWTO
Content-Type: text/plain; charset="UTF-8"
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

Hi,

I'm very slowly working on improving the Sphinx generated man page.
The latest round of updates was partially to try and add any missing
sections that were only in the man page and weren't in the HOWTO.

There's still work to do as the "generated" man page doesn't have
typical man page section headings, it is missing key sections like
SYNTAX, it repeats the AUTHOR section twice etc. There are also a lot of
options that are missing their default values.

Other improvements need to be made to Sphinx itself: it seems to output
a UTF-8 man page that some platforms (macOS/OSX) struggle
with so it could do with an option to just output plain ASCII man
pages. Additionally some of the rendering looks a bit strange
(underlines only seem to go under letters, meta variable names after
parameters not underlined) and a few other oddities
like that.

On 4 July 2017 at 20:33, Tomohiro Kusumi <kusumi.tomohiro@gmail.com> wrote:
> Hi
>
> Thanks.
> I think it's better if there's a way to somehow automatically generate
> the man page from HOWTO like you mentioned (and update from that).
>
> I simply don't know high-level documentation tools that this was the only way.
> (The current man page also seems to have been written by hand)
>
>
> 2017-07-04 22:03 GMT+03:00 Sitsofe Wheeler <sitsofe@gmail.com>:
>> Hi,
>>
>> On 4 July 2017 at 19:08,  <kusumi.tomohiro@gmail.com> wrote:
>>>
>>> This commit brings in updates from HOWTO. The exception is --debug
>>> option, which is too verbose yet not that important for all debug types
>>> to be listed in details.
>>
>> I've got to take my hat off to you Tomohiro - I thought it was
>> difficult enough to update just the HOWTO in the first place. Your
>> Herculean effort here brings the two more into sync!
>>
>> I'm secretly jealous of your productivity... Plus you've set back my
>> covert plan to make the current fio man page so useless that we switch
>> to having it built from HOWTO (using make -C doc man ) via Sphinx :-).

-- 
Sitsofe | http://sucs.org/~sits/

