Return-Path: <axboe@kernel.dk>
Message-ID: <554B99DD.2000902@kernel.dk>
Date: Thu, 07 May 2015 10:59:09 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Add Windows ctime_r implementation and empty ioctl.h
 header
References: <554ADC87.2070605@cran.org.uk>
In-Reply-To: <554ADC87.2070605@cran.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 05/06/2015 09:31 PM, Bruce Cran wrote:
> I've attached a patch that adds ctime_r to the Windows build and an
> empty ioctl.h header that the build appears to need now.   There are
> linker errors after building the fio binary - I guess the other programs
> need the Windows posix.c linked in?  I'm not sure how the
> configure/build system works now, so I wasn't able to update it.

Added. Side note - your email consistently ends up in my gmail spam, for 
some reason...

What are the linker errors? I'm guessing you need to check and add your 
OS dependencies to T_OBJS in the Makefile, when targetos is Windows.

ifeq ($(CONFIG_TARGET_OS), Linux)
T_OBJS += whatever.o
endif

or something like that.

-- 
Jens Axboe


