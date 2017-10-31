Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB20457601992059B3E7C48865875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
References: <MWHPR11MB2045B4FFEB905261E1FAFD1E875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <863271c2-eeb4-b770-bdfa-89746d4d9c70@kernel.dk> <MWHPR11MB2045DFA579DB2BDC5B1EA466875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <2feebb78-c436-3187-f28d-588f18b9dfc4@kernel.dk> <CALjAwxiwWDghXZpsN9vzR7AjwTgHU-g+iYeogbWvO5p6itMd6A@mail.gmail.com>
 <ddbb5d83-cc30-db5f-5c98-0b5809a15d76@kernel.dk> <MWHPR11MB2045095AA21ED4BF8BA38021875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxhx45=uTivppp3A1ACdGmon-oaH9S4b41MJQ6TfQCP7ZA@mail.gmail.com>
 <MWHPR11MB204527783F0D03DE6DE3556D875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <CALjAwxjO0i34McDkRRoeYCxW=CD4WG_=2Aohh=UA34tLL8w3AQ@mail.gmail.com> <MWHPR11MB20457601992059B3E7C48865875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 31 Oct 2017 21:27:31 +0000
Message-ID: <CALjAwxi+1Djmm_0SqEDTYV_Oc5yBDZYyak1Vd3S6Bsr8BNjjqg@mail.gmail.com>
Subject: Re: FIO windows
Content-Type: text/plain; charset="UTF-8"
To: David Hare <david.hare@primarydata.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

On 31 October 2017 at 20:46, David Hare <david.hare@primarydata.com> wrote:
>
> If I remove - "blocksize=64k" "direct=1" "thread=8" "size=1g" "time_based
> with runtime=10" or ":P\:\\testfile:" (the 9th drive) the file works.
>
> The below file generates this error:
> fio: pid=8404, err=22/file:ioengines.c:333, func=td_io_queue, error=Invalid
> argument
> asdf: (groupid=0, jobs=1): err=22 (file:ioengines.c:333, func=td_io_queue,
> error=Invalid argument): pid=8404: Tue Oct 31
>
>
> [global]
>
> ioengine=windowsaio
> blocksize=64k
> direct=1
>
> thread=8
> size=1g
>
> time_based
> runtime=10
>
> [asdf]
> filename=F\:\\testfile:G\:\\testfile:H\:\\testfile:I\:\\testfile:J\:\\testfile:K\:\\testfile:L\:\\testfile:M\:\\testfile:P\:\\testfile:

"thread=8" should be the same as using "thread" and would be required
on Windows. "P\:\\testfile:" should be "P\:\\testfile" (note the lack
of trailing colon - see the examples in
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-filename
). time_based and runtime sound required. Perhaps a smaller blocksize
means it takes longer than 10 seconds to hit the problem - presumably
blocksize=128k is still as problematic? I'm also assuming the problem
still happens with size=512m ?

-- 
Sitsofe | http://sucs.org/~sits/

