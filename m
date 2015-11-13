Return-Path: <axboe@kernel.dk>
Subject: Re: Running a separate fio process for each disk?
References: <CADp+U7ibiKciX8_cpzGzob4oL-UF-H+W7kYuiujovD0ba=hM6A@mail.gmail.com>
 <56464ACC.9030605@kernel.dk>
 <CADp+U7gHq5VJgRFzGXvHTKN8Tyz9NDUZGePDWQ548ciyJmGr7A@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56465F00.1060504@kernel.dk>
Date: Fri, 13 Nov 2015 15:06:56 -0700
MIME-Version: 1.0
In-Reply-To: <CADp+U7gHq5VJgRFzGXvHTKN8Tyz9NDUZGePDWQ548ciyJmGr7A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Allen Schade <aschade@google.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/13/2015 03:04 PM, Allen Schade wrote:
> I'm actually launching a completely separate instance of fio for each
> disk. I want to say its because when I ran them under the same fio
> process I had issues with the json files merging the data in an
> unexpected way.

OK - in any case, that should be fine.

> Version is 2.2.6

Could you try current -git? I vaguely remember some clock issue that 
could have caused this.

-- 
Jens Axboe


