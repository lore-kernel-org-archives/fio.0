Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3] pvsync2: Add hipri_percentage option
References: <1501178931-9691-1-git-send-email-sbates@raithlin.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c04a6902-8836-7596-e257-0b661f2717b5@kernel.dk>
Date: Thu, 27 Jul 2017 12:42:39 -0600
MIME-Version: 1.0
In-Reply-To: <1501178931-9691-1-git-send-email-sbates@raithlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: sbates@raithlin.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 07/27/2017 12:08 PM, sbates@raithlin.com wrote:
> From: Stephen Bates <sbates@raithlin.com>
> 
> Allow the user to set the probability of a pvsync2 IO being high
> priority. Add a new option for the pvsync2 engine called
> --hipri_percentage will takes values in the range (0, 100) and use
> that as a probability for setting RWF_HIPRI. The default for this
> option is 100 so exisiting users of --hirpi are unaffected.

Getting there! One last request - please dump all the ifdef
FIO_HAVE_PWRITEV2 for headers, struct members, init, etc. It's a lot
more maintainable without that.

-- 
Jens Axboe


