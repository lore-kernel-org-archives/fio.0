Return-Path: <aaronc@cse.unsw.edu.au>
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Date: Thu, 14 Mar 2013 12:47:44 +1100
Message-ID: <51412C40.3080105@cse.unsw.edu.au>
MIME-Version: 1.0
Subject: Re: android support patch [review request]
References: <CAExtNyEmoPjbwG6J8ic7_KExTqHzo1rWwsUagQpxZA90U36juw@mail.gmail.com>
In-Reply-To: <CAExtNyEmoPjbwG6J8ic7_KExTqHzo1rWwsUagQpxZA90U36juw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Oleg Matcovsky <olegmatcovsky@gmail.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 14/03/13 12:13 PM, Oleg Matcovsky wrote:
> Please provide feedback for patch: enables Android fio build as part of
> AOSP.
> 
> I have tested compilation on ICS based tree:
>  - fio top of tree under mydroid/external/fio
>  - apply patch
>  - add "fio" to PRODUCT_PACKAGES
>  - rebuild

Is it possible to have the Android build system invoke make?  That would
be nicer from a maintenance perspective.


  -- Aaron


