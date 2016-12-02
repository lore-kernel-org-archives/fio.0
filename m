Return-Path: <axboe@kernel.dk>
Subject: Re: fio assert
References: <CAKZcxgdhYey+dbUN7T5mW=Ghfw34=OtNrocJxqDH8k4fQ1tTJw@mail.gmail.com>
 <CALjAwxjVK5v+JNo2Ww9m3cfwCyjiEMVzjdrYUpMsht2Q2j1AOA@mail.gmail.com>
 <CAKZcxgc2k=o2_kbYdFmxScxC2Zns+SKi++=rdxvwD2vGj83RZg@mail.gmail.com>
 <CAKZcxgfr_RfHD0XcDV0nMgFhU1nPNEzP0GciE-Unw-i-k3eaSw@mail.gmail.com>
 <CAKZcxgeXnostqxPAGi2ek1x+Tw7_CxrnjVzuy3QrJhwbERewnQ@mail.gmail.com>
 <CALjAwxia8JGF2uErqV3BdqLt7YTwZ=qwAKMmU2xJL1FnmcjvKg@mail.gmail.com>
 <CAKZcxgeOzDaJ5vscKZGE2vH=YqEaOwzEyS7j2o6fj0EpvV3z1A@mail.gmail.com>
 <42f4de17-7106-95de-3da9-c4f61bc541c8@kernel.dk>
 <CAKZcxgcrkn=O+jvh6U1cvwgu_EV6dUnKANPbZTW9o8ut0UV9RQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <66ef316c-e723-f4a1-0bec-1c3eda88f594@kernel.dk>
Date: Thu, 1 Dec 2016 17:33:15 -0700
MIME-Version: 1.0
In-Reply-To: <CAKZcxgcrkn=O+jvh6U1cvwgu_EV6dUnKANPbZTW9o8ut0UV9RQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jaze Lee <jazeltq@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/01/2016 05:10 PM, Jaze Lee wrote:
> Thanks, it works. But can u explain more about how it works?
> I thought we may change stat.c.....

It wasn't a problem in stat.c, that was just the symptom. Fio has to
regrow the log segments, and it needs a call at the right time to do
that. For rated IO, we were missing that. The patch fixes that up.

Thanks for testing, I'll commit the fix.

-- 
Jens Axboe


