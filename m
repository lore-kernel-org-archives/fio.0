Return-Path: <axboe@kernel.dk>
Message-ID: <533C1434.2070203@kernel.dk>
Date: Wed, 02 Apr 2014 07:44:20 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Surprising use of basename in finish_log_named
References: <533AD484.2040608@enovance.com> <533B0A40.3050504@kernel.dk> <533BC63A.1020301@enovance.com>
In-Reply-To: <533BC63A.1020301@enovance.com>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
To: Erwan Velu <erwan@enovance.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-04-02 02:11, Erwan Velu wrote:
>
> Le 01/04/2014 20:49, Jens Axboe a =EF=BF=BDcrit :
>> I don't think there's a good reason for that. So feel free to send in
>> a (tested) patch :-)
> Please find my branch ready for master here :
> https://github.com/enovance/fio/tree/erwan/nobasename

Thanks, pulled.

>> We can make it PATH_MAX instead, not a big deal
> I've been looking at it and fixing it in iolog is pretty easy but I have
> some fear that it will not be enough to fix it globally. I mean, there
> is many occurences of paths & strings set at 256. So I'll have a look at
> a global scale for this issue in another thread.

OK, sounds good. I'm pretty sure I consistently used 256 in most places.=20
One problematic area might be around the server/client protocol. Maybe=20
it's time to finally improve that... So don't worry too much about that=20
part.

--=20
Jens Axboe



