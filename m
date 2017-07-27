Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v4] pvsync2: Add hipri_percentage option
References: <1501185735-9828-1-git-send-email-sbates@raithlin.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b5561647-f797-d456-0cd6-dd315aae74ae@kernel.dk>
Date: Thu, 27 Jul 2017 14:12:59 -0600
MIME-Version: 1.0
In-Reply-To: <1501185735-9828-1-git-send-email-sbates@raithlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: sbates@raithlin.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 07/27/2017 02:02 PM, sbates@raithlin.com wrote:
> From: Stephen Bates <sbates@raithlin.com>
> 
> Allow the user to set the probability of a pvsync2 IO being high
> priority. Add a new option for the pvsync2 engine called
> --hipri_percentage will takes values in the range (0, 100) and use
> that as a probability for setting RWF_HIPRI. The default for this
> option is 100 so exisiting users of --hirpi are unaffected.

Applied, thanks Stephen.

-- 
Jens Axboe


