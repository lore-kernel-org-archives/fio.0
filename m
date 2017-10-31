Return-Path: <axboe@kernel.dk>
Subject: Re: FIO windows
References: <MWHPR11MB2045B4FFEB905261E1FAFD1E875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <863271c2-eeb4-b770-bdfa-89746d4d9c70@kernel.dk>
 <MWHPR11MB2045DFA579DB2BDC5B1EA466875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <2feebb78-c436-3187-f28d-588f18b9dfc4@kernel.dk>
 <CALjAwxiwWDghXZpsN9vzR7AjwTgHU-g+iYeogbWvO5p6itMd6A@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ddbb5d83-cc30-db5f-5c98-0b5809a15d76@kernel.dk>
Date: Tue, 31 Oct 2017 13:50:21 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxiwWDghXZpsN9vzR7AjwTgHU-g+iYeogbWvO5p6itMd6A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: David Hare <david.hare@primarydata.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is useful information, any chance that could get added
to the documentation?


On 10/31/2017 01:46 PM, Sitsofe Wheeler wrote:
> Hi,
> 
> Yes, AppVeyor makes the builds it does available for download. For
> example if you look at the latest master version of fio over on
> https://github.com/axboe/fio/commits/1de80624466405bccdbc4607d71cd249320da3f1
> , click the green tick and choose Details for AppVeyor you'll end up
> on https://ci.appveyor.com/project/axboe/fio/build/1.0.380 . You can
> then select a build like the x86_64 one and the click the Artifacts
> tab taking you to a page like
> https://ci.appveyor.com/project/axboe/fio/build/1.0.380/job/ooua768a53epnxeu/artifacts
> and you can then download the msi on that page.
> 
> On 31 October 2017 at 18:51, Jens Axboe <axboe@kernel.dk> wrote:
>> Not sure, I generally don't touch that side of things. I know that
>> appveyor builds all of them, but I don't know if they make the build
>> available.
>>
>> CC'ing the list, folks there would know...
>>
>> On 10/31/2017 12:47 PM, David Hare wrote:
>>> Hi Jens,
>>>
>>> Can't find an installer for 3.1 for windows. Not sure if anyone compiled it yet?
>>> -Dave
>>>
>>
>> --
>> Jens Axboe
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 


-- 
Jens Axboe


