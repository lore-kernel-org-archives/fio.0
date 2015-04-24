Return-Path: <axboe@kernel.dk>
Message-ID: <553A7356.9080303@kernel.dk>
Date: Fri, 24 Apr 2015 10:46:14 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: A probable minor mistake in HOWTO page
References: <CAGGT8x4wvSkDni2+T8mViRCQHQiVt9C1AwMTaU8rk4rvNRaK4A@mail.gmail.com>
In-Reply-To: <CAGGT8x4wvSkDni2+T8mViRCQHQiVt9C1AwMTaU8rk4rvNRaK4A@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Mansour Shafaei Moghaddam <mansoor.shafaei@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/07/2015 11:23 AM, Mansour Shafaei Moghaddam wrote:
> Hi,
>
> I found a minor mistake in the Fio's HOWTO page. According to this
> document the "wait" command considers the offset as the number of
> milliseconds which it must hold on before submitting the next I/O. A
> very simple experiment with a short trace including those "wait"
> commands shows that the numbers that you put as offset are interpreted
> as the time for submission of next I/O not the amount of wait time
> between them. In other words, the value in offset field is the
> absolute delay from the beginning of run not the relative delay.
>
> P.S.: The version of fio I have been working on is 2.1.11, but I saw
> the same explanation in more recent versions' HOWTO page as well. So,
> decided to share it with you.

Thanks, updated. It is indeed a relative time.

-- 
Jens Axboe


