Return-Path: <erwan@enovance.com>
Message-ID: <533BC63A.1020301@enovance.com>
Date: Wed, 02 Apr 2014 10:11:38 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: Surprising use of basename in finish_log_named
References: <533AD484.2040608@enovance.com> <533B0A40.3050504@kernel.dk>
In-Reply-To: <533B0A40.3050504@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


Le 01/04/2014 20:49, Jens Axboe a =E9crit :
> I don't think there's a good reason for that. So feel free to send in=20
> a (tested) patch :-)=20
Please find my branch ready for master here :=20
https://github.com/enovance/fio/tree/erwan/nobasename
> We can make it PATH_MAX instead, not a big deal
I've been looking at it and fixing it in iolog is pretty easy but I have=20
some fear that it will not be enough to fix it globally. I mean, there=20
is many occurences of paths & strings set at 256. So I'll have a look at=20
a global scale for this issue in another thread.

Erwan,

