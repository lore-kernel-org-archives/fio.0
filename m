Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] pvsync2: Make hipri option probabilistic
References: <1501110306-8531-1-git-send-email-sbates@raithlin.com>
 <CALjAwxigYf==ysoHfO8JSmo6O2YDrNzczh3zocSS0U8+jZazqA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <4c37013b-8057-a4dc-5128-ae337ce3a8f0@kernel.dk>
Date: Wed, 26 Jul 2017 22:21:43 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxigYf==ysoHfO8JSmo6O2YDrNzczh3zocSS0U8+jZazqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, sbates@raithlin.com
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 07/26/2017 10:06 PM, Sitsofe Wheeler wrote:
> Hi,
> 
> On 27 July 2017 at 00:05,  <sbates@raithlin.com> wrote:
>> From: Stephen Bates <sbates@raithlin.com>
>>
>> Allow the user to set the probability of a pvsync2 IO being high
>> priority. This allows the user to investigate performance when there
>> is a mix of higher and lower priority IO.
> 
> I'll just note this seems to be a feature that people are reluctant to
> send upstream. I'm aware of at least one fio fork
> (https://github.com/Seagate/fio/commits/master ) that adds this
> feature and it's been asked about on the mailing list
> (https://www.spinics.net/lists/fio/msg05487.html ) so even if it takes
> a few rounds of polishing for you to get it in I wish you the best of
> luck!

Those are different, that's for passing in NCQ priority info. The
pvsync2 hipri option sets RWF_HIPRI, which translates into polled IO
for direct=1 in the kernel. That goes for both the github repo and
the email on the list. It's pointless to add this to fio, before a
kernel API exists for passing in priority information. RWF_HIPRI
means polling now.

Not that this is the right list, but I would suggest that someone
wanting to pursue this on the kernel side would add it through the
new fcntl F_SET_RW_HINT or F_SET_FILE_RW_HINT interface that was
added in 4.13:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c75b1d9421f80f4143e389d2d50ddfc8a28c8c35

Once that is done, then support can be added to fio.

-- 
Jens Axboe


