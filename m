Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <2feebb78-c436-3187-f28d-588f18b9dfc4@kernel.dk>
References: <MWHPR11MB2045B4FFEB905261E1FAFD1E875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <863271c2-eeb4-b770-bdfa-89746d4d9c70@kernel.dk> <MWHPR11MB2045DFA579DB2BDC5B1EA466875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <2feebb78-c436-3187-f28d-588f18b9dfc4@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 31 Oct 2017 19:46:51 +0000
Message-ID: <CALjAwxiwWDghXZpsN9vzR7AjwTgHU-g+iYeogbWvO5p6itMd6A@mail.gmail.com>
Subject: Re: FIO windows
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: David Hare <david.hare@primarydata.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

Yes, AppVeyor makes the builds it does available for download. For
example if you look at the latest master version of fio over on
https://github.com/axboe/fio/commits/1de80624466405bccdbc4607d71cd249320da3f1
, click the green tick and choose Details for AppVeyor you'll end up
on https://ci.appveyor.com/project/axboe/fio/build/1.0.380 . You can
then select a build like the x86_64 one and the click the Artifacts
tab taking you to a page like
https://ci.appveyor.com/project/axboe/fio/build/1.0.380/job/ooua768a53epnxeu/artifacts
and you can then download the msi on that page.

On 31 October 2017 at 18:51, Jens Axboe <axboe@kernel.dk> wrote:
> Not sure, I generally don't touch that side of things. I know that
> appveyor builds all of them, but I don't know if they make the build
> available.
>
> CC'ing the list, folks there would know...
>
> On 10/31/2017 12:47 PM, David Hare wrote:
>> Hi Jens,
>>
>> Can't find an installer for 3.1 for windows. Not sure if anyone compiled it yet?
>> -Dave
>>
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Sitsofe | http://sucs.org/~sits/

