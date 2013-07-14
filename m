Return-Path: <erwan@enovance.com>
Message-ID: <51E30316.7000009@enovance.com>
Date: Sun, 14 Jul 2013 21:59:18 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: Pull Request for Adding 2 new tools around fio
References: <51C9CFA8.6080703@enovance.com> <20130627090249.GM25599@kernel.dk> <51D6C92C.3@enovance.com> <20130705211727.GD6694@kernel.dk> <51DE86F3.8020902@enovance.com> <20130713133550.GC10118@kernel.dk>
In-Reply-To: <20130713133550.GC10118@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Le 13/07/2013 15:35, Jens Axboe a =E9crit :
> Pulled in, thanks! I'll get to play with it for real next week. In the =
future, if you have updates, please send a proper pull request to this li=
st (and CC me) and include a full diff of the changes as well in the emai=
l. Basically do a git request-pull, then append the full diff of all chan=
ges as well.=20
Thanks Jens !

I'll proceed this way with pleasure. I'm already working on patches for g=
enfio.

The thing I like on fio : Everytime I need something that I'm not using..=
.. fio does have it.
Just decovered exec_{pre|post}run solving perfectly my need.

Cheers,
Erwan


