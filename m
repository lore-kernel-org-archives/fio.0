Return-Path: <radha@google.com>
MIME-Version: 1.0
In-Reply-To: <20091103204704.GO8742@kernel.dk>
References: <66dfd3fe0911031240o786976ewfca457239e1b9048@mail.gmail.com>
	 <20091103204240.GN8742@kernel.dk> <20091103204704.GO8742@kernel.dk>
Date: Tue, 3 Nov 2009 13:43:35 -0800
Message-ID: <66dfd3fe0911031343j28762e13i5dafdc8c9de50b00@mail.gmail.com>
Subject: Re: Fix race condition when using asynch verify
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Looks good.
Thanks
-radha

On Tue, Nov 3, 2009 at 12:47 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Nov 03 2009, Jens Axboe wrote:
>> On Tue, Nov 03 2009, Radha Ramachandran wrote:
>> > Hi,
>> > I discovered the race condition when using asynch verify with libaio e=
ngine.
>> > The code assumes that because the td->cur_depth value is not 0 that
>> > there is still I/O pending and issues io_getevents when the I/O was
>> > actually being verified by the asynchronous verify thread. This causes
>> > the code to hang.
>> >
>> > I have attached a patch along to fix this issue.
>>
>> Thanks for the fix, that is indeed a race. I'll merge your patch, but
>> change the io_u->in_cur_depth to be a IO_U_F_ flag.
>
> This is what I commited:
>
> http://git.kernel.dk/?p=3Dfio.git;a=3Dcommit;h=3D0c41214ff4e6f31f8df64aac=
37be7853aada6f1f
>
> Please double check, thanks!
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

