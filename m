Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2] pvsync2: Add hipri_probability option
References: <1501173847-9433-1-git-send-email-sbates@raithlin.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e2ab8120-9a35-766d-8490-79bab4c1cf7b@kernel.dk>
Date: Thu, 27 Jul 2017 11:46:44 -0600
MIME-Version: 1.0
In-Reply-To: <1501173847-9433-1-git-send-email-sbates@raithlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: sbates@raithlin.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 07/27/2017 10:44 AM, sbates@raithlin.com wrote:
> From: Stephen Bates <sbates@raithlin.com>
> 
> Allow the user to set the probability of a pvsync2 IO being high
> priority. Add a new option for the pvsync2 engine called
> --hipri_probability will takes values in the range (0, 100) and use
> that as a probability for setting RWF_HIPRI. The default for this
> option is 100 so exisiting users of --hirpi are unaffected by
> default.

Sorry to keep nit picking on this, but the reason I suggested
_percentage instead of _probability is that the former is in
the 0..100 range whereas the latter I would assume would be in
the 0..1 range. Since you've implemented it as a percentage,
and since we have other options like that, I think we should
make it hipri_percentage instead.

-- 
Jens Axboe


