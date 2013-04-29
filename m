Return-Path: <jason.b.akers@intel.com>
From: "Akers, Jason B" <jason.b.akers@intel.com>
Subject: RE: syscall problem on Android x86
Date: Mon, 29 Apr 2013 18:16:18 +0000
Message-ID: <372C7AE269BA5E4D92B1082F530ED4B85069D8E7@ORSMSX110.amr.corp.intel.com>
References: <372C7AE269BA5E4D92B1082F530ED4B85069CD30@ORSMSX110.amr.corp.intel.com>
 <CAKCZDgmFea+X0euVng1Fg3kEBrmmxc0SbjCk3W=n+HGa0NVJJQ@mail.gmail.com>
 <20130427022713.GM9563@kernel.dk>
In-Reply-To: <20130427022713.GM9563@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Aaron Carroll <xaaronc@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

> > As Jens said this has nothing to do with Android per se, only that its
> > libc does not implement shm*() so we have to do it ourselves.
>=20
> Yep. Jason, it should be fairly easy to wire up ipc(). Or you can do the =
android
> variant, I'm fine with either.
>=20
> --
> Jens Axboe

Thanks for the feedback. I'm leaning toward using ashmem in an attempt to m=
ake it forward-compatible with future android NDKs. We'll see how ugly it g=
ets.
I'll submit a patch review request when it's ready.

Jason Akers



