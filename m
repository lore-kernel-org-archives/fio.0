Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1501110306-8531-1-git-send-email-sbates@raithlin.com>
References: <1501110306-8531-1-git-send-email-sbates@raithlin.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 27 Jul 2017 05:06:45 +0100
Message-ID: <CALjAwxigYf==ysoHfO8JSmo6O2YDrNzczh3zocSS0U8+jZazqA@mail.gmail.com>
Subject: Re: [PATCH] pvsync2: Make hipri option probabilistic
Content-Type: text/plain; charset="UTF-8"
To: sbates@raithlin.com
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

On 27 July 2017 at 00:05,  <sbates@raithlin.com> wrote:
> From: Stephen Bates <sbates@raithlin.com>
>
> Allow the user to set the probability of a pvsync2 IO being high
> priority. This allows the user to investigate performance when there
> is a mix of higher and lower priority IO.

I'll just note this seems to be a feature that people are reluctant to
send upstream. I'm aware of at least one fio fork
(https://github.com/Seagate/fio/commits/master ) that adds this
feature and it's been asked about on the mailing list
(https://www.spinics.net/lists/fio/msg05487.html ) so even if it takes
a few rounds of polishing for you to get it in I wish you the best of
luck!

-- 
Sitsofe | http://sucs.org/~sits/

