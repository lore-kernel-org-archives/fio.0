Return-Path: <aschade@google.com>
MIME-Version: 1.0
In-Reply-To: <56465F00.1060504@kernel.dk>
References: <CADp+U7ibiKciX8_cpzGzob4oL-UF-H+W7kYuiujovD0ba=hM6A@mail.gmail.com>
	<56464ACC.9030605@kernel.dk>
	<CADp+U7gHq5VJgRFzGXvHTKN8Tyz9NDUZGePDWQ548ciyJmGr7A@mail.gmail.com>
	<56465F00.1060504@kernel.dk>
Date: Fri, 20 Nov 2015 10:28:40 -0800
Message-ID: <CADp+U7i=OPhuF9+nB1MW0ScaPv5sX3mL4ASdJ-8AGrDMfX71oA@mail.gmail.com>
Subject: Re: Running a separate fio process for each disk?
From: Allen Schade <aschade@google.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>, Caio Villela <caio@google.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Jens,
We tried with the latest version and gathered some detailed info.

Hey Caio,
Can you paste your experiment information as a reply here. Also switch
your email to plain text mode or the vger.kernel.org email address
will reject your email as spam.

On Fri, Nov 13, 2015 at 2:06 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 11/13/2015 03:04 PM, Allen Schade wrote:
>>
>> I'm actually launching a completely separate instance of fio for each
>> disk. I want to say its because when I ran them under the same fio
>> process I had issues with the json files merging the data in an
>> unexpected way.
>
>
> OK - in any case, that should be fine.
>
>> Version is 2.2.6
>
>
> Could you try current -git? I vaguely remember some clock issue that could
> have caused this.
>
> --
> Jens Axboe
>

