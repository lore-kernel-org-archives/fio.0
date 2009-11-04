Return-Path: <radha@google.com>
MIME-Version: 1.0
In-Reply-To: <20091104073525.GQ8742@kernel.dk>
References: <66dfd3fe0911031633s5bef0621g99b4164c2dd174d9@mail.gmail.com>
	 <20091104073525.GQ8742@kernel.dk>
Date: Wed, 4 Nov 2009 09:12:53 -0800
Message-ID: <66dfd3fe0911040912s377b8b0eqb81fa3cad3db2d2f@mail.gmail.com>
Subject: Re: Add extra_buff_count flag
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Yes, iodepth=3Dx works. I did not realise that I could use iodepth with
sync engine as well.
Thanks
-radha

On Tue, Nov 3, 2009 at 11:35 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Nov 03 2009, Radha Ramachandran wrote:
>> Hi,
>> I was trying to use the async_verify option. Looks like if we use this
>> option for synchronous I/O, then it really doesnt do anything as after
>> every I/O is completed, we still need the asynchronous verify thread
>> to complete the verification and release the io_u so the main thread
>> can allocate this io_u for the next I/O. So to remove this bottle neck
>> I added a new option extra_buff_count. This takes an integer and the
>> code will allocate that many more extra io_us. This way when the main
>> thread has completed the I/O it will have extra io_u and buffers to
>> issue more I/Os while the asynchronous verify threads do their job.
>> This can be used with both synchronous and libaio contexts.
>
> Does iodepth=3Dx not work for that? If not, I suggest we fix that instead
> of adding a new parameter for it.
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

