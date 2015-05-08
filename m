Return-Path: <axboe@kernel.dk>
Message-ID: <554C013D.60201@kernel.dk>
Date: Thu, 07 May 2015 18:20:13 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Add Windows ctime_r implementation and empty ioctl.h
 header
References: <554ADC87.2070605@cran.org.uk> <554B99DD.2000902@kernel.dk> <554BD378.70209@cran.org.uk> <554BD3CE.6090609@kernel.dk> <554BD8A5.6040104@cran.org.uk> <554BD9E3.4040005@kernel.dk> <554BEDB1.80805@cran.org.uk>
In-Reply-To: <554BEDB1.80805@cran.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 05/07/2015 04:56 PM, Bruce Cran wrote:
> On 5/7/2015 3:32 PM, Jens Axboe wrote:
>> Honestly, that should just use PATH_MAX. I'll make that change instead
>> of adding this patch
> 
> Thanks.  And one last patch, to fix the Windows installer build this time.

Great thanks, and with that, 2.2.8 has been tagged.

-- 
Jens Axboe


