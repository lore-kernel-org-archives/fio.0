Return-Path: <jazeltq@gmail.com>
MIME-Version: 1.0
In-Reply-To: <66ef316c-e723-f4a1-0bec-1c3eda88f594@kernel.dk>
References: <CAKZcxgdhYey+dbUN7T5mW=Ghfw34=OtNrocJxqDH8k4fQ1tTJw@mail.gmail.com>
 <CALjAwxjVK5v+JNo2Ww9m3cfwCyjiEMVzjdrYUpMsht2Q2j1AOA@mail.gmail.com>
 <CAKZcxgc2k=o2_kbYdFmxScxC2Zns+SKi++=rdxvwD2vGj83RZg@mail.gmail.com>
 <CAKZcxgfr_RfHD0XcDV0nMgFhU1nPNEzP0GciE-Unw-i-k3eaSw@mail.gmail.com>
 <CAKZcxgeXnostqxPAGi2ek1x+Tw7_CxrnjVzuy3QrJhwbERewnQ@mail.gmail.com>
 <CALjAwxia8JGF2uErqV3BdqLt7YTwZ=qwAKMmU2xJL1FnmcjvKg@mail.gmail.com>
 <CAKZcxgeOzDaJ5vscKZGE2vH=YqEaOwzEyS7j2o6fj0EpvV3z1A@mail.gmail.com>
 <42f4de17-7106-95de-3da9-c4f61bc541c8@kernel.dk> <CAKZcxgcrkn=O+jvh6U1cvwgu_EV6dUnKANPbZTW9o8ut0UV9RQ@mail.gmail.com>
 <66ef316c-e723-f4a1-0bec-1c3eda88f594@kernel.dk>
From: Jaze Lee <jazeltq@gmail.com>
Date: Fri, 2 Dec 2016 12:10:34 +0800
Message-ID: <CAKZcxgec6vX+pk8Xhk08P3YMz7Zn-S69bs78Z24FXPibg+s=YQ@mail.gmail.com>
Subject: Re: fio assert
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

OK. Thanks  Jens.

2016-12-02 8:33 GMT+08:00 Jens Axboe <axboe@kernel.dk>:
> On 12/01/2016 05:10 PM, Jaze Lee wrote:
>> Thanks, it works. But can u explain more about how it works?
>> I thought we may change stat.c.....
>
> It wasn't a problem in stat.c, that was just the symptom. Fio has to
> regrow the log segments, and it needs a call at the right time to do
> that. For rated IO, we were missing that. The patch fixes that up.
>
> Thanks for testing, I'll commit the fix.
>
> --
> Jens Axboe
>



--=20
=E8=B0=A6=E8=B0=A6=E5=90=9B=E5=AD=90

